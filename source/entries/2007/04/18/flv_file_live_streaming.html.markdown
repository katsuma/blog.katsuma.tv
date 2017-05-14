---
title: FLVファイルの擬似ライブストリーミング
date: 2007/04/18 00:19:24
tags: actionscript
published: true

---

<p>
Flash（FLV）でライブストリーミングを行う場合、<a href="http://www.adobe.com/jp/products/flashmediaserver/flashmediaencoder/">FME( FlashMediaEncoder ) + FMS( Flash Media Server )</a>の組み合わせが、一番簡単な方法です。FMSは<a href="http://www.osflash.org/red5">Red5</a>で置き換え可能なので、完全にフリーソフトウェアのみでの環境構築も可能です。
</p>

<p>しかし、現状はFMEはソースとして外部入力のみを受け付ける仕様になっています。
WME(Windows Media Encoder)の場合、ファイルを利用したストリーミングが可能なので、すでに映像編集を終えたファイルをテレビ的にストリーミング配信を行うことが可能なのですが、FMEの場合は同様のことを行うことができません。
かと言って、FLVをWebサーバに配置していても、クライアントのFlashPlayerからの接続要求に対しては、オンデマンドストリーミングとなってしまい、ある時刻におけるユーザが見ている映像は、各ユーザ毎に異なるものとなります。</p>

<p>
そこで、FLVファイルをライブストリーミング配信するにはどうすればいいかと言うと、
<strong>Webサーバの時刻に応じてクライアントの再生ポイントをズラし（つまりシークし）、あたかも
ライブストリーミングを行っているかのように振舞わせる</strong>、ということでFLVファイルの擬似ライブストリーミングを行うことができます。
</p>

<p>アイディアさえひらめけば、ロジックも単純で実現しやすいのですが、実際は結構ハマるポイントもあったので、備忘録として手順をまとめておきたいと思います。</p>

<p>
まず、FLVファイルを再生するPlayerを作成します。これは<a href="livedocs.adobe.com/flash/8_jp/main/00003476.html">FLVPlaybackコンポーネント</a>を使えば簡単にできます。これをたとえばflvplayer.swfとでもしておくことにします。
swfは、FLVのファイルパスとシークポイントをHTMLレイヤーで操作できるように、swfを書き出すJavaScriptの関数を用意しておくと便利です。たとえばこんなものを用意しておきます。
</p>

<p>
<pre>
function showPlayer(flv, seek){
	var c = '&lt;object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" ' +
'codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" ' + 
'width="160" height="120" id="livead" align="middle"&gt;' + 
'&lt;param name="allowScriptAccess" value="sameDomain" /&gt;' + 
'&lt;param name="FlashVars" value="seek=' +seek + '&flv=' + flv + '" /&gt;' + 
'&lt;param name="movie" value="./flvplayer.swf" /&gt;' + 
'&lt;param name="quality" value="high" /&gt;' + 
'&lt;param name="bgcolor" value="#ffffff" /&gt;' + 
'&lt;embed src="./flvplayer.swf" quality="high" bgcolor="#ffffff" width="160" height="120" ' + 
'name="livead" align="middle" allowScriptAccess="sameDomain" FlashVars="seek=' + seek + '&flv=' + flv + '"' + 
'type="application/x-shockwave-" pluginspage="http://www.macromedia.com/go/getflashplayer" /&gt;' + 
'&lt;/object&gt;';
	document.write(c);
}
//Usage:
showPlayer('http://hoge.com/aaa.flv', '90');
</pre>
</p>

<p>
たとえば上の例だと、http://hoge.com/aaa.flvというFLVファイルが、開始90秒後の位置から再生されるようなflvplayer.swfをHTML上に書き出すこととなります。
念のため確認しておくと、HTMLからswfにパラメータを渡すときはobjectタグ、embedタグそれぞれについて、変数FlashVarsに対して値aaa=bbb&ccc=ddd形式で渡すこととなります。
</p>

<p>
また、秒数についてはサーバサイド言語なら簡単に取得可能かと思います。たとえばPHPなら
date("i")で分が、date("s")で秒が取得できるので、先頭のゼロを取り除くなどすると、求めたいシークポイントは計算できると思います。
</p>

<p>
次にActionScriptの記述です。flvplayerは内部でインスタンス名[flvPlayer]のFLVPlaybackコンポーネントを持っていることとします。HTMLから渡されたseek、flvパラメータはそれぞれs:Number, flv:Stringに渡されるとすると、次のようなコードになります。
</p>

<p>
<pre>
var s : Number = Number(_root.seek);
var flv : String = _root.flv;
var listenerObject : Object = new Object();

listenerObject.ready = function(eventObject:Object) : Void {
    flvPlayer.seekSeconds(s); // (1)
    flvPlayer.play();
}
flvPlayer.addEventListener("ready", listenerObject);

listenerObject.seek = function(eventObject:Object) : Void {
	if(eventObject.playheadTime < s){  // (2)
		reSeek();//(3)
	}
}
flvPlayer.addEventListener("seek", listenerObject);

