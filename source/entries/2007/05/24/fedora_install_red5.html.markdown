---
title: FedoraにRed5をインストール
date: 2007/05/24 03:00:21
tags: develop
published: true

---

<p>某プロジェクトのテストサーバ環境が他のプロジェクトと混在して、いろんなライブラリが入り乱れ始めて気持ち悪くなってきたので、自分のローカルマシン（WindowsXP）のVM Player上にFedoraをセットアップし、その上でテスト環境を構築しました。入れたもの、セットしたものはこんな感じ。</p>

<p>
<ul>
<li>httpd</li>
<li>mysql(-server)</li>
<li>php</li>
<li>samba</li>
<li>Java</li>
<li>ant</li>
<li>Red5</li>
</ul>
</p>

<p>その上でRed5のインストール方法をメモっておきます。最近Web上でもこれをとりあげている人が増えつつあるのですが、やはりまだまだ日本語の情報は少ないので、つまらない情報でも無いよりはあったほうがいいでしょうし。以下、Fedora5上でのインストール方法のメモ。</p>

<p>ネタ元は<a href="http://www.osflash.org/red5/fc4">このインストールマニュアル</a>です。この情報はいろいろ面倒な表現になっていたり、実際は間違っていたりすることが割りとあります。</p>

<h3>JDKのインストール</h3>
<p>上ではちょっと面倒に書きすぎ。もっと単純にインストールできます。</p>
<ol>
<li>SunからLinux用のJDKをDL。Java6も出てますがとりあえず安定版のJDK5を。</li>

<li><a href="http://java.sun.com/javase/downloads/index_jdk5.jsp">ここ</a>から「JDK 5.0 Update 11」を選択。</li>

<li>Acceptを選択後、リダイレクト</li>

<li>「Linux self-extracting file」を選択、適当な場所にDL。（2007.05.23時点でのJDK5の最新ファイルは「jdk-1_5_0_11-linux-i586.bin」）</li>

<li><p><pre>
chmod +x jdk-1_5_0_11-linux-i586.bin
</pre></p>
<p>で、実行権限を追加</p></li>

<li>自己解凍なのでそのまま実行
<p><pre>
./jdk-1_5_0_11-linux-i586.bin
</pre></p></li>

<li>ズラズラと長文が出てくるので「Yes」を選択。ファイルが解凍されます。</li>
<li>解凍してできたディレクトリを適当な場所にリネームして移動。僕は/usr/local/java に移動させました。</li>
<li>環境変数「JAVA_HOME」「CLASSPATH」を設定します。僕の環境ではこんな感じ。
<p><pre>
$JAVA_HOME=/usr/local/java
$CLASSPATH=.:/usr/local/java/jre/lib:/usr/local/java/lib:/usr/local/java/lib/tools.jar:
</pre>
</p></li>

<li>java,javacにPATHを通しておきます。僕は/usr/bin/にシンボリックリンクを張っています。
<p><pre>
cd /usr/bin
ln -s /usr/local/java/jre/bin/java java
ln -s /usr/local/java/jre/bin/javac javac
</pre></p>
</li>

<li>もしかすると、あらかじめgcj(gccのJava版)が入っているかもしれません。そのときは
<p><pre>
cd /usr/bin
rm -f java
</pre></p>
<p>で、元のシンボリックリンクを削除した後に、SunのJavaで再設定しておきます。</p>
</li>

<li><pre>
java -version
</pre>で
<pre>
java version "1.5.0_11"
Java(TM) 2 Runtime Environment, Standard Edition (build 1.5.0_11-b03)
Java HotSpot(TM) Client VM (build 1.5.0_11-b03, mixed mode, sharing)
</pre>
<p>などと出力されればOKです。</p>
</li>
</ol>

<p>細かく書きましたが、要は自己解凍ファイルを実行して、適当な場所に移動、PATHを設定、ということです。元の方法は煩雑すぎ。</p>

<h3>Antのインストール</h3>
<ol>

<li>AntをDL。2007.05.23時点で1.7.0が最新バージョンです。適当なディレクトリで
<p><pre>
wget http://archive.apache.org/dist/ant/binaries/apache-ant-1.7.0-bin.tar.gz
</pre></p></li>

<li>こいつを解凍
<p><pre>tar -zxf apache-ant-1.7.0-bin.tar.gz</pre></p>
</li>

<li><p><pre>
mv apache-ant-1.7.0 /usr/local/</pre>
</p>
で/usr/local/ant へ移動
</li>

<li><pre>export ANT_HOME=/usr/local/ant</pre>
<p>で、環境変数$ANT_HOMEを設定します。<a href="http://www.osflash.org/red5/fc4">元記事</a>はここの設定が<strong>誤っているので要注意</strong>。</p>
</li>

<li><p><pre>
export PATH=$PATH:$ANT_HOME/bin/
</pre></p>
<p>で、antにPATHを通します。</p>
</li>

<li><p><pre>ant</pre></p>
<p>で</p>
<p>
<pre>
Buildfile: build.xml does not exist!
Build failed
</pre></p>
<p>こんなメッセージが出力されればOKです。</p>
</li>
</ol>

<h3>Red5のインストール</h3>
<ol>
<li>Red5をDL。2007.05.23時点で0.6が最新バージョンです。
<p><pre>
wget http://dl.fancycode.com/red5/red5-0.6.tar.gz
</pre></p>
</li>

<li>
<p><pre>
tar -zxf red5-0.6.tar.gz
</pre></p>
<p>で解凍します。</p>
</li>

<li>
<p><pre>mv red5-0.6 /opt/</pre></p>
<p>で移動します。</p>
</li>

<li>
<p><pre>
cd /opt/red5
ant server
</pre></p>
<p>で実行します。ズララララララっとメッセージが出力されて、サーバが動きはじめます。</p>
</li>
</ol>

<h3>まとめると</h3>
<p><ol>
<li>（Sunの）JAVAのインストール</li>
<li>ANT_HOMEの設定</li>
</ol>
</p>

<p>
が、元記事との異なる点です。ここだけ気をつければ、Fedoraでは特に問題なく動作すると思います。1935番ポートへTCPで接続が張れるか確認すれば、これでRTMPアプリをゴリゴリ作れる環境が整います！
</p>
