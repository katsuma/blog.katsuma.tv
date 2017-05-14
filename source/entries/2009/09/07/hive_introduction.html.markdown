---
title: SQL感覚でMap Reduce処理できるHiveについて
date: 2009/09/07 00:44:59
tags: hadoop
published: true

---

  <p><img src="http://hadoop.apache.org/hive/images/hive_logo_medium.jpg" alt="Hive" /></p>

 <p>前回、<a href="http://blog.katsuma.tv/2009/08/hadoop_streaming_by_javascript.html">JavaScriptでMap Reduceのコードが書けるHadoop Streaming</a>について紹介しました。
標準入出力さえサポートされてあれば、任意のコードでMap Reduuceの処理が書ける、というものでしたが、エンジニアはそもそも面倒くさがり。コードも書くのも面倒です。
と、いうわけで、今回はもうコードすら書かずにSQLライクでMap ReduceできるHiveというプロダクトについて、まとめたいと思います。</p>

  <h3>Hive</h3>
  <p>Hiveとは、簡単に言うとHadoop上で動作するRDBのようなものです。
HDFSなどの分散ファイルシステム上に存在するデータに対して、HiveQLというSQLライクな言語で操作できます。
で、面白いのがHiveQLの操作は基本的にMap Reduceのラッパーになっていること。
要するに、SELECT文実行すると裏でMap&Reduceのタスクが走り出して、分散処理されて結果を得ることができます。</p>

  <p>そんなHiveは、もともとFacebookが開発を始めたものでした。2008年12月に、正式にHadoopプロジェクトにcontributeされて、いまはHiveの公式サイトもHadoopのサイト内でホスティングされてあります。</p>

  <p><ul><li><a href="http://hadoop.apache.org/hive/">Hive</a></li></ul></p>

  <p>では、さっそく導入方法について確認してみます。</p>

  <h3>ビルド</h3>
  <p>Hiveのビルドに先立って、Hadoopをインストールしておきます。Hadoopのインストール方法は<a href="http://blog.katsuma.tv/2009/08/hadoop_streaming_by_javascript.html">前回のエントリ</a>にも書いてある通りです。</p>

  <p>Hiveのビルド自体は、Subevrsionからcheckoutして、antのタスクでビルドできる簡単なものです。1ヶ月ほど前のHiveは、patchを当てないとHadoop 0.20.0用にビルドできなかったのですが、最近のtrunkのものは特に何もせずにビルドできるようです。</p>

  <p><pre>
svn co http://svn.apache.org/repos/asf/hadoop/hive/trunk hive
cd hive
ant -Dhadoop.version="0.20.0" package
</pre></p>

  <p>ビルドできたらbuild/distを環境変数$HIVE_HOMEとでも設定しておきます。また、あわせて$HADOOP_HOMEも設定しておきましょう。</p>

  <h3>セットアップ</h3>
  <p>ビルドが成功したら、Hive用のデータ保存領域のセットアップをHDFS上で行います。Hadoopを起動した状態で次のようにセットアップします。</p>

  <p><pre>
$HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse
</pre></p>

  <p>すると、次のコマンドでHiveが起動されます。</p>


  <p><pre>
$HIVE_HOME/bin/hive
</pre></p>

  <h3>テーブルの作成</h3>
  <p>では、早速Hiveで扱うテーブルを作成します。
テーブルの作成方法はMySQLなんかの一般的なRDBMSのそれとほぼ同等です。
たとえば、ユーザのアクセスログをまとめたログがあると仮定します。このログを保存するテーブルは最低限、ユーザIDとそのアクセス時間が保存されればOKなので、次のように定義できます。</p>

  <p><pre>
CREATE TABLE user_logs(id INT, created_at STRING);
</pre></p>

  <p>構文については見たまんまなので。理解しやすいかと思います。ちなみに、昔のバージョンだとカラムにDATETIMEなんかの型が定義できたようですが、現在はDATETIME型はなくなっているようです。（<a href="http://wiki.apache.org/hadoop/Hive/LanguageManual/DDL#head-9c8c15fb80a9ae874cf67cc35e1903e77554b62c">Hive/LanguageManual/DDL</a>）</p>


  <p>また、CSVなどの形式ですでに既存のログファイルがある場合、便利な機能があります。
