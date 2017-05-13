---
title: ExternalInterfaceでは対象swfをonLoad以降にロードしてはダメ
date: 2008/11/19
tags: actionscript
published: true

---

<p>何かとはまりやすいJavaScript-ActionScript連携のExternalInterface。以前にもこんなエントリ書いてました。</p>

<p><ul>
<li><a href="http://blog.katsuma.tv/2008/02/externalinterface_error.html">ExternalInterfaceでActionScriptの関数呼び出し失敗への対策</a></li>
</ul></p>

<p>今回、また新たにハマりポイントがあったのでメモしておきます。</p>

<h3>IEでswfの参照が取得できない(nullが返る)</h3>

<p>通常、JSからASの関数をコールする場合は</p>

<p><pre>
&lt;object width="320" height="240" align="middle" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" id="externalpl"&gt;
&lt;param value="sameDomain" name="allowScriptAccess"/&gt;
&lt;param value="true" name="allowFullScreen"/&gt;
&lt;param value="/swf/hoge.swf" name="movie"/&gt;
&lt;param value="high" name="quality"/&gt;
&lt;param value="#111111" name="bgcolor"/&gt;
&lt;embed width="320" height="240" align="middle" 
pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" 
allowscriptaccess="sameDomain" allowfullscreen="true" bgcolor="#111111" quality="high" 
src="/swf/hoge.swf" name="externalpl"/&gt;
&lt;/object&gt;
</pre></p>

<p>と、hoge.swfがある場合にJS側で</p>

<p><pre>
var player = document.all? window['externalpl'] : document['externalpl'];
</pre></p>

<p>と、すると</p>

<p><pre>player.hello();</pre></p>

<p>なんかが実行できます。ただし、あらかじめhoge.swf側で</p>

<p><pre>
ExternalInterface.addCallback('hello', this._hello);
function _hello() : void
{
  // hogehoge 
}
</pre></p>

<p>などとしておく必要があります。</p>

<p>今回のハマりは、このJSからASの関数を呼び出すときに、<strong>IEの時の場合のみASの関数が実行できない、詳しく言うとASの関数を実行するためのFlashの(関数)オブジェクト参照を取得できず、nullが返ってくる</strong>という問題がありました。逆にFirefox, Safariなどではちゃんとplayerの参照が取得できて(正常に参照が取得できると、関数オブジェクトが取得できます)、helloメソッドの実行もうまくいくわけです。</p>


<h3>よかれと思ったことが仇に</h3>
<p>今回、というか僕は常々FlashVarsで値を渡しやすくするために、swfのタグの書き出しはHTMLを直接書くのではなくて、ラップするJavaScriptの関数を作って、それ経由で書き出すようにしています。いわゆるSWFObjectを利用してもいいのですが、たかだかタグ書き出しのためだけにライブラリをロードするのも通信がバカバカしいので自作することが多いです。たとえば</p>

<p><pre>
	var param = {
		type : 'windows', 
		name : 'vista'
	};
	var o = new OS(param);
	o.start();
</pre></p>

<p>な感じでJSのOS#startメソッドを実行するとFlashVarsでtype=windows&name=vistaの値を渡してobject/embedタグが書き出される、のような感じです。</p>

<p>こうしておくと書き出し方法をdocument.writeのように愚直に書き出すこともできるし、swfのサイズが大きい場合にHTMLがロードし終わった後にinnerHTML差し替えによって遅延書き出し方法を取る事も出来ます。このように書き出し方法やそのタイミングを自分の好みで変えられる上に、後者のような方法だとページ全体の体感速度を上げることもできて非常に便利なのです。<strong>ただし、そこに罠があったのです。。</strong></p>


<h3>swfをonLoad以降に書き出すとマズい</h3>
<p>今回のケースではjQueryを使って、DOMContentLoaded/onLoadのタイミングでswfを動的に挿入させるようにしていました。要するにこんなかんじ。</p>

<p><pre>
$(function(){
	var param = {
		type : 'windows', 
		name : 'vista'
	};
	var o = new OS(param, "container");
	o.start();  
});
</pre></p>

<p>知っている方も多いかと思いますが、jQueryでは関数を$()で囲む事でDOMContentLoaded(画像のロードを待たない、純粋なDOM Tree構築後のタイミング。ただしDOMContentLoadedをサポートしていない場合はonLoadのタイミング。)で処理を実行させることができます。このタイミングで指定ID要素(=上の例だと"#container")に対してinnerHTMLにobject/embed要素書き換えでswfをロードさせるようにしました。FirefoxやSafariはこれで何ごともなく動くのですが、IEだと動作しません。</p>

<p>では、どうすればいいか？というと、object/embed要素の書き出し方法をbody.onload時ではなく、単純にXHTML上に<strong>document.writeでobject/embed要素書き出し</strong>に修正すると動きました。</p>


<h3>どうやら</h3>
<p>この結果から推測するに「<strong>IEはbody.onload時（DOMContentLoaded時）において存在しないswfの参照は取得することができない</strong>」ということが言えそうです。つまり、ExternalInterfaceを利用したい場合は、<strong>対象swfはDOMContentLoaded以降にロードされるのではなく、DOMContentLoaded以前にロードされておく必要がある</strong>、ということですね。もっと言うと、IEでwindow['swf_id']で参照するためのDOM Treeの参照(またはその複製？)がDOMContentLoaded以降に更新されていないように思われます。</p>

<p>知っておけばハマらないのですが気づかなければなかなか抜け出せない罠でした。しっかしExternalInterfaceの罠の多さはほんと異常です。。それもIEでハマることがやたら多い印象。このあたり、IE8になると少しは解消されたりするんでしょうか？？</p>


