---
title: Flash Player上でP2P通信ができるRTMFPについて
date: 2008/12/19
tags: p2p, actionscript
published: true

---

<p><ul><li>(2008.12.19 22:00追記) peer IDをnear IDに修正</li></ul></p>

<p><a href="http://www.flickr.com/photos/katsuma/3117753027/" title="Adobe Labs - Stratus Sample Application by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3273/3117753027_dcef43d0f9.jpg" width="411" height="500" alt="Adobe Labs - Stratus Sample Application" /></a></p>

<p>先日のAdobe MAXでFlashの新しいプロトコルRTMFPを扱うことができるサービス「Stratus」について発表がありました。これは簡単に言うと、<strong>ブラウザで何もインストールすることなくP2Pを実現できる</strong>神がかったプロトコル(=RTMFP)と、RTMFPをサポートするサービス(=Stratus)、という位置づけです。上の写真は実際にStratusを介してRTMFPによる通信で僕の家とオフィス（夜中なので真っ暗ですね）をつないでいるものです。</p>

<p>これらについては、Adobe Labsでの次の文章が非常に分かりやすいです。</p>

<p><ul>
<li><a href="http://www.adobe.com/devnet/flashplayer/articles/rtmfp_stratus_app.html">Stratus service for developing end-to-end applications using RTMFP in Flash Player</a></li></ul></p>

<p>で、この文章があまりに分かりやすいものだったので自分用メモの意味もこめて、ざっと訳してみました。なお、冗長な表現の箇所は省略していたり、上記文章とは順番が前後している箇所もあるのでご注意ください。</p>

<h3>RTMFP(Real-Time Media Flow Protocol )の特徴</h3>
<p>RTMFPはFlash Player10, Adobe AIR1.5で利用可能なプロトコルです。RTMFPは、次の特徴があります。</p>

<ul>
<li>UDPベースによる通信のため低遅延（RTMPはTCPベース）</li>
<li>サーバを介さないP2Pによるピア間での直接通信。</li>
<li>優先度付きデータの利用（映像と音声を両方利用する場合、音声データの通信を優先的に低遅延で通信できる）</li>
</ul>

<p>これらの特徴によって、リアルタイムの協調作業（たとえば映像チャット、ボイスチャットなど）を要するアプリケーションの開発にRTMFPは非常に適していると言えます。</p>

<p>一方で、RTMFPにはRTMPにある次の機能はありません。</p>
<ul>
<li>Streaming media(多分ファイルストリーミング)</li>
<li>SharedObject</li>
<li>Remoting</li>
</ul>
<p>つまり、RTMFPは音声と映像のリアルタイムコミュニケーションを行うことだけに特化したもの、ということにご注意ください。</p>

<h3>RTMFPを利用するためには</h3>
<p>RTMFPによる通信を行うためには、RTMFPをサポートしているサーバに接続する必要があります。たとえば先に挙げた「<a href="http://labs.adobe.com/technologies/stratus/">Adobe Stratus</a>」があります。サーバはFMSも将来的にはサポートされる予定です。</p>

<p>StratusはFlash Player同士をつなぐ仲介役のようなものです。ピア（実際のクライアント、ここではFlash Player）間同士の接続を行うにあたって、その接続の最初にネゴシエーションを行う機能を提供します。また、上記の通りRTMFPの機能から省かれているので、StratusもStreaming media, SharedObject, などはサポートしていません。</p>

<h3>Firewall</h3>
<p>RTMFPはUDPベースなので、ピア間で直接通信を行うことを可能にします(*)。そのため企業内などで設置されてあるFirewallは外向きのUDP通信を許可する設定を行っておく必要があります。</p>

<p>どうしても全通信が許可できない場合は、mms.cfg(**)にTURN proxy(***)を設定することができます。</p>

<p><pre>
RTMFPTURNProxy=ip_address_or_hostname_of_TURN_proxy
</pre></p>


<p>(*)詳細な情報はドキュメント上ではボカされていますが、おそらくSTUN(UDP Hole Punching)を利用した通信を行うのでしょう。その上で、StratusはSTUNサーバの機能を持っていることが予測されます。このあたりのNAT超えの話は次の文章がわかりやすく説明されています。</p>
<ul><li><a href="http://homepage3.nifty.com/toremoro/p2p/firewall.html">P2Pとファイアウォール</a></li></ul>