Hiveではテーブル定義時に(CSVなどの)ある形式のデータを扱うことをあらかじめ指定しておくと、
CSV形式のログデータをそっくりそのままHiveのテーブルのレコードとしてロードさせることが可能です。</p>

  <p>たとえばCSV形式のファイルを扱う場合、このような定義方法になります。</p>

  <p><pre>
CREATE TABLE user_logs(id INT, created_at STRING) row format delimited fields terminated by ',' lines terminated by '\n';
</pre></p>

  <p>この上で、次のようなコマンドで既存のログデータをロードできます。</p>

  <p><pre>
LOAD DATA LOCAL INPATH '/path/to/log_20090907.csv' OVERWRITE INTO TABLE user_logs;
</pre></p>


  <p>これで、CSVデータをHiveQLで扱えるようになりました。この時点でHDFS上にlog_20090907.csvは保存されています。/user/hive/warehouse/以下にテーブル名である「user_logs」ディレクトリが作成されてあり、該当ファイルが保存されてあります。</p>

  <p><pre>
$ $HADOOP_HOME/bin/hadoop fs -ls /user/hive/warehouse/user_logs/
Found 1 items
-rw-r--r--   1 katsuma supergroup   17800731 2009-09-06 11:01 /user/hive/warehouse/user_logs/20090907.csv
</pre></p>

<p>では、ここで早速HiveQLを実行してみましょう。全件取得するときは一般的なSELECT文が利用できます。</p>

  <p><pre>SELECT * from user_logs;</pre></p>

  <p>ただし、このままだとローカルからデータをロードするだけで、ただのCSVのSQLラッパーでしかありません。
HiveQLが真価を発揮するのはいろいろ条件付けたSQLを発行してから。</p>

  <h3>ユニークユーザ数をHiveQLで算出</h3>
<p>ここで、ユニークユーザ数(UU)を算出してみます。普通のMap Reduceの処理だと、IDごとのHashMapを作成してそのサイズからUUを算出することになりますが、HiveはSQLライクに算出することができます。つまり、こういうかんじ。</p>

  <p><pre>select count(distinct id) from user_logs;</pre></p>

  <p>すると、いきなりここからMap&Reduce処理が走り出します。
この、「SQL実行でMap&Reduceが実行される」という様子があまりにすごいので、最初これ見たときはかなりウケました。</p>

<p><pre>
Total MapReduce jobs = 1
Number of reduce tasks determined at compile time: 1
In order to change the average load for a reducer (in bytes):
  set hive.exec.reducers.bytes.per.reducer=<number>
In order to limit the maximum number of reducers:
  set hive.exec.reducers.max=<number>
In order to set a constant number of reducers:
  set mapred.reduce.tasks=<number>
Starting Job = job_200909061015_0001, Tracking URL = http://hdp-01:50030/jobdetails.jsp?jobid=job_200909061015_0001
Kill Command = /home/katsuma/hadoop/latest/bin/../bin/hadoop job  -Dmapred.job.tracker=hdp-01:9001 -kill job_200909061015_0001
2009-09-06 10:41:27,049 map = 0%,  reduce = 0%
2009-09-06 10:42:27,520 map = 5%,  reduce = 0%
2009-09-06 10:42:28,540 map = 50%,  reduce = 0%
2009-09-06 10:42:33,594 map = 69%,  reduce = 0%
2009-09-06 10:42:34,610 map = 100%,  reduce = 0%
2009-09-06 10:42:55,748 map = 100%,  reduce = 100%
Ended Job = job_200909061015_0001
OK
21509
Time taken: 105.58 seconds
</pre></p>

  <p>すると、結果が取得できました。上記例だと21509ユーザという結果を取得できていますね。あまりに簡単すぎてウケます。</p>

<p>ちなみにHiveのコンソールはサイレントモードが用意されてあって、Hiveのコンソールを起動させることなく、普段のシェルからも実行させることができます。サイレンとモードは-Sオプションをつけて実行すればよく、</p>


  <p><pre>
