---
title: Flash Player 9,0,115,0 だとRed5 0.6.3 でSharedObjectが扱えない
date: 2008/02/05
tags: java
published: true

---

<p>すごく限定的で細かい問題だけど丸一日を潰されたので、その備忘録に。内容は件名の通りです。</p>

<p>2008/02/05 時点での最新のFlash Player(9,0,115,0)だと、Red5(0.6.3)で、SharedObjectがうまく扱えません。具体的に言うとActionScript3で</p>

<p>
<pre>
this.so = SharedObject.getRemote(this.session, this.nc.uri, true);
this.so.addEventListener(SyncEvent.SYNC, this.syncListener);
this.so.connect(this.nc);
</pre>
</p>

<p>こんな感じのコードを書いたときに、</p>

<p><pre>
this.so.setProperty('message', msg);
</pre></p>

<p>と、setPropertyでso.dataを変更したときにSyncイベントが上がってこない、という不具合。イベントが上がらないから、イベントリスナでキャッチできずに処理が進まない、という悪循環。もう少し細かく言うと、so.setPropertyする瞬間にorg.red5.server.net.protocol.ProtocolExceptionが発生して、ここで処理が止まっちゃってるのが問題です。</p>

<p>これ、１つ前のバージョンのFlash Player(9,0,47,0)だと発生しないから厄介です。9,0,115,0は9系の中でかなり大きな機能追加＋修正がかかっているので要注意。9,0,47,0からの差分は<a href="http://www.adobe.com/support/documentation/jp/flashplayer/9/releasenotes.html#fixes_90115">リリースノート</a>を参照。</p>

<p>さて、この問題ですがどうやらRed5開発陣には既に通っている問題のようです。</p>



<p><blockquote>
Trunk (2480) version of Red5 and previous versions (I first noticed the issue about 3 months ago).
Flash Player 9,0,115,0 or any of the Flex Builder 3 Beta Debug Players.
IE, Firefox, Opera (all same issue).<br /><br />
via <a href="http://jira.red5.org/browse/SN-78">New Flash Player (9,0,115,0) Using AMF3 Causes ProtocolExceptions which disconnect clients.</a></blockquote></p>

<p>
ちょうど今日（2/4）にコミットされているSubversionのtrunkのソースだとBugFixされているようです。</p>

<p>
<blockquote>
&gt; I'm pretty sure that this ha been fixed in the trunk. Steven gong<br />
&gt; worked on this for one of our clients that was experiencing the<br />
&gt; problem. Steven, can you confirm that the SharedObect AMF3 bug is fixed?<br />
Yes. These two issues should have been fixed now.<br /><br />
via <a href="http://osflash.org/pipermail/red5devs_osflash.org/2008-February/003333.html">Tickets for 0.7</a>
</blockquote></p>

<p>最新のソースは<a href="http://svn1.cvsdude.com/osflash/red5/java/server/ ">http://svn1.cvsdude.com/osflash/red5/java/server/</a>にあります。trunkフォルダを手元に落としてきて、</p>

<p><pre>ant all</pre></p>

<p>でフルビルドできます。JDK6, antあたりが手元にあればOKです。「<a href="http://blog.katsuma.tv/2007/05/fedora_install_red5.html">FedoraにRed5をインストール</a>」もあわせてご参照ください。</p>
