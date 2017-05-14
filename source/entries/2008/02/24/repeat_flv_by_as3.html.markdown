---
title: ActionScript3でFLVをストリーミングでリピート再生
date: 2008/02/24 03:04:21
tags: actionscript
published: true

---

<p>RTMPストリーミングでリピート再生の話。ActionScript2の時と書き方が変わってて混乱したので備忘録。NetStream.clientオブジェクトにハンドラを設定した独自のオブジェクトを参照させてあげないとダメだった。</p>

<p>次のコードをRTMPHandle.asで保存。</p>
<p><pre>
package {
	import flash.net.NetStream;

	public class RTMPHandle {
		
		private var stream:NetStream;
		private var session:String;
	
		public function RTMPHandle(stream:NetStream, session:String){
			this.stream = stream;
			this.session = session;
		}
		
		
		public function onPlayStatus(info:Object):void {
			if(info.code=="NetStream.Play.Complete"){
				this.stream.play(this.session);
			}	
		}
		public function onMetaData(info:Object):void {
			
		}
		
	}
}
</pre></p>

<p>その上でリピート再生させてやりたいNetStream#clientに対してRTMPHandleを参照させる。</p>

<p><pre>
var ns  : NetStream = new NetStream(nc);
var session : String = "megane";
ns.client = new RTMPHandle(ns, session);
</pre></p>

<p>これでリピート再生ができる。onMetaDataで空のメソッドを定義してるのは、これを定義していないとdebug用のFlashPlayerを使っていると警告(エラーだっけかな？)が出て目障りだったから。普通のFlashPlayerを使っている分には特に問題は無さそう。</p>