$HIVE_HOME/bin/hive -S -e 'select count(distinct id) from user_logs'
</pre></p>

  <p>と、すれば、途中経過をすっとばして結果だけ取得できます。もちろんこれはバッチ処理など、Hiveコンソールを利用せずにいろんな値を取得させたいときに利用すればよさそうですね。</p>


  <h3>Partitionを設定</h3>

  <p>Hiveの特徴的な機能としてPartitionというものがあります。
    これはテーブル自体にバージョン管理の概念を持たせるもので、ログ管理にすごく便利そうなものです。</p>
  
<p>たとえばデイリーのログファイルをHiveで管理したいと思ったときに、
毎日HDFS上にログファイルを転送することになるかと思いますが、Partitionを利用することで、
ログを追記でテーブルに書き込む(=ファイルにappendする)のではなく、
日付ごとに独立したファイルのままHDFSに保存することができます。
なので、「やっぱりHiveより素のMqp&Reduce書くようなフローに戻そう」と
思ったときに、Partitionを利用してロードしておいたほうが後々都合がよいかと思います。(あと、初期のHadoopはファイルのappendができない、という制約があったので、Hive側はこの制約を回避するために、このような概念を持たせて独立したファイルを透過的に見せるような仕様で実装したんじゃないかな？と推測しています)</p>

<p>
Partition自身は、ふだんのテーブルにおけるカラムのように扱えるので、実際は特別に何か意識する必要はありません。Partition付きテーブルはこのように定義できます。</p>


  <p><pre>
CREATE TABLE user_logs(id INT, created_at STRING) partitioned by(dt STRING) row format delimited fields terminated by ',' lines terminated by '\n';
</pre></p>

  <p>この場合だと、dailyの情報をpartitionに持たせるために「dt」という名前のpartitionに設定させています。その上で、このテーブルにデータをロードする場合は次のようになります。</p>


  <p><pre>
LOAD DATA LOCAL INPATH '/path/to/20090907.csv' OVERWRITE INTO TABLE user_logs partition (dt='20090907');
LOAD DATA LOCAL INPATH '/path/to/20090908.csv' OVERWRITE INTO TABLE user_logs partition (dt='20090908');
</pre></p>

  <p>すると、HDFS上ではバージョン情報をもったまま保存されていることが確認できます。</p>

  <p><pre>
$ $HADOOP_HOME/bin/hadoop fs -ls /user/hive/warehouse/user_logs/
Found 2 items
drwxr-xr-x   - katsuma supergroup          0 2009-09-06 11:18 /user/hive/warehouse/user_logs/dt=20090907
drwxr-xr-x   - katsuma supergroup          0 2009-09-06 11:17 /user/hive/warehouse/user_logs/dt=20090908
</pre></p>

  <p>これらのPartitionの情報は、もちろんHiveQL上で扱うことができて、たとえば上記例だと9月8日のUUを算出したい場合は</p>

  <p><pre>
select count(distinct id) from user_logs where dt='20090908';
</pre></p>

  <p>で、算出できます。また、9月7日以降のUUを算出したい場合だと</p>

  <p><pre>
select count(distinct id) from user_logs where dt>='20090907';
</pre></p>

  <p>な、風に書けます。直感的で便利ですよね。（この比較式はたぶん、JavaのString#compareToに従ってるんじゃないか、と推測）</p>


  <h3>まとめ</h3>
  <p>Hiveはまだ立ち上がったばっかりの若いプロジェクトですが、基本的なログ解析をするくらいの分には、かなり使えそうな印象です。上記例のように、基本的に元ファイルはそのままHDFS上に保存されているので、Hiveの不具合で何かおきた場合も自前のMap&Reduce処理に戻すことができるのも安心ですね。</p>

  <p>今回は、あまり細かな説明までしませんでしたが、HiveQLはJoinやUnionなど割と複雑なテーブル間処理も行うことができます。このあたりも興味ある方は一度、オフィシャルのマニュアルに目を通してみてはいかがでしょうか？</p>

  <p><ul><li><a href="http://wiki.apache.org/hadoop/Hive/LanguageManual">Hive/LanguageManual</a></li></ul></p>



