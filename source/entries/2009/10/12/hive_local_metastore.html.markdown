---
title: HiveのmetastoreをMySQLを使ってLocal Metastore形式で利用する
date: 2009/10/12 00:56:17
tags: hadoop
published: true

---

 <p>前回、紹介した<a href="http://blog.katsuma.tv/2009/09/hive_introduction.html">Hive</a>についての続き。</p>

 <p>Hiveは内部で扱うメタデータを「metastore」というデータで保持しています。テーブルやパーティションなどの情報、またレコードが実際に保持されてある場所などのメタデータは全部このmetastoreにまとまっています。このmetastoreは、次の3種類の方法で保存することができます。
</p>

 <p><ul>
     <li>Embeded metastore</li>
     <li>Local Metastore</li>
     <li>Remote Metastore</li>
</ul></p>

 <h3>Embeded metastore</h3>
 <p>Embeded metastoreは主にテスト用途に利用されます。テスト用途なので、単一プロセスからの接続しか許可されていません。
そのため、コンソールを複数起動して、それぞれのコンソールから別のMap&Reduceを走らせる...なんてことができません。ただし、Hiveは初期設定がこのEmbededモードになっているので、特に設定することなくすぐに利用するメリットはあります。</p>

<p>また、metastoreはmetastoreディレクトリ(hive-default.xmlのhive.metastore.urisセクションに記述されています)内の
単一のファイルに保存されることになります。メタデータのバックアップをとりたいときは、このファイルをバックアップ対象にすればOKです。</p>

 <h3>Remote Metastore</h3>
 <p>1つ飛ばして、Remote Metastoreについて。Remote Metastoreはネットワーク越しにmetastoreを扱いたい場合における設定方法です。Hiveクライアントとデータを保存するMySQLの間にThriftサーバをproxyのような形で挟むことで実現しています。Thriftプロトコルを実現できていれば通信が可能なので、実際はJavaのHiveクライアントだけではなく、異なる言語によるクライアントからも接続が可能です。たとえばPHPでの例があるみたいです。</p>

 <p><ul><li><a href="http://www.cultofgary.com/2009/02/24/making-php-talk-to-hive-through-thrift/">Making PHP talk to Hive through Thrift</a></li></ul></p>

 <h3>Local Metastore</h3>

<p>Local Metastoreは、上で述べた２つの形式の間の位置づけのものです。
metastoreを単一ファイルで扱わずに、Remote Metastoreの形式にようにMySQLに保存することで、同一ホスト内から同時に複数のセッションを張ることができます。
このLocal Metastoreは簡単に実現できる割にすごく便利なので、紹介しておきます。
</p>

<h4>DBの設定</h4>
 <p>まず、MySQLでmetastoreを保存する適当なDB、およびその接続ユーザを定義します。たとえばrootで接続し、次のように定義します。</p>

 <p><pre>
create database hive;
grant all privileges on hive.* to user_hive@localhost identified by 'hive_password';
flush privileges;
</pre></p>

 <p>この設定をHiveに反映させるために設定用xmlを編集します。</p>

<h4>hive-site.xmlの編集</h4>
 <p>
Hiveの初期設定はhive-default.xmlにまとまっていますが、この設定はhive-site.xmlという名前のファイルを同一ディレクトリに用意してあげることで上書きできます。
上記設定は次の項目を編集、または追加してあげることで反映されます。
</p>


 <p><pre>
&lt;property&gt;
  &lt;name&gt;hive.metastore.local&lt;/name&gt;
  &lt;value&gt;true&lt;/value&gt;
  &lt;description&gt;controls whether to connect to remove metastore server or open a new metastore server in Hive Client JVM&lt;/description&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;javax.jdo.option.ConnectionURL&lt;/name&gt;
  &lt;value&gt;jdbc:mysql://localhost/hive?createDatabaseIfNotExist=true&lt;/value&gt;
  &lt;description&gt;JDBC connect string for a JDBC metastore&lt;/description&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;javax.jdo.option.ConnectionDriverName&lt;/name&gt;
  &lt;value&gt;com.mysql.jdbc.Driver&lt;/value&gt;
  &lt;description&gt;Driver class name for a JDBC metastore&lt;/description&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;javax.jdo.option.ConnectionUserName&lt;/name&gt;
  &lt;value&gt;hive_user&lt;/value&gt;
  &lt;description&gt;metastore mysql user&lt;/description&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;javax.jdo.option.ConnectionPassword&lt;/name&gt;
  &lt;value&gt;hive_password&lt;/value&gt;
  &lt;description&gt;metastore mysql password&lt;/description&gt;
&lt;/property&gt;

&lt;property&gt;
  &lt;name&gt;hive.metastore.warehouse.dir&lt;/name&gt;
  &lt;value&gt;/user/hive/warehouse&lt;/value&gt;
  &lt;description&gt;location of default database for the warehouse&lt;/description&gt;
&lt;/property&gt;
</pre></p>

 <p>どのプロパティ名も名前からどんなものかは凡そ予想はつくと思います。
ちなみにhive.metastore.warehouse.dirはHDFS上でのファイルパスになるので、ここだけ要注意です。</p>

 <p>xmlを編集したら、hiveクライアントのシェルを立ち上げ直します。
シェル自体はEmbeded Metastoreのときとメッセージ形式も変わらないですが、同時に複数のHQLを実行することができるので、格段に使いやすくなります。
Hiveの利用を考える場合は、Local Metastoreの利用は検討してみる価値はあるのかな、と思います。</p>


  <h3>まとめ</h3>
 <p>Hiveのmetastoreの保存形式について、また、Local Metastoreの形式について、その設定方法をまとめてみました。これらの保存方式については、公式サイトにもまとまっている資料があるので、一度目を通してみるとコンポーネント間の関係が理解しやすいかと思います。</p>

  <p><ul><li><a href="http://wiki.apache.org/hadoop/Hive/AdminManual/MetastoreAdmin?action=AttachFile&do=view&target=metastore_usage.pptx">Metastore Usage</a></li></ul></p>



