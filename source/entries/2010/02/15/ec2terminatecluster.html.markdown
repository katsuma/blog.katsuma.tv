---
title: EC2でterminate-clusterしてもインスタンスが終了しないときの対策
date: 2010/02/15 02:44:04
tags: aws
published: true

---

<p>EC2でクラスタを終了させるツールとして<a href="http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351&categoryID=88">Amazon EC2 API Tools</a>でec2-terminate-clusterが用意されてます。で、Hadoopでおなじみの<a href="http://www.cloudera.com/">Cloudera</a>もその<a href="http://archive.cloudera.com/docs/_getting_started.html">python用ラッパー</a>を作ってくれていて、僕は普段はclouderaのラッパーを利用していますが、これがよく終了に失敗します。失敗するとどうなるか？というと、いくつかインスタンスが生き残っていて、終了させたクラスタと同名のクラスタを再び起動させようとしたときに、エラーになってコケる不具合が生じます。</p>

<p>で、これがおきると毎回ec2-describe-instancesして、生き残っているEC2インスタンスIDを特定して、それぞれec2-terminate-instanceする。。。と面倒な作業が発生するので、クラスタ指定でインスタンスIDを個別でterminateするスクリプトを書きました。</p>

<p><script src="http://gist.github.com/304141.js"></script></p>

<p><pre>ec2-terminate-cluster-instances $cluster_name</pre></p>

<p>で、指定クラスタのインスタンスを完全に終了させます。</p>