<p>(**)mms.cfgについての詳細はここでは触れませんが、別途<a href="RTMFPTURNProxy=ip_address_or_hostname_of_TURN_proxy">詳しいドキュメント</a>があります。</p>

<p>(***) UDPで外向きに通信できない場合は途中で転送サーバを用意する、というわけですね。そういや昔TCPでP2P通信を行うときにTURNサーバを書いたのを思い出しました。。</p>

<h3>Stratus service</h3>
<p>Flash Playerは必ずAdobe Stratus Serviceを利用する必要があります。ここでは、「rtmfp://stratus.adobe.com」のようなアドレスを利用して接続を行います。Stratusサービスに接続をするアプリケーションを開発するためにはdeveloper keyが必要になります。developer keyは<a href="https://www.adobe.com/cfusion/entitlement/index.cfm?e=stratus">ここ</a>から取得することができます。（要Adobe ID）</p>

<h3>セキュリティ</h3>
<p>通信にはAES128bit暗号を利用しています。また、鍵交換アルゴリズムにはDiffie-Hellmannを利用しています。</p>
<p>一方で、SSLによる強固な暗号化通信はサポートしていません。その代わりにセキュリティ強化のためにsecurity nonceを利用しています。（ピアの成り済まし防止）</p>

<h3>Stratusへの接続</h3>
<p>次のようなコードでStratusサービスへ接続を行います。これはActionScript3.0によるコードで、CS4やFlex Builder3.0.2などでFlash Player10,またはAIR1.5をターゲットに設定したときにビルド可能です。</p>

<p><pre>
private const StratusAddress:String = "rtmfp://stratus.adobe.com";
private const DeveloperKey:String = "your-developer-key";
private var netConnection:NetConnection;
 
netConnection = new NetConnection();
netConnection.addEventListener(NetStatusEvent.NET_STATUS,
netConnectionHandler);
netConnection.connect(StratusAddress + "/" + DeveloperKey);
</pre></p>

<p>正しいdeveloper keyが入力された場合、NetConnection.Connect.Successイベントが返ってきます。</p>

<p>また、接続完了後は256bitのユニークなpeer ID(NetConnection.nearID)が割り当てられます。他のピアがこのピアに接続するためには、IPアドレスなどではなく、この<del>peer ID</del>near IDを知る必要があります。<del>peer ID</del>near IDを交換する方法についてはRTMFPとはまったく別の話です。たとえばXMPPサービスやシンプルな専用Webサービスを利用するなどして、別途交換する必要があります。</p>

<h3>ピアとの通信</h3>
<p><del>peer ID</del>near IDを交換したら、実際にピアとの通信を行います。この場合、「送信用」「受信用」の２つのNetStreamオブジェクトを用意することになります。</p>

<p>送信側の処理は次のようになります。</p>

<p><pre>
private var sendStream:NetStream;
 
sendStream = new NetStream(netConnection, NetStream.DIRECT_CONNECTIONS);
sendStream.addEventListener(NetStatusEvent.NET_STATUS,
netStreamHandler);
sendStream.publish("media");
sendStream.attachAudio(Microphone.getMicrophone());
sendStream.attachCamera(Camera.getCamera());
</pre></p>

<p>ここで注意すべき点として、実際に受信者が送信者をsubscribeするまでは送信者のデータは送出されることはない、という点です。つまり受信者の存在を無視して一方的にデータを送り続けることはできない、ということですね。</p>

<p>また、受信者側は次のような処理を行います。ここでは送信者の<del>peer ID</del>near IDを指定していることに注目しましょう。</p>

<p><pre>
private var recvStream:NetStream;
 
recvStream = new NetStream(netConnection, id_of_publishing_client);
recvStream.addEventListener(NetStatusEvent.NET_STATUS, netStreamHandler);
recvStream.play("media");
</pre></p>

