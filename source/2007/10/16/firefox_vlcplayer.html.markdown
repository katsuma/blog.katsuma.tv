---
title: FirefoxでVLCを利用する
date: 2007/10/16
tags: javascript
published: true

---

<p>ブラウザ上でメディアファイルの再生、となると最近ではYouTubeやニコニコ動画に代表されるように、FlashPlayer上でFLVファイルを再生、というのがほぼ等価とされています。実際、FlashPlayerの普及率は95%以上ともされていますし、この流れは当然といえば当然だと言えます。その次にはWindows Media Playerが続くことになるでしょうか。</p>

<h3>VLCがアツい！</h3>
<p>ただ、忘れちゃならない、というか知らない人も多いかもしれませんが、オープンソース（GPL）のメディアプレーヤーで<a href="http://www.videolan.org/vlc/">VLC media player</a>（以下、VLC）というものがあります。これがなかなかアツいのです。</p>

<h3>対応プラットフォームが多すぎる</h3>
<p>VLCは、スタンドアロンのプレイヤーなのですが、対応プラットフォームがかなり多いです。Windows,Mac, Linuxはもちろん、FreeBSD, Solaris, Zaurusなんかの携帯端末まで、よくもまぁここまで対応させたな、というくらい対応プラットフォームが多くあります。</p>

<h3>対応メディアも多すぎる</h3>
<p>対応メディアのフォーマットもかなり幅広くサポートしています。ファイル形式だけでも、AVI・DivX・ASF・MP4・MOV・MPEG2・OGG・OGM・Matroska・WAV・FLV・・・などなど。もちろん全てのプラットフォームで全てのフォーマットに対応してはいないのですが、Windows、MacOS、LinuxなんかではQuickTimeやWindows Mediaにも対応しているので、VLCだけでも有名どころの多くのファイル再生が可能なので、万能プレイヤ－として検討の価値があると思います。実際、僕も自宅のPCではVLCをメインのプレイヤーとして利用しています。</p>

<h3>Webへの埋め込みもできる！</h3>
<p>本題はここから。このVLCですが、フルパッケージでインストールするとFirefox用のプラグインがインストールされます。このプラグインを利用するとJavaScriptだけであたかもFlashで使ったかのような、かなり柔軟なプレイヤーが作れてしまいます。</p>

<p>で、実際にいろいろ触ってみたのですが、なかなか使い勝手はよさそうです。ただ、Firefoxに組み込むにあたって、少しクセもあるのでその辺りをまとめたいと思います。</p>


<h3>インストール</h3>
<p>2007.10.15現在、VLCの最新バージョンは0.8.6cですが、このバージョンだと僕の環境ではFirefoxプラグインが正常に動作しませんでした。（必要なファイルが欠けている）ですので、１つ前の0.8.5を利用してみます。以前のバージョンは<a href="http://download.videolan.org/pub/videolan/vlc/">こちら</a>からアクセスが可能です。</p>

<p>Windows版は<a href="http://download.videolan.org/pub/videolan/vlc/0.8.5/win32/vlc-0.8.5-win32.zip">zipアーカイブ</a>されているものと<a href="http://download.videolan.org/pub/videolan/vlc/0.8.5/win32/vlc-0.8.5-win32.exe">インストーラ形式</a>のものの2種類ありますが両方DLします。まずインストーラ形式のファイルをダブルクリックでインストールを進めていきます。ここで、Firefox用のプラグインをインストールするかどうか、のチェックボックスが表示されますが、実際はここでプラグインをインストールするように選択しても<strong>特に何もプラグインファイルはインストールされない</strong>ので要注意です。多分、インストーラのバグだと思います。</p>

<p>なので、インストーラ版でインストールを行った後、zip版を解凍し、プラグインを入手します。プラグインはzipを解凍してできる「mozilla」フォルダの中にある「npvlc.dll」「vlcintf.xpt」の2つのファイルです。これらのファイルを「C:\Program Files\Mozilla Firefox\plugins」にコピーし、Firefoxをリスタートさせると音インストール完了です。（VLC自体のインストールもzip版を適当なフォルダに解凍するだけで問題ないと思うのですが、僕の環境ではインストーラ版からインストールしないと正常に動作しなかったため、こちらからインストールされることをおすすめします）</p>

<h3>Javascriptからのアクセス</h3>
<p>基本はembedタグで「type="application/x-vlc-plugin"」を指定し、「target="http://hoge.flv"」などと指定すると、指定したメディアファイルが再生される仕組みとなります。たとえばこの例で言うと、次のようなHTMLを記述します。</p>

<p><pre>
&lt;embed type="application/x-vlc-plugin"
	name="vlc" autoplay="yes" loop="yes" width="400" height="300"
	target="http://hoge.flv" /&gt;
</pre></p>

<p>こうするとhoge.flvがプログレッシブストリーミングで再生開始されます。じゃ、停止はどうするの？と、いう話になりますが、これはJavascriptで対応します。Firefoxではembedタグのnameで指定した名前でVLCへのアクセスが可能となります。たとえばここではname="vlc"となっているので、次のようなコードで停止が可能です。</p>

<p>
<pre>
var vlc = document.vlc;
vlc.stop();
</pre>
</p>

<p>と、かなり直感的で簡単！このあたりの仕様は<a href="http://www.videolan.org/doc/play-howto/en/ch04.html#id293992">公式サイト</a>でまとめられていますが、pause（一時停止）、add_item（プレイリストに追加）、seek（再生開始ポイントをズラす）など、基本的な機能がそろっているので、オレオレプレイヤーを作るのも簡単です。</p>

<h3>で、せっかくなんでライブラリ作ってみた</h3>
<p>デフォルトで用意されている関数名がほんの少し好みじゃなかったり、毎回embedタグを書くのも面倒なんで、これらをラップするライブラリを作ってみました。（<a href="http://lab.katsuma.tv/js/vlc.js">vlc.js</a>）使い方は、embedタグのオプションをセットした無名オブジェクト、あと書き出す場所（id）を指定すればOKです。場所のidは指定した場合はその場所にinnerHTML書き換え、指定しない場合はその場でdocument.writeで書き出しています。</p>

<p>で、<a href="http://lab.katsuma.tv/vlc/" target="_blank">プレイヤーのサンプル</a>を作ってみました。vlc.jsの使い方もこれ見ていただくと理解できるか、と思います。ちなみにprototype.js使ってクリックイベントに関数を登録しています。</p>

<p>もちろん、このサンプルはVLCとFirefox用プラグインがインストールされてある環境じゃないと動きません。今回はPlay, Pause, Stopの簡単なテキストリンクにしていますが、CSSで画面の上に重ねることもできますし、effect.jsなんかでおしゃれエフェクトをかけるのもよいと思います。</p>

<h3>で、これはどこで使えるの？</h3>
<p>今回のような単純にWebページに埋め込んだような例だと使い辛いですが、XULでFLV Playerなんかを作る場合なんかだと、今回のようなVLCは使い勝手がかなりいいと思います。実際、<a href="http://www.getmiro.com/">Miro</a>なんかもソースを見てみるとVLCを利用しているようです。Flash Playerは再配布が不可能ですが、VLCをPlayerと一緒に梱包するのはライセンスの問題だけ気をつければ可能です。</p>

<p>ぱっと思いついたのはXULだけですが、まだまだ遊べそうかも。何かアイディア浮かんだ方はいろいろ手を動かしてみるのもアリかもしれません！</p>

