---
title: ClouderaベースのAMIのHiveのバージョンを上げる方法
date: 2010/05/06
tags: aws
published: true

---

<p>Clouderaの提供しているAMIはバージョン１(CDH1)から３(CDH3)まであるのですが、それぞれ梱包されてあるHadoopとその上モノのHive, Pigのバージョンは異なります。</p>

<div>
<table border="1">
<thead>
<tr>
<th>CDH Release</th>
<th>Hadoop 0.18</th>
<th>Hadoop 0.20</th>
<th>Hive</th>
<th>Pig</th>
</tr>
</thead>

<tbody>
<tr>
<td>CDH1</td>
<td>hadoop_0.18.3-6cloudera0.3.0</td>
<td>N/A</td>
<td>hive_0.3.0-0cloudera0.3.0</td>
<td>pig_0.2.0-0cloudera0.3.0</td>
</tr>

<tr>
<td>CDH2</td>
<td>hadoop-0.18.3+76.2</td>
<td>hadoop-0.20.1+169.56</td>
<td>hive-0.4.1+14.4</td>
<td>pig-0.5.0+11.1</td>
</tr>

<tr>
<td>CDH3</td>
<td>N/A</td>
<td>hadoop-0.20.2+228</td>
<td>hive-0.5.0+20</td>
<td>pig-0.5.0+30</td>
</tr>

</tbody>
</table>

<p> via <a href="http://archive.cloudera.com/docs/_choosing_a_version.html">1.2.1. Choosing a Version</a></p>
</div>

<p>CDHは常にupdateしていて、現在の最新リリースであるCDH3も2010年5月5日現在ではテスト版扱いですが、これもじきにStable版としてリリースされることになるかと思います。</p>

<p>さて、そうるとClouderaのAMIを使っていて、特定のバージョンに上げたい、というのは結構自然な流れかと思います。このとき、バージョンを上げる流れとしては次のような流れになります。</p>

<p><ol>
<li>Hadoopとその上モノであるHive, Pigなどをパッケージ管理ツールを利用して全てアンインストール。</li>
<li>パッケージ管理ツールのレポジトリを追加</li>
<li>パッケージ管理ツールを利用してHadoopをインストールし直し</li>
<li>パッケージ管理ツールを利用してHive, Pigなどをンストールし直し</li>
</ol></p>

<p>要するに、全ソフトウェアのバージョンをまとめて上げるのではなく、Hadoopかまたはそれ以外の特定のソフトウェアについて、パッケージ管理ツールを利用してバージョンを上げる、ということが可能になります。このとき、Hadoopについては新たに設定項目がかなり多かったり、AMIを作りなおさないと試すことができなかったりと面倒なことが多いのですが、逆にHiveやPigなどHadoopの上モノについては、AMIを作り直すこともなく、その場でバージョンを上げることも結構簡単にできます。</p>

<p>たとえば、HiveのバージョンをCDH1→CDH2に上げる場合は次のような手順で可能です。</p>

<p>まず、既存にインストールされてあるHiveをアンインストールします。たとえばFedoraベースの　AMIの場合は、パッケージ管理ツールとしてはyumを利用することが可能です。</p>

<p><pre>
yum remove hadoop-hive
</pre></p>

<p>次に、CDH2用のyumのレポジトリを追加します。あとえばCDH2用のレポジトリを追加するときは、こんなかんじ。CDH3用のレポジトリを追加したい場合は、URLの最後をcloudera-cdh3.repoに変更ください。</p>

<p><pre>
cd /etc/yum.repos.d/
wget http://archive.cloudera.com/redhat/cdh/cloudera-cdh2.repo
</pre></p>

<p>これで、最新のパッケージを扱える状態になりました。ここでHiveだけCDH2仕様のver0.40系にしてみましょう。</p>

<p><pre>
yum -y install hadoop-hive
</pre></p>

<p>これで、0.40.xのHiveがインストールされました。また、設定ファイル(/etc/hive/conf/hive-site.xml)は、オリジナルのものに戻ってしまっているので、適宜直しておきましょう。ぼくは以下の箇所を変更、追加しました。</p>

<p><ul>
<li>javax.jdo.option.ConnectionURL</li>
<li>javax.jdo.option.ConnectionDriverName</li>
<li>javax.jdo.option.ConnectionUserName</li>
<li>javax.jdo.option.ConnectionUserPassword</li>
</ul</p>

<p>いかがでしたでしょうか？Hiveについては、アップグレードは非常に簡単だったかと思います。同じように、PigについてもHadoopの上モノなので同様の手順でアッグレード可能になります。これなら割と気軽にバージョン上げたりパッチ当てたりなんかもできそうですね。</p>

<p>また、Hadoop本体のアップグレードについても、次回は挑戦してみたいと思います。</p>