<h3>ピアからの接続の許可/拒否</h3>
<p>送信者が受信者からの接続の許可、拒否を選択したい場合はonPeerConnectメソッドを実装したオブジェクトをNetStream#clinetに指定してあげると良いです。</p>
<p><pre>
var o:Object = new Object();
o.onPeerConnect = function(subscriberStream:NetStream):Boolean
{
   if (accept) 
   {
      return true; 
   }
   else
   {
      return false; 
   }
}
sendStream.client = o; 
</pre></p>

<p>ちなみに、送信者側ではNetStream.peerStreamsプロパティに、全subscriber(受信者リスト)の情報が配列で保持されています。</p>
<p><pre>
sendStream.send() 
</pre><p>

<p>のメソッドを利用すると全subscriberに対して同一データが送出されますが、特定のsubscriberに対してデータを送出することも可能です。その場合は次のような処理になります。</p>

<p><pre>
sendStream.peerStreams[i].send();
</pre></p>

<h3>接続数</h3>
<p>送信者が接続を行うことができる受信ピア数の最大値は、NetConnection.maxPeerConnections プロパティで設定されてあります。初期値は「8」です。</p>

<p>また、NetConnection.unconnectedPeerStreamsプロパティでは、実際にデータ送信を行うまでには至っていない受信ピアのNetStream配列がセットされてあります。ここからデータ送信が開始されると、NetStreamオブジェクトはNetStream.peerStreams配列に移ります。</p>


<h3>RTMFPサンプル</h3>
<p><a href="http://labs.adobe.com/technologies/stratus/samples/">ビデオ電話アプリケーション</a>が用意されてあります。NAT下のピア同士での接続を行うと、よさそうです。それぞれが自分の名前を入力し、その後に通信を行いたいユーザの名前を入力すると自動的にpeer IDが交換され、互いに通信が開始されます。一番上の写真はそのときの様子です。</p>



<h3>まとめ</h3>
<p>RTMFPの通信のコードはP2Pの通信が行われてるとは全く思われないほど非常に綺麗に隠蔽されてあります。これを見ていて昔Javaで似たようなことをするためのコードを書いていたときは非常に苦労した記憶が蘇りました。いやぁ、あのときはほんと泥のような時代だった。。。</p>

<p>さて、RTMFPはメディアによるストリーミングはサポートしていない、とありましたが、これは早速何とかなりそうです。Windowsでは<a href="http://www.manycam.com/">Many Cam</a>という静止画や動画を仮想カメラデバイスとして扱えるソフトウェアがあります。これでラップすることでP2Pのファイルストリーミングは可能になりそうです。</p>

<p>また、このRTMFPを利用することでインターネットの歴史上、はじめて「（実質）インストールレスでブラウザ上でP2P通信を行うこと」が可能になりました。これはやばいです。相当画期的。実質、と書いたのはFlash Playerのプラグインだけインストールすることになるのですが、もはやFlash Playerがインストールされていないデスクトップ環境を探す方が難しいと思いますので「インストールレス」と言い切っていいと思います。これによって音声、映像ストリーミングと一緒に他のデータを流し込むことができればそのデータをJavaScriptで取り出してブラウザをごにょごにょして、、、と（ハック的にも）夢も広がりまくりですよね！！</p>

<p>そんなわけで駆け足でRTMFPについて書いてみましたが、相当簡単にアプリが構築できそうなので次は実際にコードを自分でも書いてみたいと思います。</p>

<h3>（2008/12/19 13:00追記）</h3>
<p>ブクコメでいくつかあった質問について答えておきます。</p>

<h4>逆にいえばあるWebページを表示したらnyみたいなののノードにされてしまう可能性もあるってことかしら</h4>
<p>ストリーミングデータ以外ものをどれくらい扱えるのかはまだ調べていませんが、ストリームデータだとだと悪意のあるコードを書けば、勝手に送出させられる可能性は無くは無さそうです。ただ、さらにデータを再転送されて第三者にデータが流れる、というのはAPIレベルでは無さそうです。善意あるコードでこういうことをしたいのですが、これについてはまた別途。</p>

<h4>udpholeパンチング？</h4>
<p>たぶん、そうです。でもStratusはTURNの機能もあるのかも？このあたり未検証です。</p>

<h4>Flash Playerすらもインストール不要？</h4>
<p>文中でも書いてますけど、さすがにそれは必要です。でも普通の環境だとインストール済みですよね。</p>
