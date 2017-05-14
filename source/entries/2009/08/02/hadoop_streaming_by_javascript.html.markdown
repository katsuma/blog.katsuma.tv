---
title: Hadoop Streamingを利用してJavaScriptでMap Reduce
date: 2009/08/02 00:38:41
tags: javascript, java
published: true

---

  <p>久々のBlog更新、というわけでリハビリがてらJavaScriptで軽く遊んでみたいと思います。</p>

  <p>いま、巷で流行ってるMapReduceのオープンソース実装Hadoopは「Hadoop Streaming」という標準入出力でデータのやりとりができる仕組みを使って、
  Hadoopの実装言語であるJavaにとらわれず、RubyやPerlなど他の言語でもMap＋Reduceの処理ができることが１つのウリになっています。
  で、僕たちwebエンジニアはみんなJavaScript大好きなので、「JavaScriptでもMap Reduceやりたい！」という流れになるのは必然です。
そこで、試行錯誤でいろいろ試してみると割とさっくり出来たのでそのメモを残しておきたいと思います。</p>

  <h3>環境の整備</h3>
  <p>Mac OSX上のVMWare FusionにCentOSの仮想マシンを２台立ち上げて、環境セットアップしました。以下のような手順で環境整備しました。</p>

  <h4>仮想HWの設定</h4>
  <p>仮想マシンのイメージファイルですが、僕は毎回<a href="http://www.thoughtpolice.co.uk/vmware/">thoughtpolice</a>のサイトのものを利用しています。ここからCentOS 5.3のイメージを落としてFusionでロード。</p>
  <p>1つハマったのが、同じイメージをコピーして複数台起動すると、MACアドレスがかぶって同時に複数台の仮想マシンがNWに接続できない点。なので、仮想マシンを最初に起動させる前にMACアドレスの設定をしておくことをおすすめします。</p>
  <p>MACアドレスは、vmxファイルのuuid.bios値をもとに自動生成されるようで、この値を最初から全仮想マシンでバラバラにしておけばOKです。と、いっても有効な値の範囲があるので、最後の1byte値だけズラしておけばOKだと思います。たとえば、上記サイトからイメージを取得した場合、uuid.bios値の最後は「7d」になっているので、僕はこの値を「7c」「7b」なんかにズラしておきました。（Fusion上から正規の方法？で、マシンをクローンする方法がよくわからなかったので、こういう強引な方法を取っています。綺麗な方法をご存知の方いらしたらぜひ教えてください！）
</p>


  <h4>ネットワーク設定</h4>
  <p>/etc/hostsを設定して２台のマシンの名前解決。細かな話ですけど、ホスト名には「_(アンダーバー)」は使えないのに要注意。最初「hdp_01」みたいなホスト名にしていて、実行時エラーが出てドはまってたときに全然気づかなかった。</p>
  <ul>
    <li>192.168.1.15 hdp-01</li>
    <li>192.168.1.16 hdp-02</li>
  </ul>

  <h4>SSHの設定</h4>
  <p>マシンはそれぞれ自分自身(localhopst)に対して、パスフレーズなしでSSHでログインできるように公開鍵を設定しておきます。</p>
  <ul>
    <li>ssh-keygen -t rsa -P ""</li>
    <li>cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys</li>
    <li>chmod 600 ~/.ssh/authorized_keys</li>
 </ul>

  <p>また、MasterのマシンからSlaveのマシンに対しても同様の設定をしておきます。今回はMasterはhdp-01, Slaveはhdp-02という設定です。hdp-01上で、次の設定をします。</p>
  <ul>
    <li>cp ~/.ssh/id_rsa.pub ~/.ssh/id_rsa_master.pub</li>
    <li>scp ~/.ssh/id_rsa_master.pub hdp-02:/home/katsuma/.ssh/</li>
    <li>chmod 600 ~/.ssh/authorized_keys</li>
 </ul>

  <p>また、hdp-02上で、次の設定をします。</p>
  <ul>
    <li>cat ~/.ssh/id_rsa_master.pub >> ~/.ssh/authorized_keys</li>
 </ul>

  <p>これで、Masterからlocalhost, およびSlaveに対してパスフレーズなしでログインできることを確認しておきます。</p>

  <h4>セキュリティの設定</h4>
  <p>後でハマるのが面倒なので、iptablesやSELinuxは切っておきます。必要であれば適宜設定してください。</p>

  <ul>
    <li>sudo /etc/init.d/iptables off</li>
    <li>sudo /etc/sysconfig iptables off</li>
    <li>sudo vi /etc/sysconfig/selinux
      <ul>
        <li>SELINUX=disabled に変更</li>
      </ul>
    </li>
