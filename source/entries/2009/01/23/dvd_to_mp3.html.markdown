---
title: Mac OSXでライブDVDをmp3ファイルに変換
date: 2009/01/23 06:57:21
tags: osx
published: true

---

<p>（2011.11.7追記）0SExがLionで動作しなくなったので、<a href="http://blog.katsuma.tv/2011/11/gem_musical.html">Lion用のgem</a>を作成しました。</p>

<p>ライブDVDはよく買うので、mp3へ変換してiPodに入れて持ち歩く、というのは何回かやってるものの、この手順をすぐに忘れて途中で詰まるのでメモしておきます。当然ながらコンテンツ保護を破ってうんぬんすることを推奨するものではなくて、あくまで個人で楽しむためのものです。</p>

<h3>チャプターごとのvobファイルに変換</h3>
<p><a href="http://www.macupdate.com/info.php/id/9830">OSEx</a>というソフトを利用することでチャプターごとに分割した音声だけのvobファイルに変換してくれます。このソフト、すごく分かりにくいUIなんですけど、次のポイントだけ押さえればOKです。</p>

<ul>
<li>Ti(タイトル) -> 変更なし</li>
<li>Ch(チャプター) -> 変更なし</li>
<li>An(アングル) -> 変更なし</li>
<li>Vid(ビデオ) -> チェクを外す</li>
<li>Aud(オーディオ) -> 変更なし</li>
<li>Fmt -> "Prog. Streams"を選択</li>
<li>Seg -> "Chapter"を選択</li>
</ul>

<p>Beginボタンを押せば、変換が開始されます。変換は結構時間かかるのでのんびり待ちましょう。</p>

<h3>ffmpegでwavに変換</h3>
<p><a href="http://homepage1.nifty.com/~toku/software.html#a52decX">a52decX</a>なんてソフトもあって、これを利用するとaiffかmp3に変換できるようなのですけど、僕の環境だとよく変換にミスったり、そもそもこのソフトがよく固まって終了不可になったりするのでこれはパスします。</p>

<p>そこで、ffmpegで一度wavに変換します。ffmpegはMac Portsで簡単にインストールできます。</p>

<p>また、wavへの変換もオプションなしで素直に変換すればOKです。</p>

<p><pre>
ffmpeg -y -i hoge001.vob 001.wav
</pre></p>

<p>最初はffmpegでmp3に変換しようとしていたのですが、どうやっても64kbpsのビットレートでしかエンコードできず、他のビットレートにすると音割れがしてまともに再生できない状況でした。なのでmp3変換はパスしてとりあえずwavにしています。</p>

<h3>iTunesでwavをmp3/AACに変換</h3>
<p>最後にiTunes使ってmp3/AACに変換します。これが一番簡単かつ確実。</p>
<p>wavファイルをiTunesへD&Dするとライブラリに読み込まれるので、その後に右クリック＞mp3（か、AAC）に変換を選択すればOKです。</p>

<h3>まとめ</h3>
<p>mp3/AACへの変換も結構簡単にサクサクできちゃいます。これを機会に棚で眠ってるDVDを掘り起こしてみるのはいかがでしょうか？ちなみにこれを書いてるときは原田郁子さんのライブDVDを変換して取り込んでいました。</p>
<p><iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=katsumatv-22&o=9&p=8&l=as1&asins=B001GGBJ84&md=1X69VDGQCMF7Z30FM082&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</p>


