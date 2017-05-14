---
title: Mac OSXにredisをインストール
date: 2010/03/22 02:43:04
tags: kvs, ruby
published: true

---

<p>Tokyo Cabinet / Tokyo Tyrantに代表されるKey-Value Storage,いわゆるKVSは多くのプロダクトが乱立してなかなか違いを理解するのも難しい状況になりつつあるのですが、ここ数日は<a href="http://code.google.com/p/redis/">redis</a>に注目をしています。redisとは何ぞやというと、公式サイトには次のような特徴が挙げられています。</p>

<p>
<ul>
<li>memcachedのようないわゆるKVS</li>
<li>valueにはStringだけではなく、List, Setも利用できる</li>
<li>データに対するpush/pop, add/removeのような操作はすべてatomicな操作</li>
<li>通常はメモリ上で動作するが、定期的にデータをディスクに書き出す（常に書き出すような設定も可能）</li>
<li>Master-Slaveのレプしケーションをサポート</li>
<li>Ruby, Python, Perl, Java...などの各言語のバインディングを用意</li>
</ul>
</p>

<p>と、かなり豪華なスペックで、なんでもかかってこい！なプロダクトです。国内の利用例はまだ聴いた事無いですが、海外では<a href="http://www.atmarkit.co.jp/news/201003/16/redis.html">githubやCraigslistが採用</a>したことでここ最近有名になってきました。</p>

<p>さて、そんなredisの開発環境を整えてみたいと思います。環境はMac OSX 10.5。</p>

<h3>redisのインストール</h3>
<p>ソースコードから入れてもいいのですが、Macの場合は、MacPortsでインストール可能です。</p>
<p><pre>
$sudo port -d sync
</pre></p>

<p>で、インストールリストを最新の状態にしておいて</p>
<p><pre>
$sudo port install redis
</pre></p>

<p>で、インストールされる、、はずなのですが、僕の環境だと途中で止まりました。</p>

<p><pre>
$ sudo port install redis
--->  Fetching redis
--->  Attempting to fetch redis-1.2.2.tar.gz from http://redis.googlecode.com/files/
--->  Verifying checksum(s) for redis
--->  Extracting redis
--->  Configuring redis
--->  Building redis
--->  Staging redis into destroot
--->  Creating launchd control script
###########################################################
# A startup item has been generated that will aid in
# starting redis with launchd. It is disabled
# by default. Execute the following command to start it,
# and to cause it to launch at startup:
#
# sudo launchctl load -w /Library/LaunchDaemons/org.macports.redis.plist
###########################################################
---&gt;  Installing redis @1.2.2_0
---&gt;  Activating redis @1.2.2_0
Error: Target org.macports.activate returned: couldn't open "/opt/local/var/log/redis.log": no such file or directory
Error: Status 1 encountered during processing.
</pre></p>

<p>なんかlogディレクトリがないみたいなので、ディレクトリ作成してから一度アンインストールしてやりなおしてみます。</p>

<p><pre>
$ sudo mkdir /opt/local/var/log
$ sudo port uninstall redis
$ sudo port install redis
==================================================================
* To start up a redis server instance use this command:
* 
*   redis-server /opt/local/etc/redis.conf
* 
==================================================================

--->  Cleaning redis

</pre></p>

<p>これで、インストールできました。サービスに登録したい場合は、途中のログに書いてあるとおり、</p>

<p><pre>
sudo launchctl load -w /Library/LaunchDaemons/org.macports.redis.plist
</pre></p>

<p>で、OKです。</p>

<h3>Rubyのバインディングのインストール</h3>
<p>僕は普段Rubyを使うので、Rubyのバインディングもあわせてインストールしてみることにします。gemでインストール可能です。</p>

<p><pre>
sudo gem install redis
</pre></p>


<h3>redisの起動</h3>
<p>redisを起動するときは、redis-serverを実行します。MacPortsでインストールした場合、/opt/local/bin にバイナリがインストールされてあるので</p>

<p><pre>
sudo /opt/local/bin/redis-server /opt/local/etc/redis.conf
</pre><p>

<p>で、起動します。confの中には、起動するときのポート番号や、ディスクに書き出すタイミングや条件などの設定項目があります。（ちなみに、起動時に設定ファイルのパスを与えていますが、これはビルド時？に設定しておけば、実行時に与える必要は無いようです。ただ、MacPorts利用時もそれが可能なのかどうか？は不明です）</p>

<p>では、実際に動作を確認してみたいとおもいます。確認するときは、redis-serverと同じ場所にあるredis-cli, またはtelnetで6379に対して接続してコマンドを入力します。（今回はtelnetで接続して生のコマンドを叩いて確認してみます）ValueをStringとして扱うときは、
set <key> <data_size>\r\n<data>でデータをセット, get <value>でデータを確認できます。</p>

<p><pre>
set foo 3
bar
+OK

get foo
$3
bar
</pre></p>

<p>listとして扱うときは、lpush <key> <data_size>\r\n<data>,  lrange <key> <start_index> <end_index> などのコマンドを利用します。下記の例のlrangeの0は開始インデックス、-1は末尾の意味になります。</p>

<p><pre>
lpush artists 8
fishmans
+OK

lpush artists 9
clammbon
+OK

lpush artists 7
polaris
+OK

lrange artists 0 -1
*3
$7
polaris
$8
clammbon
$8
fishmans
</pre></p>

<p>Listの要素追加もStringの要素追加と同じでO(1)で実現できるのがredisのポイントですね。実際の細かなコマンドの仕様については、<a href="http://code.google.com/p/redis/wiki/CommandReference">リファレンス</a>を参照ください。</p>

<p>ここまでざっと環境構築まで確認できたので、次回はもうすこしredisを使い倒してその結果をまとめたいと思います。</p>