</ul>


  <h4>Shellの設定</h4>
  <p>.bashrcなんかに以下の設定をしておくと便利です。僕はzsh派なので、.zshrcに記述しました。</p>
<p><pre>
# hadoop
alias cdh='cd /home/katsuma/hadoop/latest/'
alias dls='/home/katsuma/hadoop/latest/bin/hadoop dfs -ls'       # ls
alias drm='/home/katsuma/hadoop/latest/bin/hadoop dfs -rm'       # rm
alias dcat='/home/katsuma/hadoop/latest/bin/hadoop dfs -cat'     # cat
alias drmr='/home/katsuma/hadoop/latest/bin/hadoop dfs -rmr'     # rm -r
alias dmkdir='/home/katsuma/hadoop/latest/bin/hadoop dfs -mkdir' # mkdir
alias dput='/home/katsuma/hadoop/latest/bin/hadoop dfs -put'     # HDFS に転送
alias dget='/home/katsuma/hadoop/latest/bin/hadoop dfs -get'     # HDFS から転送
alias dcpfl='/home/katsuma/hadoop/latest/bin/hadoop dfs -copyFromLocal'
alias dcptl='/home/katsuma/hadoop/latest/bin/hadoop dfs -copyToLocal'
</pre></p>


<h4>Javaのインストール</h4>
  <p><a href="http://java.sun.com/javase/ja/6/download.html">Sun</a>のサイトに行き、
    「Java SE Development Kit (JDK)」を選択して、インストーラをダウンロード。その後、以下の手順でインストールできます。
  <p><pre>
chmod +x jdk-6u7-linux-i586-rpm.bin
sudo ./jdk-6u7-linux-i586-rpm.bin
</pre></p>
</p>


<h3>Hadoopの整備</h3>
  <h4>Hadoopのインストール</h4>
  <p>Hadoopは今日時点で最新の0.20.0を利用しました。インストール場所はどこでもいいのですが、僕はホームディレクトリ直下に専用のディレクトリ掘って、いろんなバージョン試せるようにこんな感じで設置してます。<a href="http://www.apache.org/dyn/closer.cgi/hadoop/core">ここ</a>から最新版をDLが可能です。</p>
  <ul>
    <li>cd path/to/hadoop-0.20.0.tar.gz</li>
    <li>tar zxvf hadoop-0.20.0.tar.gz</li>
    <li>mv hadoop-0.20.0 ~/hadoop/</li>
    <li>ln -s hadoop-0.20.0 latest</li>
  </ul>

  <p>他のバージョンを試したくなったら~/hadoop/以下に展開して、シンボリックリンクを付け直すとOKですね。</p>

  <h4>Hadoopの設定</h4>
  <p>特に凝ったことはしていません。全ノードともに同じ設定である必要があるので、Masterで設定しちゃって、それをrsyncで他のSlaveと同期をとるのがよいと思います。</p>

  <h5>conf/hadoop-env.sh</h5>
  <pre>export JAVA_HOME=/usr/java/latest</pre>

  <h5>conf/core-site.xml</h5>
  <p>
    <pre>
&lt;configuration&gt;
  &lt;property&gt;
    &lt;name&gt;hadoop.tmp.dir&lt;/name&gt;
    &lt;value&gt;/home/${user.name}/hadoop/latest/tmp&lt;/value&gt;
  &lt;/property&gt;
  &lt;property&gt;
    &lt;name&gt;fs.default.name&lt;/name&gt;
    &lt;value&gt;hdfs://hdp-01:9000&lt;/value&gt;
  &lt;/property&gt;
&lt;/configuration&gt
</p></pre>

  <h5>conf/hdfs-site.xml</h5>
  <p><pre>
&lt;configuration&gt;
  &lt;property&gt;
    &lt;name&gt;dfs.replication&lt;/name&gt;
    &lt;value&gt;1&lt;/value&gt;
  &lt;/property&gt;
&lt;/configuration&gt;
</pre></p>


  <h5>conf/mapred-site.xml</h5>
  <p><pre>
&lt;configuration&gt;
  &lt;property&gt;
    &lt;name&gt;mapred.job.tracker&lt;/name&gt;
    &lt;value&gt;hdp-01:9001&lt;/value&gt;
  &lt;/property&gt;
