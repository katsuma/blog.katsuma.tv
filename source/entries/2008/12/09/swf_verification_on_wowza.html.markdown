---
title: Wowza Media ServerでSWFVerification(っぽいこと)をする方法
date: 2008/12/09
tags: actionscript
published: true

---

<p>Kitasando.asで話題になったのがSWFVerification。これはストリーミングサーバが特定のswfからのアクセスしか許さない、という機能。FMS3は接続を行うswfをあらかじめ登録しておくことで、接続時にハッシュ値の整合性を確認し、1byteでも異なっている場合は接続を許可しない、という仕様だそうです。（どうやって整合性とってるのかは謎。<a href="http://unknownplace.org/memo/2008/12/08">typesterさんも言及してました。</a>）</p>

<p>で、そんな機能ってたしかWowzaにもあったはずだよなぁ。。と思って調べてみるとそれっぽい機能がありました。ただ、FMS3とは少し違う仕様で、「接続を許可するswfの設置サーバのドメインを登録できる」というもの。ハッシュ値照合までしないので、厳密にはVerificationではないものの、セキュリティ的には結構これで事足りる気はします。つまりローカルにswfを落としてそこから接続を試みるような野良swfは接続できない、ということですね。</p>

<p>実際、FMS3のSWFVerificationはデプロイが問題になるみたいです。と、いうのもクライアントのswfを書き出し直すたびにFMS3にデプロイしなおす必要があるので、この作業が煩雑になる問題があるみたいですね。それを考えるとWowzaの接続元ドメインのホワイトリスト制はセキュリティという観点では割といい機能なんじゃないのかな、とも思います。</p>

<h3>設定方法</h3>
<p>超簡単。Application.xmlの冒頭のConnections/AllowDomainsの箇所に、許可ドメインをカンマで区切って羅列します。こんなかんじ。</p>

<p><pre>
&lt;Connections&gt;
	&lt;AutoAccept&gt;true&lt;/AutoAccept&gt;
	&lt;AllowDomains&gt;lab.katsuma.tv&lt;/AllowDomains&gt;
&lt;/Connections&gt;
</pre></p>

<p>こうすると同じswfでもlab.katsuma.tvに設置したもののみがこのアプリケーションに接続できて、他のドメイン（たとえば、blog.katsuma.tv）に設置されたswfは接続できない、というものです。</p>

<p>また、検証コードも書いてみました。手元のWowzaに「live」というアプリケーションを作ってみてください（rtmp://localhost/live に接続できる状態にする）。その後、上でかいたドメイン縛りの記述を付け加えてWowzaを再起動し、Firebugを開いた状態で次のURLにアクセスしてみてください。</p>

<p><ul>
<li><a href="http://blog.katsuma.tv/swf/RTMPConnectionTest.swf?server=rtmp://localhost/live/&id=blog">blog.katsuma.tv</a></li>
<li><a href="http://lab.katsuma.tv/swf/RTMPConnectionTest.swf?server=rtmp://localhost/live/&id=lab">lab.katsuma.tv</a></li>
</ul></p>

<p>前者は</p>
<p><pre>
start init
["init", "blog", "rtmp://localhost/live/"]
start connect
["blog", "NetConnection.Connect.Rejected"]
["blog", "NetConnection.Connect.Closed"]
</pre></p>

<p>こんなかんじのログが出て、後者は</p>

<p><pre>
start init
["lab", "init", "rtmp://localhost/live/"]
["lab", "NetConnection.Connect.Success"]
</pre></p>

<p>こんなログが出力されるかと思います。どちらも同じswfですが接続元から接続可能かどうかの結果が分かれています。</p>

<h3>まとめ</h3>
<p>SWFVerificationでWowzaの導入をためらっていた方はこの方法を検討してみる、というのも手かもしれません。デプロイも気にしなくていいから楽ですよ！</p>

