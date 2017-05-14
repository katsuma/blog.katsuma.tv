---
title: MySQLでrootを削除したときの対処法
date: 2007/07/18 00:05:09
tags: mysql
published: true

---

<p>経緯は自分でもまったく分からないのですが、気づいたらMySQLのrootアカウントを削除してしまいました。普段は開発中のDBに対してselect, update, insert, deleteのみを許した限定的な権限のユーザでゴニョゴニョしていたので、いざ新規テーブルを作成しようかと思ったらrootでつなげない→途方に暮れる、ということになったわけです。</p>

<p>よくある事例としては「<a href="http://www.google.co.jp/search?hl=ja&client=firefox&rls=org.mozilla%3Aja%3Aofficial&hs=jY8&q=MySQL%E3%80%80root+%E3%83%91%E3%82%B9%E3%83%AF%E3%83%BC%E3%83%89%E3%80%80%E5%BF%98%E3%82%8C%E3%81%9F&btnG=%E6%A4%9C%E7%B4%A2&lr=lang_ja">rootのパスワードを忘れました</a>」ということはあるかと思うのですが、「rootアカウント自体を削除してしまいました」という事例はなかなか聞きません。と、いうわけで地味に対応が困ったのですが、何とか復旧できたのでそのメモを記しておきます。OSはFedora5です。</p>

<p>まず、起動しているmysqldを停止させます。Fedoraだと(*)</p>
<p><pre>/etc/init.d/mysqld stop</pre></p>
<p>で、停止します。<br />(*) 起動パスなどは適宜ご利用の環境にあわせて読んでいただければと思います。</p>

<p>その後、認証なしでMySQLサーバに接続するために、認証をパスさせるようにします。まず、</p>
<p><pre>/usr/bin/mysqld_safe --skip-grant-tables</pre></p>
<p>で、MySQLサーバを起動します。この上で</p>

<p><pre>mysql -u root</pre></p>
<p>で、パス無しでMySQLサーバに接続できます。ここではパス無しrootが暫定的(?)に作られている状態なので、mysql DBを選択し、パスワードを設定します。</p>

<p><pre>use mysql;
update user set password=PASSWORD('NEW_PASSWORD') where user='root';
</pre></p>

<p>これでパスワードが設定されました。でも、この段階ではまだrootとは名ばかりで、実際は何もできないユーザにすぎないので、権限を再設定します。</p>

<p><pre>update user set Select_priv='Y', Insert_priv='Y', Update_priv='Y', Delete_priv='Y', Create_priv='Y', Grant_priv='Y', Alter_priv='Y' where User='root';</pre></p>

<p>これで、情報をflushし、接続を閉じます。</p>

<p><pre>flush privileges.
exit;
</pre></p>

<p>ここで、稼動中のmysqldを停止します。init.d/mysqld 以外からの終了方法を忘れたので（おっと。。）、面倒なのでプロセスを直接Killします。</p>

<p><pre>ps aux | grep mysqld_safe
kill -KILL [PID]
</pre></p>

<p>普通のmysqldを起動します。</p>
<p><pre>/etc/init.d/mysqld start</pre></p>

<p>これで設定したパスワードでrootで接続し、自由にいろいろできると思います。権限をupdateさせるときにいろいろ行いましたが、もしかすると過不足があるかもしれません。僕の場合はcreate tableを行うことが目的だったので、必要そうな権限をとりあえず有効にしてみましたが、適宜調整ください。</p>

<p>で、今回の件で分かったのは、権限が正しく設定されていないとmysql DBすらrootで覗くことができないんですね。。あと--skip-grant-tablesで起動していると、grant構文が無効になっている、とかも初めて知りました。まー苦労してこそいろいろ勉強になる、ということですねぇ。</p>

