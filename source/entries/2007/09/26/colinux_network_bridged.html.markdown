---
title: coLinuxでブリッジ接続するときにハマらない手順
date: 2007/09/26 03:34:44
tags: develop
published: true

---

<p>coLinuxのインストール手順について、<a href="http://www.amazon.co.jp/gp/product/477413192X?ie=UTF8&tag=katsumatv-22&linkCode=as2&camp=247&creative=1211&creativeASIN=477413192X">WEB+DB PRESS Vol.40</a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&l=as2&o=9&a=477413192X" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />「Linux定番開発環境」のコーナーに非常に詳しくまとまっています。ただ、ここではネットワークの設定でNAT接続、つまりホストOSのWindowsのIPアドレスをNAT変換して、ゲストOSのLinuxにアドレスを割り振ってることになります。ただ、coLinuxはブリッジ接続、つまりホストOSのWindowsとゲストOSのLinuxで同じネットワークに存在させることもできます。</p>

<p>このブリッジ接続は非常に便利で、「ちょっと急遽LinuxでWebサーバを立てたい！」なんてことがあったときも回線さえ用意できればすぐに対応できます。（なかなかこんなケース無いでしょうが。。）とは言っても今回、たまたまそんなケースがあり、アルバイトの子にブリッジ接続の設定をお願いしていたら、ものすごくハマっていたようなので、ハマらずにさっくりと設定を終わらせる方法を記しておきます。</p>


<h3>環境</h3>
<p>WindowsXPにFedora7をcoLinux上で稼動させます。Windowsにはがルータ（192.168.1.1）からDHCPでIPアドレス192.168.1.2振られてあり、Fedora7に192.168.1.3を割りあえることにします。</p>


<h3>とりあえずcoLinux＋RootFSをインストール</h3>
<ol>
<li><a href="http://sourceforge.net/project/showfiles.php?group_id=98788">coLinuxのDLページ</a>から、coLinux-0.6.4.exe,  Fedora-7-20070718.exeをDL</li>
<li>coLinuxをインストール。このときインストールするコンポーネントは「coLinux」「coLinux Virtual Ethernet Driver」だけ。ブリッジコンポーネントは不要です。</li>
<li>指示に従ってそのままインストール（C:\Program Files\coLinux\にインストールされます）</li>
<li>DLしたFedora-7-20070718.exeをダブルクリック、coLinuxのインストールフォルダ（C:\Program Files\coLinux\）を指定して「Install」。このとき、少し時間がかかるのでのんびり待ちます</li>
</ol>