<h3>ソースコード</h3>
<p>あと、いきなりローカルに接続されると怪しく思う人もいると思うのでソース晒しておきます。突貫コードですけど。ちなみに<a href="http://github.com/hotchpotch/as3rails2u/tree/master">secondlifeさんのlog関数</a>を利用しています。</p>
<h4>RTMPConnectionText.mxml</h4>
<p><pre>
&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute"
	paddingTop="0" paddingRight="0" paddingBottom="0" paddingLeft="0"
	creationComplete="init()"&gt;
	
	&lt;mx:Script&gt;
		&lt;![CDATA[
			
			private var swfID:String;
			
			private function init() : void 
			{				

				log("start init");
				var server:String = Application.application.parameters.server || '';
				this.swfID = Application.application.parameters.id || '';
				log( this.swfID, "init", server);
			
				var nc : NetConnection= new NetConnection();
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
				nc.connect(server);
			}
			
			private function netStatusHandler(evt:NetStatusEvent) : void
			{
				var code : String = evt.info.code;
				log(this.swfID, code);
			}
			
			private function ioErrorEventHandler(evt:IOErrorEvent) : void
			{
				log(this.swfID, evt);
			}
			
		]]&gt;
	&lt;/mx:Script&gt;
	
&lt;/mx:Application&gt;
</pre></p>

