---
title: IEのFlashPlayerはページを閉じてもrtmpセッションが切れないことがある
date: 2009/03/17
tags: actionscript
published: true

---

<p>タイトルの現象は確認したものの、発生条件は確かなことはまだ言えないかも。。とりあえず現象報告とその対応策について。</p>

<h3>問題</h3>
<p>FlashPlayer上でRTMPセッションを張っているときにおいて、通常はページ遷移時においてFlashPlayerのインスタンスも同時に破棄される(はずな)ので、RTMPセッションもcloseされます。ところがIE7 + FlashPlayer9または10において、ページ遷移ではFlashPlayerが破棄されないケースがあるようです。なので、RTMPサーバ(たとえばWowza Media Server)にセッションを張っている場合、FlashPlayerが破棄されないことから、セッションが張りっぱなしになって、サーバ側でdisconnectをハンドリングできないことになります。</p>

<p>では、どうすれば破棄されるかというと、「IEを完全に終了」させて初めてFlashPlayerが破棄され、セッションが切れるようです。（ブラウザを閉じたときに初めてdisconnectイベントが上がってくることを確認しました。）Player側は、connectしてコンテンツを再生することについてはよく考えがちですが、ページのunload時においてはそもそも何も表示されていない状態なので、正常に接続がcloseされてあるかはちゃんと見ていないケースが多かったのが問題でした。</p>

<p>さて、このdisconnectイベントが上がってこない、というのは結構困るケースもあります。たとえばconnectイベントとdisconnectイベントが起きた時間を保存しておくと、サーバの任意の時刻におけるユーザの最大同時接続数を計測できますが、その計測はdisconnectイベントが上がってこないと難しくなります。（これはWebレイヤーだけだとちょっと難しいですね。）なので、この問題について、何らかの対策が必要となります。</p>

<h3>対応策</h3>
<p>対応策としては、こんな手順で対応できました。割と素直な方法。</p>
<p><ol>
<li>HTMLページのbeforeunloadイベントをフック</li>
<li>RTMPセッションを張っているswfに対してExternalInterface経由でメソッド呼び出し</li>
<li>swfは呼び出されたメソッドにおいて、NetConnectionをclose</li>
</ol></p>

<p>と、こんなかんじです。beforeunloadのフックについてはこんなかんじでいいですね。swfはobject要素のid属性、およびembed要素のname属性が"externalpl"で指定されてあるものとします。ExternalInterfaceで呼び出すメソッド名がcloseAllになります。</p>

<p>
<pre>
	window.onbeforeunload = function(event){
		var swf = (document.all? window['externalpl'] : document['externalpl']) || null;
		if(swf && swf.closeAll) { swf.closeAll();} 
		document.getElementById('swf-container').innerHTML="";
	};

</pre>
</p>

<p>ちなみに、メソッドを呼び出した後はswfをロードしているHTML要素のswf-containerを空にして、FlashPlayerをunloadさせています。実際はこれまでに書いたとおり、IEにおいてはunloadされないのですが、それ以外の環境ではこの時点でunloadされるのでswfのファイルサイズが大きい場合、ページ遷移を行いやすくする利点があります。（最近知りました）</p>

<p>コールされるswf側はExternalInterface.addCallbackで実行されるメソッドを登録しておけばOKですね。</p>

<p><pre>
import flash.external.ExternalInterface;
...
ExternalInterface.addCallbak("closeAll", _closeAll);
...
function _closeAll():void{
      nc.close();
      nc = null;
} 
</pre></p>

<p>これでIEのFlashPlayerを利用している場合でも、RTMPサーバ側でdisconnectイベントをフックすることが可能になります。なかなか面倒なバッドノウハウでした。。</p>

<h3>ちなみに</h3>
<p>この現象を確認したのはWowza Media Server1.6.0です。FMSだとちゃんとイベントが上がってきたりするのかどうか、なんかも気になるところです。</p>


