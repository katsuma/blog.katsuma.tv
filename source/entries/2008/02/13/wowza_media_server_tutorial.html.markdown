---
title: Wowza Media Serverの使い方（入門編）
date: 2008/02/13
tags: actionscript
published: true

---

<p><a href="http://www.adobe.com/jp/products/flashmediaserver/">Flash Media Server</a>の（ほぼ）完璧なクローンとして、<a href="http://www.wowzamedia.com/">Wowza Media Server</a>というものがあります。元Adobe（しかもFMS担当だった気が）の社員がスピンアウトして立ち上げたもので、Javaで書かれていてMacでも動いたり、614,250円払わなきゃオリジン、エッジサーバの構成ができないFMSと違って$995で全てがそろってしまうナイスなストリーミングサーバです。詳細な違いは<a href="http://blog.itoyanagi.name/entries/d20071109">糸柳さんが詳しい説明を書いてくださっている</a>ので、そちらが大変参考になります。</p>

<p>
ちなみに同じくFlashのストリーミングサーバでオープンソース版で<a href="http://osflash.org/red5">Red5</a>もありますが、<a href="http://blog.katsuma.tv/2008/02/flash_player_901150_red5_063.html">以前のエントリー</a>のとおり、FlashPlayerのバージョンで動作が異なったり、SharedObjectの挙動が怪しいときがあったりと、まだまだ安定さは欠ける模様です。</p>


<h3>Wowza Media Serverのインストール</h3>
<p>このWowza Media Serverですが、インストール方法は非常に簡単です。Windowsならインストーラに従って進めるだけ。Linuxは実行権限を追加して、自己解凍形式ファイルを実行するだけです。僕はcoLinux上のFedora7に入れてみました。</p>

<p><pre>
sudo chmod +x WowzaMediaServerPro-1.3.3.rpm.bin
sudo ./WowzaMediaServerPro-1.3.3.rpm.bin
</pre></p>

<p>/usr/local/WowzaMediaServerPro-1.3.3にインストールされてあるので、binに移動してライセンスキーを入力します。ライセンスキーは試用版の場合は利用許諾書に同意してメールアドレスを登録することで、取得することができます。</p>

<p><pre>
cd /usr/local/WowzaMediaServerPro/bin
./startup.sh
(ここでライセンスキーを入力)
</pre></p>


<h3>起動スクリプトの設定</h3>
<p>その後、chkconfigでサービスに登録しておくと便利です。</p>
<p><pre>
sudo /sbin/chkconfig --level 345 WowzaMediaServerPro on
</pre></p>

<p>こうしておくと、httpdやmysqldと同じようにinit.dスクリプトに追加されます。</p>

<p><pre>
sudo /etc/init.d/WowzaMediaServerPro (start|stop|restart)
</pre></p>

<h3>アプリケーションの作り方</h3>
<p>ActionScriptでストリーミングサーバに接続するためには、Wowza Media Server側でアプリケーションの設定を行います。アプリケーションをここで「tv」とすると、ディレクトリの構成は次のようになります。</p>

<p><pre>
WowzaMediaServerPro/
 -applications/tv
 -conf/tv/Application.xml
</pre></p>

<p>application/tvのtvディレクトリは空でOKです。ディレクトリを作成するだけでアプリケーションとして認識されます。また、conf/tv/のApplication.xmlは、conf/Applicatioin.xmlをコピーしたものです。一点注意する点として、アプリケーションの種類によってStreamのタイプを編集する必要がある点です。たとえば、ライブ系アプリケーションだと次のように編集します。</p>

<p><pre>
&lt;Streams&gt;
  &lt;StreamType&gt;default&lt;/StreamType&gt;
  &lt;StorageDir&gt;${com.wowza.wms.AppHome}/content&lt;/StorageDir&gt;
&lt;/Streams&gt;
</pre></p>

<p>を</p>

<p><pre>
&lt;Streams&gt;
  &lt;StreamType&gt;live-lowlatency&lt;/StreamType&gt;
  &lt;StorageDir&gt;${com.wowza.wms.AppHome}/content&lt;/StorageDir&gt;
&lt;/Streams&gt;
</pre></p>

<p>と編集します。StreamTypeが適したものでないと、swfがまともに動かないので要注意です。基本的にライブ系アプリだと<strong>「live-lowlatency」</strong>, オンデマンドストリーミングの場合は<strong>「file, default」</strong>と、しておけば大丈夫だと思います。<a href="http://www.wowzamedia.com/quickstart.html">詳しい仕様はこちら</a>で確認できます。また、ここで設定したアプリケーションtvは次のURLでアクセスすることができるようになります。</p>

<p><pre>rtmp://server-address/tv</pre></p>

<h3>ActionScript3でテストコード</h3>

<p>折角なのでActionScript3でテストコードを書いてみます。ざっと書くとこんな感じになります。</p>

<p><pre>
package{

	import flash.display.Sprite;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.events.NetStatusEvent;

	public class Player extends Sprite {
		
		private var nc:NetConnection;

		public function Player(){
			this.nc = new NetConnection();
			this.nc.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatusListener);
			this.nc.objectEncoding = ObjectEncoding.AMF0;
			this.nc.connect('rtmp://localhost/tv');
		}
			
		private function onNetStatusListener(evt:NetStatusEvent):void{
			var code:String = evt.info.code;
			if(code == "NetConnection.Connect.Success"){
				log("Success to connect to RTMP Server");
			
			} else if( code == 'NetConnection.Connect.Closed'){
				log("Close Connection");
				
			} else {
				log("Failed to connect to RTMP Server");
			}
		}	
	}
}
</pre><p>

<p>これを「Player.as」で保存して「mxmlc Player.as」でコンパイルすると接続テスト用swfが出来上がります。また、これを作るにはlog関数をあらかじめセットアップしておく必要があります。log関数については<a href="http://blog.katsuma.tv/2008/01/as3_log_function.html">こちら</a>を参照ください。</p>

<p>一点、注意しなければいけない点として<strong>NetConnectionのエンコード方式をAMF0にしなければいけない点</strong>です。ActionScript3になってからAMF3形式が利用可能になっているはずなのですが、Wowza Media Serverと接続を行うときは、ここのエンコード方式を明示的に指定しておかないと、接続に失敗してしまいます。</p>