<h4>Application.xml</h4>
<p>Wowza/conf/live/につっこんで再起動。</p>
<p><pre>
&lt;Root&gt;
	&lt;Application&gt;
		&lt;!-- Uncomment to set application level timeout values
		&lt;ApplicationTimeout&gt;60000&lt;/ApplicationTimeout&gt;
		&lt;PingTimeout&gt;12000&lt;/PingTimeout&gt;
		&lt;ValidationFrequency&gt;8000&lt;/ValidationFrequency&gt;
		&lt;MaximumPendingWriteBytes&gt;0&lt;/MaximumPendingWriteBytes&gt;
		&lt;MaximumSetBufferTime&gt;60000&lt;/MaximumSetBufferTime&gt;
		--&gt;
		&lt;Connections&gt;
			&lt;AutoAccept&gt;true&lt;/AutoAccept&gt;
			&lt;AllowDomains&gt;lab.katsuma.tv&lt;/AllowDomains&gt;
		&lt;/Connections&gt;
		&lt;!--
			StorageDir path variables
			
			${com.wowza.wms.AppHome} - Application home directory
			${com.wowza.wms.ConfigHome} - Configuration home directory
			${com.wowza.wms.context.VHost} - Virtual host name
			${com.wowza.wms.context.VHostConfigHome} - Virtual host config directory

			${com.wowza.wms.context.Application} - Application name
			${com.wowza.wms.context.ApplicationInstance} - Application instance name
			
		--&gt;
		&lt;Streams&gt;
			&lt;StreamType&gt;live-lowlatency&lt;/StreamType&gt;
			&lt;StorageDir&gt;${com.wowza.wms.AppHome}/content&lt;/StorageDir&gt;
			&lt;Properties&gt;
				&lt;!-- Properties defined here will override any properties defined in conf/Streams.xml for any streams types loaded by this application --&gt;
				&lt;!--
				&lt;Property&gt;
					&lt;Name&gt;&lt;/Name&gt;
					&lt;Value&gt;&lt;/Value&gt;
				&lt;/Property&gt;
				--&gt;
			&lt;/Properties&gt;
		&lt;/Streams&gt;
		&lt;SharedObjects&gt;
			&lt;StorageDir&gt;&lt;/StorageDir&gt;
		&lt;/SharedObjects&gt;
		&lt;Client&gt;
			&lt;IdleFrequency&gt;-1&lt;/IdleFrequency&gt;
			&lt;Access&gt;
				&lt;StreamReadAccess&gt;*&lt;/StreamReadAccess&gt;
				&lt;StreamWriteAccess&gt;*&lt;/StreamWriteAccess&gt;
				&lt;StreamAudioSampleAccess&gt;&lt;/StreamAudioSampleAccess&gt;
				&lt;StreamVideoSampleAccess&gt;&lt;/StreamVideoSampleAccess&gt;
				&lt;SharedObjectReadAccess&gt;*&lt;/SharedObjectReadAccess&gt;
				&lt;SharedObjectWriteAccess&gt;*&lt;/SharedObjectWriteAccess&gt;
			&lt;/Access&gt;
		&lt;/Client&gt;
		&lt;RTP&gt;
			&lt;!-- RTP/Authentication/Methods defined in Authentication.xml. Default setup includes; none, basic, digest --&gt;
			&lt;Authentication&gt;
				&lt;Method&gt;digest&lt;/Method&gt;
			&lt;/Authentication&gt;
			&lt;!-- RTP/AVSyncMethod. Valid values are: senderreport, systemclock, rtptimecode --&gt;
			&lt;AVSyncMethod&gt;senderreport&lt;/AVSyncMethod&gt;
			&lt;MaxRTCPWaitTime&gt;12000&lt;/MaxRTCPWaitTime&gt;
			&lt;Properties&gt;
				&lt;!-- Properties defined here will override any properties defined in conf/RTP.xml for any depacketizers loaded by this application --&gt;
				&lt;!--
				&lt;Property&gt;
					&lt;Name&gt;&lt;/Name&gt;
					&lt;Value&gt;&lt;/Value&gt;
				&lt;/Property&gt;
				--&gt;
			&lt;/Properties&gt;
		&lt;/RTP&gt;
		&lt;MediaCaster&gt;
			&lt;Properties&gt;
				&lt;!-- Properties defined here will override any properties defined in conf/MediaCasters.xml for any MediaCasters loaded by this applications --&gt;
				&lt;!--
				&lt;Property&gt;
					&lt;Name&gt;&lt;/Name&gt;
					&lt;Value&gt;&lt;/Value&gt;
				&lt;/Property&gt;
				--&gt;
			&lt;/Properties&gt;
		&lt;/MediaCaster&gt;
		&lt;MediaReader&gt;
			&lt;Properties&gt;
				&lt;!-- Properties defined here will override any properties defined in conf/MediaReaders.xml for any MediaReaders loaded by this applications --&gt;
				&lt;!--
				&lt;Property&gt;
					&lt;Name&gt;&lt;/Name&gt;
					&lt;Value&gt;&lt;/Value&gt;
				&lt;/Property&gt;
				--&gt;
			&lt;/Properties&gt;
		&lt;/MediaReader&gt;
		&lt;!-- 
		&lt;Repeater&gt;
			&lt;OriginURL&gt;&lt;/OriginURL&gt;
		&lt;/Repeater&gt; 
		--&gt;
		&lt;Modules&gt;
			&lt;Module&gt;
				&lt;Name&gt;base&lt;/Name&gt;
				&lt;Description&gt;Base&lt;/Description&gt;
				&lt;Class&gt;com.wowza.wms.module.ModuleCore&lt;/Class&gt;
			&lt;/Module&gt;
			&lt;Module&gt;
				&lt;Name&gt;properties&lt;/Name&gt;
				&lt;Description&gt;Properties&lt;/Description&gt;
				&lt;Class&gt;com.wowza.wms.module.ModuleProperties&lt;/Class&gt;
			&lt;/Module&gt;
			&lt;Module&gt;
				&lt;Name&gt;logging&lt;/Name&gt;
				&lt;Description&gt;Client Logging&lt;/Description&gt;
				&lt;Class&gt;com.wowza.wms.module.ModuleClientLogging&lt;/Class&gt;
			&lt;/Module&gt;
			&lt;Module&gt;
				&lt;Name&gt;flvplayback&lt;/Name&gt;
				&lt;Description&gt;FLVPlayback&lt;/Description&gt;
				&lt;Class&gt;com.wowza.wms.module.ModuleFLVPlayback&lt;/Class&gt;
			&lt;/Module&gt; 
		&lt;/Modules&gt;
		&lt;Properties&gt;
			&lt;!-- Properties defined here will be added to the IApplication.getProperties() and IApplicationInstance.getProperties() collections --&gt;
			&lt;!--
			&lt;Property&gt;
				&lt;Name&gt;&lt;/Name&gt;
				&lt;Value&gt;&lt;/Value&gt;
			&lt;/Property&gt;
			--&gt;
		&lt;/Properties&gt;
	&lt;/Application&gt;
&lt;/Root&gt;
</pre></p>


