---
title: 意図したNetStatusEventが上がってこないことへの対策
date: 2008/04/15 20:23:03
tags: actionscript
published: true

---

<p>Cameraオブジェクトを利用して、RTMPでライブストリーミングを行うときに、ストリーミングの開始、終了をハンドリングするために肝なのが<a href="http://livedocs.adobe.com/flash/9.0_jp/ActionScriptLangRefV3/flash/events/NetStatusEvent.html">NetStatusEvent</a>。NetStreamに対してハンドラを設定しておき、開始、終了を検知します。</p>

<p><pre>
ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
...
function netStatusHandler(evt:NetStatusEvent) : void {
	if(evt.info.code == "NetStream.Play.Start"){
		// 配信開始 				
	} else if(evt.info.code == "NetStream.Play.Reset"){ 
		// 配信中	
	} else if(evt.info.code == "NetStream.Play.UnpublishNotify"){
		// 配信停止
	} else {
		// その他
	}
}
</pre></p>

<p>基本的にはこんな感じ。</p>

<h3>罠が多い</h3>
<p>ところが、あくまでこの情報は「基本的」なもので、結構アテにならないことが多いです。NetStreamで受信しているストリームが１つであればまだイベントの発生も安定していますが、複数ストリームを同時に受信している場合、たとえば終了イベントがうまく起こらず、うまく終了処理が行えないことがあります。</p>

<p>
このような場合、映像を表示しているVideoオブジェクトのclear()を呼び出すことができず、残像が残っちゃったようなことになってしまう、格好悪い表示になってしまうことがあります。今回はこんなとき、どうやってハンドリングすればいいか、という話。</p>

<h3>Timerを走らせる</h3>
<p>じゃあどうすればいいか、というと本当にライブ配信をしているかどうか、x秒ごとに定期的に映像のFPS(=フレームレート)をチェックするTimerを走らせるといい結果になります。一定時間ごとに数回確認して、n回連続して同じ低レートの値であれば、すでに表示しているユーザは配信を停止している、という発想。</p>

<p>ここでのポイントは<strong>「n回連続して同じ低レートの値であれば」</strong>という点。終了検知なら、FPS=0でハンドリングしてもよさそうですが、配信を停止していてもFPSは0になるとは限らず、0.1, 0.2くらいの値が出ることは割と多いです。なので、「0」ではなく、「低レートの値」がポイント。</p>

<p>また、配信対象物が停止している場合（風景とか）、これもかなり低い値が出ます。ただ、カメラで実際に映像を取得しているかぎり、毎秒常に同じ値が出ることはまず無いので、「n回連続して」というのが効いてきます。</p>

<p>実際に、どんな値であればいいのか、というと何度か試行錯誤した結果、こんなパラメータを僕は利用しています。</p>

<p><ul>
<li>x = 15</li>
<li>FPS = 0.2</li>
<li>n = 3</li>
</ul></p>

<p>つまり、「15秒ごとにFPSを調べて0.2以下の同じ値が3回連続して続いたら、そのユーザは配信を停止していると見なす」という意味ですね。</p>

<h3>NetStream.Play.Resetは実は重要</h3>
<p>あと、普段はほとんど利用しないであろうNetStatusEvent#info.code値のNetStream.Play.Resetですが、実は結構重要です。と、いうのも、ストリーミングを行っている中で、このイベントは割と頻繁に起こります。<a href="http://livedocs.adobe.com/flash/9.0_jp/ActionScriptLangRefV3/flash/events/NetStatusEvent.html">Livedocs</a>によると「再生リストのリセットが原因です。」と、ありますが意味はよくわかりません。よく分かりませんが頻繁に発生します。頻繁に発生する、ということは<strong>「このイベントが発生しているかぎりユーザは停止せずに再生しつづけている」</strong>ということを示すものとして利用できます。</p>

<p>具体的には、上で示したFPS確認ロジックにおいて、NetStatusEvent#info.code==NetStream.Play.Resetであれば、確認カウンタをクリアさせます。（たとえFPSが低い値を出していても、ユーザは確実に再生を続けているから）。これらをまとめて、こんなTimerを用意しておけばOKです。</p>
<h3>PlayerManager.as(的なもの)</h3>
<p><pre>
var timer:Timer = new Timer(15000);
timer.addEventListener(TimerEvent.TIMER, streamCheckerHandler);
timer.start();
...

function streamCheckHandler(evt:TimerEvent) : void {
	for(var i:int = 0; i&lt;players.length; i++){
		var player : Player = players[i];
		var ns : NetStream = player.getNetStream();
		var fps : Number = ns.currentFPS;
		if(fps < 0.2) {
			player.checkFPSHistory(fps);
		} 
	} 
}
</pre></p>

<h3>Player.as(的なもの)</h3>
<p><pre>
var prevFPS : Number = 0;
var fpsHistoryCount : int = 0;
const FPS_HISTORY_MAX_COUNT : int = 3;
...
function checkFPSHistory(fps : Number) : void {
	if(fps!=prevFPS){
		prevFPS = fps;
		fpsHistoryCount = 0;
	} else {
		fpsHistoryCount++;
	}			
	if(fpsHistoryCount==FPS_HISTORY_MAX_COUNT){
		unPublish();
		prevFPS = 0;
		fpsHistoryCount = 0;
	}
}
...
ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
...
fuction netStatusHandler(evt : NetStatusEvent) : void {
	if(evt.info.code == "NetStream.Play.Start"){
		// start to publish		
	} else if(evt.info.code == "NetStream.Play.Reset"){ 
		fpsHistoryCount = 0;
	} else if(evt.info.code == "NetStream.Play.UnpublishNotify"){
		stopPublish();
	} 
}
</pre></p>

<p>PlayerManagerがいくつかのPlayerオブジェクトを作成、参照をもってTimerを実行しているオブジェクトです。PlayerはVideoオブジェクトやNetStreamオブジェクトなどをメンバに持ち、実際に映像の再生を行うもの。こんな感じで全体の流れを掴んでいただければと思います。</p>