&lt;/configuration&gt;
</pre></p>

  <h5>conf/masters</h5>
  <p><pre>
      hdp-01
</pre></p>


  <h5>conf/slaves</h5>
  <p><pre>
      hdp-02
</pre></p>

  <p>ここまで設定できたら、masterのイメージをrsyncしておきましょう。</p>
  <p><pre>
cd ~/hadoop/
rsync -r hadoop-0.20.0/ hdp-02:/home/katsuma/hadoop/hadoop-0.20.0
</pre></p>


  <h3>SpiderMonkeyの導入</h3>
  <p>さて、やっとHadoopの設定が終わったので、次にJavaScriptの処理系の導入です。
Hadoop Streamingは前述の通り、標準入出力の仕掛けを使って実現されているので、さすがにブラウザの処理系をそのまま利用することができません。</p>

<p>
そこで、FirefoxのJavaScriptのエンジンであるSpiderMonkeyを利用することにします。
SpiderMonkeyはファイルを入力としても処理できるし、irbのように対話型シェルとしても利用できるJavaScriptの処理系です。また、ブラウザを利用しないので、標準出力関数print、標準入力関数readlineが実装されてあるので、今回はこれを利用すればうまくいきそうです。</p>

<p>では、SpiderMonkeyを各ノードに導入します。これも最新版を導入します。あらかじめ、make, gccあたりをyumで入れておきましょう。</p>
  <p>参考：<a href="http://blog.katsuma.tv/2007/12/spidermonkey_install.html">SpiderMonkeyのインストール</a></p>
  <p><ul>
      <li>wget http://ftp.mozilla.org/pub/mozilla.org/js/js-1.8.0-rc1.tar.gz</li>
      <li>tar zxf js-1.8.0-rc1.tar.gz</li>
      <li>cd js/src</li>
      <li>BUILD_OPT=1 make -f Makefile.ref</li>
      <li>sudo install -m 755 Linux_All_OPT.OBJ/js /usr/local/bin</li>
  </ul></p>

  <h3>Map, Reduce処理のJavaScriptを記述する。</h3>

  <p>では、Map, Reduceそれぞれの処理をJavaScriptで書きます。今回はサンプルとしてよくある、ワードカウントの処理を行ってみます。</p>

  <h4>map.js</h4>
  <p>map.jsは標準入力された文章を半角スペースごとに分けて、CSVの形式に整形します。JavaScript1.7相当の機能が利用できるので、Array.prototype.forEachが利用できることもポイントです。</p>
  <p><pre>
#!/usr/local/bin/js

var line="";
while ((line = readline())!= null){
        var words = line.split(" ");
        words.forEach(function(w){
                print(w + "," + 1);
        });
}
</pre></p>

  <h4>reduce.js</h4>
  <p>reduce.jsは、map処理されたCSV形式の入力に対して、counterオブジェクトで各単語をカウントしていきます。</p>

  <p><pre>
#!/usr/local/bin/js

var counter = {};
var line = "";
while ((line = readline()) != null) {
        var words = line.split(",");
        var word = words[0]
        if(!counter[word]) counter[word] = 1;
        else counter[word]++;
}

for(var k in counter){
        print(k + ":" + counter[k]);
}

</pre></p>
</body>

  <p>これらのJavaScriptファイルをhadoop/latest/script/あたりに保存しておき、全ノードで同期させておきます。</p>

  <h3>Hadoopの起動</h3>
  <p>最初にHDFSをフォーマットしておきます。Masterで次の処理を行います。</p>
  <p><pre>
cdh
./bin/hadoop namenode -format
</pre></p>

  <p>MasterでHadoopを起動します。</p>
  <p><pre>
bin/start-all.sh
</pre></p>

  <p>MapReduce用の適当な入力ファイルを作成します。こんな内容のファイルを$HADOOP_HOME/input/file1に作成します。</p>
  <p><pre>
we are the world we change the world
</pre></p>
  <p>このファイルをHDFSに転送します。dputは bin/hadoop dfs -putのエイリアスです。</p>
  <p><pre>
dput input/file1 in/count
</pre></p>

  <p>転送されてあるかどうかは、dls(bin/hadoop dfs -ls)で確認できます。</p>
  <p><pre>
katsuma@hdp-01 ~/hadoop/latest
$ dls
Found 1 items
drwxr-xr-x   - katsuma supergroup          0 2009-07-31 02:14 /user/katsuma/in

