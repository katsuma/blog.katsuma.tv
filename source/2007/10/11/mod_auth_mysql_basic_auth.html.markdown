---
title: mod_auth_mysqlを利用してBasic認証にMySQLのデータを利用する
date: 2007/10/11
tags: apache
published: true

---

<p>認証APIについていろいろ調査をしていて、<a href="http://groups.google.com/group/twitter-development-talk/web/api-documentation">TwitterAPI</a>でPOST系APIで認証にBasic認証を利用している箇所で、どうやって実装しているんだろう？という話になりました。「まさか全ユーザの情報を.htpasswdファイルなんかに格納しているはずは無いだろうに。。。」と思いながら調べていると、Basic認証のユーザ情報を既存のMySQLのDB/Tableと統合するためのApacheモジュール「<a href="http://modauthmysql.sourceforge.net/">mod_auth_mysql</a>」なるものを発見しました。この利用方法について、まとめてみたいと思います。</p>

<h3>MySQL以外もOK</h3>
<p>普段はRDBMSにはMySQLを利用しているので、mod_auth_mysqlについて調査をしていましたが、他のRDBMS用にもモジュールは用意されているようです。たとえば、<a href="http://modules.apache.org/">Apacheのmoduleの公式サイト</a>で「mod_auth」で検索すると、<a href="http://www.outoforder.cc/projects/apache/mod_authn_dbi/">mod_authn_dbi</a>なるモジュールはPostgreSQLやSQLiteにも対応している、との表記があります。他のRDBMSをご利用の方はそのあたりの検討をしてみてもいいと思います。</p>

<h3>インストールは簡単</h3>
<p>Fedoraならyumでインストールが可能です。</p>
<p><pre>yum -y install mod_auth_mysql</pre></p>
<p>これで、mod_auth_mysql3.0がインストールされます。yumでインストールを行うと、Apacheに自動的にロードされる状態になるようで、特にhttpd.confでLoadModuleさせなくても大丈夫なようです。</p>

<h3>httpd.confで設定</h3>
<p>新たに必要であろう、設定項目は次の通りです。</p>
<p>
<pre>
# MySQLによる認証を有効に
AuthMySQLEnable On

# mysqldへの接続Socket
AuthMySQLSocket /var/lib/mysql/mysql.sock

# mysqldの場所
AuthMySQLHost localhost

# mysqldへの接続ユーザ
AuthMySQLUser auth_httpd

# mysqldへの接続パスワード
AuthMySQLPassword hogehoge

# 認証を行う情報が格納されたDB
AuthMySQLDB account

# 認証を行う情報が格納されたテーブル
AuthMySQLUserTable member_info

# 認証を行うユーザ名が格納されているカラム名
AuthMySQLNameField member_id

# 認証を行うパスワードが格納されているカラム名
AuthMySQLPasswordField member_password

# 認証を行うパスワードが格納されているカラムの暗号方式
AuthMySQLPwEncryption sha1

# パスワード無しのユーザからの接続を許可するかどうか
AuthMySQLNoPasswd Off

# 以下はBasic認証を行う場合のお約束
AuthGroupFile /dev/null
AuthName "Enter your ID and password"
AuthType Basic
require valid-user
</pre>
</p>

<p>ほとんどの項目は読んでいただくと理解できるかと思います。ポイントは次の通り。</p>

<h4>Socketに注意</h4>
<p>AuthMySQLSocketは、初期値では「/tmp/mysql.sock」となっています。ただ、FedoraにMySQLをyumでインストールした場合、/etc/my.cnfによるとSocketは/var/lib/mysql/mysql.sockとなっています。DBの情報は注意して設定すると思うのですが、Socketの情報は見逃しがちなので要注意です。ご利用の環境にあわせたチェックを忘れずに！</p>

<h4>暗号化方式は適切なものを</h4>
<p>パスワード情報は、DBに生データのまま保存している場合は稀だと思います。今回はSHA1でハッシュ化して保存していたのでAuthMySQLPwEncryptionは「sha1」を採用しています。他にも次のような暗号化方式が選択できます。</p>

<p>
<ul>
<li>none: not encrypted (plain text)</li>
<li>crypt: UNIX crypt() encryption</li>
<li>scrambled: MySQL PASSWORD encryption</li>
<li>md5: MD5 hashing</li>
<li>aes: Advanced Encryption Standard (AES) encryption</li>
<li>sha1: Secure Hash Algorihm (SHA1)</li>
</ul>
</p>

<p>なお、これらの設定項目の詳細については公式サイトの<a href="http://modauthmysql.sourceforge.net/CONFIGURE">CONFIGURE</a>ページから参照できます。あわせてご参照ください。</p>

<h3>エラー時のデバッグ方法</h3>
<p>基本的に設定は特に難しい箇所も無いのですが、それでも実際に設定を行っているとハマるポイントもいろいろでてきます。そんな場合は次の項目に注目することで問題解決につながるかもしれません。</p>

<h4>MySQLのクエリログ</h4>
<p>HTTPリクエストが発行され、Basic認証が行われるたびにApacheはmysqldに対してselect文を発行し、ユーザ情報を取得しようとします。ここで発行されたクエリのログを保存し、正しいselect文が発行されていたかどうかを確認することができます。クエリログは、/etc/my.cnfの[mysqld]のセクションに次の項目を追記します。</p>

<p><pre>
log
</pre></p>

<p>この「log」の１行を追加し、mysqldを再起動させると「/var/lib/mysql/[host名].log」という名前でログファイルが保存されます。ここを確認することで意図したテーブルやカラムを参照しているかどうか確認できます。</p>

<p>ちなみにMySQLのログはレプリケーションでも用いるバイナリログを残すことの方が多いと思いますが、バイナリログはinsert, delete, updateなどWrite系のログのみ残り、selectのログは残りません。つまり今回の場合の問題解決には役立たないので要注意です。僕は最初バイナリログからアプローチし、軽くハまってました。。</p>

<h4>Apacheのエラーログ</h4>
<p>同じく、発行したSQL文でエラーがおきた場合、Apacheのエラーログにもその情報が残ります。エラーログは「/var/log/httpd/error_log*」に残ります。ここを確認するとまたヒントがあるかもしれません。</p>

<h3>使いこなすと楽しい！</h3>
<p>このモジュールは単純にBasic認証のページにおけるユーザ管理にも使えますが、何よりTwitterライクなAPIの構築にも役立つと思います。一度目を通しておいて損はないモジュールだと思いますので、ぜひ皆さんも導入を検討ください。</p>
