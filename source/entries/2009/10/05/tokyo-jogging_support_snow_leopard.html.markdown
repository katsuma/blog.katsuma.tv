---
title: Tokyo-JoggingをSnow Leopardに対応させました
date: 2009/10/05
tags: tokyojogging
published: true

---

<p>1年ぶりに<a href="http://www.tokyo-jogging.com/">Tokyo-Jogging</a>をupdateさせました。</p>
<p>さぼってたわけではないのですが、抜本的に通信方法を変更しようとあれこれ試行錯誤していた割に根本的に解決できない問題にぶちあたって途方に暮れていたので、路線変更で小さなバグfixとヌンチャク対応したものを一気にまとめあげてリリースしました。</p>

<p><a href="http://code.google.com/p/tokyo-jogging/downloads/list">Tokyo-Jogging - Downloads</a></p>

<h3>Snow Leopard対応</h3>
<p>Tokyo-Joggingでは内部でBluetoothの信号を扱うために<a href="http://bluecove.org/">BlueCove</a>というライブラリを利用しているのですが、どうもこれがSnow Leopardではうまく動かない模様。原因を探っているとSnow Leopardでは64bit版のJavaがデフォルトで起動するのに対して、BlueCoveのバイナリが32bit用にビルドされていることが原因みたい。インストールされてあるJavaの設定を変更してもいのですが、プログラム単位で対応するためには起動オプションに</p>

<p><pre>-d32</pre></p>

<p>を追加すればいいみたいです。</p>

<p>また、BlueCoveを2.1.0にバージョン上げたら「java.lang.IllegalArgumentException: PCM values restricted by JAR82 to minimum 4097」な例外が出て、落ちてしまってたので、これも対応。起動オプションに</p>

<p><pre>-Dbluecove.jsr82.psm_minimum_off=true</pre></p>

<p>を付けてあげればいいみたいです。</p>

<p>これらの起動オプションは付属のstart-jogging.shに反映させてあるので、最新版にupdateした上で</p>
<p><pre>./start-jogging.sh</pre></p>
<p>で、起動することでSnow Leopard対応したオプション付きで起動できます。</p>
<p>Eclipseから起動する場合は、上記の２つのオプションをRun Configurationsの"VM arguments"に追記してあげればOKです。</p>

<h3>ヌンチャク対応</h3>
<p>地味なupdateですが、ヌンチャクを利用できるようにしました。Wiimoteを認識させた後にヌンチャクを接続するとアナログスティックで方向を変えることができます。（ヌンチャクを接続させたままWiimoteを認識させてもヌンチャクが認識されないので注意）</p>
<p>これで、左手にヌンチャク、右手にWiimoteなスタイルでスムーズに方向を変えつつどこでも走ることができますね！</p>

<h3>今後はどうするの？</h3>
<p>結構、作りっぱなしで放置しているように見られがちですが、実際はジョギング自身でやりたいことはもちろん、派生系でもまだまだやりたいことはあって、ゆっくりながらもupdateしていく予定です。あと、ここへきて外でしゃべらさせていただく機会も増えそうなので、そういうタイミングにあわせてupdateしていく予定です。（今回のupdateも実はその流れ）</p>