katsuma@hdp-01 ~/hadoop/latest
$ dls in
Found 1 items
drwxr-xr-x   - katsuma supergroup          0 2009-07-31 02:56 /user/katsuma/in/count
</pre></p>

  <p>入力用ファイルの存在が確認できたので、これでやっとMapReduce処理ができます。</p>

  <p><pre>
./bin/hadoop jar ./contrib/streaming/hadoop-0.20.0-streaming.jar -input in/count -output out/count -mapper "js /home/katsuma/hadoop/latest/script/map.js" -reducer "js /home/katsuma/hadoop/latest/script/reduce.js"
</pre></p>

  <p>すると、ゆったりですけど処理が進んでいきます。</p>
  <p><pre>
packageJobJar: [/home/katsuma/hadoop/latest/tmp/hadoop-unjar4327209233542314881/] [] /tmp/streamjob4726696067913490494.jar tmpDir=null
09/07/31 10:45:05 INFO mapred.FileInputFormat: Total input paths to process : 1
09/07/31 10:45:06 INFO streaming.StreamJob: getLocalDirs(): [/home/katsuma/hadoop/latest/tmp/mapred/local]
09/07/31 10:45:06 INFO streaming.StreamJob: Running job: job_200907310237_0013
09/07/31 10:45:06 INFO streaming.StreamJob: To kill this job, run:
09/07/31 10:45:06 INFO streaming.StreamJob: /home/katsuma/hadoop/latest/bin/../bin/hadoop job  -Dmapred.job.tracker=hdp-01:9001 -kill job_200907310237_0013
09/07/31 10:45:06 INFO streaming.StreamJob: Tracking URL: http://hdp-01:50030/jobdetails.jsp?jobid=job_200907310237_0013
09/07/31 10:45:07 INFO streaming.StreamJob:  map 0%  reduce 0%
09/07/31 10:45:23 INFO streaming.StreamJob:  map 50%  reduce 0%
09/07/31 10:45:45 INFO streaming.StreamJob:  map 50%  reduce 17%
09/07/31 10:48:49 INFO streaming.StreamJob:  map 100%  reduce 17%
09/07/31 10:49:10 INFO streaming.StreamJob:  map 100%  reduce 100%
09/07/31 10:49:15 INFO streaming.StreamJob: Job complete: job_200907310237_0013
09/07/31 10:49:15 INFO streaming.StreamJob: Output: out/count
</pre></p>

  <p>HDFS上のout/count/以下に結果が格納されたファイルができているので確認してみましょう。</p>

  <p><pre>
katsuma@hdp-01 ~/hadoop/latest
$ dls out/count
Found 2 items
drwxr-xr-x   - katsuma supergroup          0 2009-07-31 10:45 /user/katsuma/out/count/_logs
-rw-r--r--   1 katsuma supergroup         43 2009-07-31 10:48 /user/katsuma/out/count/part-00000

katsuma@hdp-01 ~/hadoop/latest
$ dcat out/count/part-00000
are:1
change:1
the:2
we:2
world:2
</pre></p>


<h3>まとめ</h3>

<p>SpiderMonkeyのような処理系を用意することで、JavaScriptでもHadoopを使ってMapReduceできることが確認できました。標準入出力さえサポートされてあれば、理屈的にはどんな言語でもMapReduceできるので、MapReduceには興味あるけどJavaということで敬遠していた方は、ぜひいろんな言語で試していただければと思います。</p>

<h4>開発のTips</h4>
<p>なんだかんだ言って、最初開発にかなり苦労しました。と、いうのもシンタックスエラー以外は、実行しないとどうなるかよくわからないものなので、エラーで落ちたときにどうデバッグすればいいか悩みました。
ただ、よく考えれば、「標準入力→Map処理→Mapの標準出力→Reduceの入力→Reduceの標準出力」という流れになるので、たとえば今回のJavaScript実装の場合、次のように実行することでHadoopを介さなくとも動作確認は可能です。</p>


  <p><pre>
cat input/file1 | js script/map.js | js script/reduce.js
</pre></p>

  <p>まずは、このように手元でパイプでつないで結果を調べてみる、というのが手かと思います。実際は手元でうまく動いてもHadoop上でRuntimeエラーが起きる場合も多いので、そのときはlogディレクトリ以下にできるログファイルを調べるのがいいと思います。</p>

<p>また、エラーが発生するとJavaの例外のStackStraceが表示されるので、敬遠せずにそこからHadoopのソースを直接追いかけるのは何だかんだで早い解決法でした。コメントが割と充実しているので、そこからStreaming用のコードのバグを辿るのも難しくはないと思います。</p>