function reSeek() : Void{
    flvPlayer.seekSeconds(s);
    flvPlayer.play();
}
</pre>
</p>

<p>ポイントは次の２つです。</p>

<p>
まず、(1)ですが、<strong>FLVが読み込まれて再生が開始できる状態</strong>になるとflvPlayerからは<strong>readyイベント</strong>が起こります。この段階でseekSeconds()、またはseek()で再生させたいポイントまで再生ポイントをズラします。seekさせるとflvPlayerはseekイベントが発生するのですが、ここでのポイントとして<strong>seekイベントは実際はflvPlayerがplay()された後でないと発生しない</strong>、ということです。（*1）
</p>

<p>でも、注意深くこの文章を読んでいる人は<strong>「あれ？でもseekイベントとか関係なくない？seek()してplay()したらそれで終了なんでは？？」</strong>と思う人も多いはず。確かに、seek()が成功してすんなり再生ポイントがズレたらそれでOKなんですけども、実際はseek()だけではうまく再生ポイントがズレず、直後のplay()で何事も無かったように１フレームから再生される、、なんてことが結構あります。（→この理由は謎です。キーフレームとの兼ね合いもありそうですが、よく分かりません。なんとなく断言できるのは、seek()はどうも信頼できないようです。。）</p>

<p>そこで、seekイベントをキャッチした(2)がポイントになります。ここではseekイベントが起こったときに、eventObject.playheadTimeを参照して、現在のplayheadTime（再生してるファイルポインタみたいなもの、と考えてよさそうです）がどこを指しているのかを確認します。</p>

<p>
seek()が成功している場合は、0以上の指定した再生箇所（seek位置）あたりまでズレているのですが、成功せずに<strong>失敗している場合、依然としてseek位置が0近くの値のまま、であることがあります。</strong>上の例では、playheadTimeが再生箇所より値が小さい場合（*2）に再びseekさせる処理を行っています。
</p>

<p>
実際は１度、seekを再試行するだけではうまく動作する保証はありません。そこで、(3)のように<strong>seekイベントリスナの中でseek()を行うことで、再帰的にseek()を試行しつづけることが可能になります。</strong>つまり、ここで(1)でseekイベントを一度強制的に引き起こした利点が出てくるわけですね。
また、ここで行っているように永遠に再帰試行することが気になる場合はカウンタを設けて適当なタイミングでbreakしてもいいかもしれません。
</p>

<p>（*1）このseekイベントとplay()との関係は<a href="http://livedocs.adobe.com/flash/8_jp/main/00003595.html ">この仕様</a>から読み取ることができます。</p>

<blockquote>シークの完了後に時間を取得するには、seek イベントをリスンする必要があります。このイベントは、playheadTime プロパティが更新されるまで開始しません。
</blockquote>

<p>
playheadTimeプロパティとは、上でも述べてうますが再生ヘッド（ポインタ）と考えてよさそうです。このプロパティはplay()が呼ばれて再生状態にならないと更新されないので、まとめて考えるとplay()が呼ばれた後でないと、seek()してもseekイベントが起こらない、ということになります。
</p>

<p>
（*2）<a href="http://livedocs.adobe.com/flash/8_jp/main/00003594.html">仕様</a>では、次のようになっています。</p>

<blockquote>プログレッシブダウンロードの場合はキーフレームへのシークしか実行できないので、シークすると、指定した時間以降にある最初のキーフレームの時間に移動します 
</blockquote>

<p>
つまり、シークポイント（指定した時間）より以前にヘッドが存在する場合はseek()がうまく動作していない、ということになります。
</p>

<p>このように、seek()を適切なタイミングでリトライさせることで、任意の再生ポイントからのFLVファイルでのストリーミングが可能となります。実際は、これだけのコードだとplay()で１フレーム目が再生された直後にseek()されることもあるので、映像が最初は大きく乱れることもあると思います。その場合、(2)のif文のところまでは「Loading」のMovieClip（loading_mc）を用意しておき、reSeek()を行わなくてもいい段階で
</p>

<p>
<pre>
loading_mc._visible = false;
</pre>
</p>

<p>
などの処理を行うと、自然に見えるかもしれません。
</p>

<p>以上をまとめると、こんな感じです。</p>

<p>
<ol>
<li>seek()をまず試みる</li>
<li>直後にplay()。ここでseek()が成功したら儲けもの。失敗してもとりあえずseekイベントが上がる</li>
<li>seekイベントリスナでplayheadTimeを確認</li>
<li>seek()が失敗していた場合はplayheadTimeがゼロ近くの値になっているので、リスナ内で再びseek()</li>
<li>2度目以降のseek()は再帰的に試行され、playheadTime位置が確認される</li>
</ol>
</p>

<p>何にせよ、今回のseek()に関することは、結構なバッドノウハウです。。仕様を完全には読みこなせていないので、もしかすると「そんなの常識だよ！」なんてこともあるかもしれませんが、その場合はぜひコメントいただければと思います。また、「そこは間違ってる！」なんかの意見もぜひぜひお待ちしています。</p>
