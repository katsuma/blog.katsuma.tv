---
title: Wowza Media Serverの使い方（実装編）
date: 2008/02/19
tags: actionscript
published: true

---

<p>またまた<a href="http://www.wowzamedia.com/">Wowza Media Server</a>について。<a href="http://blog.katsuma.tv/2008/02/wowza_media_server_tutorial.html">前回</a>のつづき。今回はサーバサイドで独自のロジックを組み立てるときのお約束だったり、ASとの連携方法などについての話です。</p>

<h3>Wowza IDE</h3>
<p>サーバサイドの開発を行いやすくするために、EclipseベースのIDEで、<a href="http://www.wowzamedia.com/labs.html#wowzaide">Wowza IDE</a> (Bata2)なるものがあります。手っ取り早くサーバサイドの開発を行うにはこれを使うと便利。</p>

<p>
<ul><li>Wowza  Media Serverとの連携</li>
<li>メソッドのスケルトンの自動生成</li>
<li>自前のクラスファイルをAntタスクによって自動的にjarに固めてlibフォルダに配置</li>
</ul></p>

<p>まで一気に行ってくれます。</p>

<p>ただし、このIDEには罠もあって、今のところWindowsとMacのバージョンしかありません。Macでの運用+開発、という場合は問題ないでしょうが、Linuxでのサーバ運用を考えている場合はWindowsでビルドしたjarファイルをLinux側に再配置する必要があり、実際にところは「めちゃめちゃ便利！Wowza IDE++!!」なんてことまでは言い切れません。(そもそもIDEのインストール時にサーバの場所を聞かれるのですが、Windows側からLinux側のサーバを指定することができなさげだったので、そもそも連携は難しそう、というか考えられていない模様)　なので、実際はWindowsでローカルに開発用としてサーバをインストールし、IDEと連携をさせることになると思います。</p>

<p>また、もう一つの罠として、Eclipseのプラグインの形としては提供されていない、という点です。Subversionなど慣れ親しんだプラグインをいろいろ導入している人にとっては、ここもやや微妙に思う点かもしれません。(実際、僕もここはイケてない点だと思います)</p>

<p>いやいや、俺はやっぱり慣れたEclipseでコード書きたいよ、なんて話も出そうですが、それも頑張ればできそうです。基本的にコンパイルが通る状態にだけ持って行ければいい、という話であれば、Wowza Media Serverのlibディレクトリ以下のjarファイルをビルドパスに通してあげればいいはず。(未確認ですが)あとは、指定のフォルダにビルドしてできたjarをコピーすればOKです。おそらく。</p>


<h3>プロジェクトの設定</h3>
<p>では、実際にプロジェクトを作成してみます。File > New > Wowza Media Server Pro Project を選択するとProject, ソースフォルダ、クラスファイル出力フォルダの場所を入力します。</p>

<p>
<a href="http://www.flickr.com/photos/katsuma/2273967239/" title="Wowza IDE by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2039/2273967239_1f846f7502_m.jpg" width="240" height="205" alt="Wowza IDE" /></a>
</p>

<p>
package,作成するクラス名を入力します。またASから呼び出されるカスタムメソッド(NetConnection#callで呼び出されるメソッド)を定義したい場合は「Custom Method」の箇所にメソッド名を入力します。一番下のMethod Eventsには、NetConnectionの接続に関するイベントが起こったときの処理を扱いたいものにチェックを入れます。基本的にはデフォルトのままでOKです。
</p>

<p><a href="http://www.flickr.com/photos/katsuma/2273967313/" title="Wowza IDE by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2028/2273967313_0efe9e4e94_m.jpg" width="240" height="206" alt="Wowza IDE" /></a></p>

<h3>処理はすべてイベントベース</h3>
<p>Wowza IDE(Wowza Media Server)での開発はすべてイベントドリブンなもので、指定されたメソッドをimplementすることでサーバサイドの実装をすることになります。このあたりは<a href="http://www.osflash.org/red5">Red5</a>なんかも同じですね。基本的には</p>

<p><ul>
<li>onAppStart : アプリケーションの初期化</li>
<li>onConnect : swfからの接続時に伴う処理</li>
<li>onConnect : swfからの切断時に伴う処理</li>
</ul></p>

<p>の３種類を押さえておけばいいと思います。 スケルトンコードが自動的にできあがるのでそれにあわせて必要なコードを追加していくことになります。コードを保存すると、自動的にjarファイルまで出来上がっているので、Wowza Media Serverを再起動させます。</p>

<h3>swfからのパラメータの受け取り方</h3>
<p>swfからパラメータを受け取るとき、たとえばNetConnection#connectの第二引数や、カスタムメソッドの第三引数でswfは自由なオブジェクトをサーバに渡すことができます。たとえばNetConnection#connectの例で言うと、次のようなAS3のコードがあるとします。</p>

<p><pre>
var nc:NetConnection = new NetConnection();
nc.addEventListener(NetStatusEvent.NET_STATUS, this.netStatusListener);
nc.objectEncoding = ObjectEncoding.AMF0;
nc.connect("rtmp://localhost/livetest/", "my_name");
</pre></p>

<p>Java側でonConnectメソッドにおいてmy_nameを取得するためには次のようなコードになります。</p>

<p><pre>
    public void onConnect(IClient client, RequestFunction function, AMFDataList params) {
        String userID =  getParamString(params, PARAM1);
        getLogger().info("onConnect from : " + userID);
    }
</pre></p>

<p>getParam*メソッドがModuleBaseクラスのメソッドとして定義されてあるので、それを利用します。今回はStringがくることが予想されてあったのでgetParamStringを利用しました。AS3側からObject、たとえば {user:"katsuma"} な無名Objectが渡ってくると予想される場合は次のようなコードになります。</p>

<p><pre>
    public void onConnect(IClient client, RequestFunction function, AMFDataList params){
        AMFDataObj paramObj = (AMFDataObj)getParam(params, PARAM1);
        String userID = paramObj.getString("user"));
    }
</pre></p>

<p>まずAMFDataObjオブジェクトとして取得し、その後にAMFDataObj#getString(String key)で値を取り出すことになります。</p>

<p>少し扱いがは面倒くさいものの、AS3のオブジェクトを生で扱えるのがメリットでもあります。あと引数に１つだけ値を渡したからgetParamの引数として「PARAM1」を渡しているわけですが、これはちょっとナンセンスかもしれませんね。</p>

<h3>JSONでデータを渡してあげたほうが便利な気がする</h3>
<p>AS3から送られた情報をJavaとだけやりとりを行うのならいいのですが、この情報をRDBにストアしたり、JavaScriptと連携を考えた場合、AS側でJSONの形式にencodeさせておいて、文字列としてJava側に送った方がいろんな場面で扱いやすいことも多いと思います。</p>

<p>AS3でJSONを扱うためには<a href="http://code.google.com/p/as3corelib/">corelib</a>パッケージを利用するのが良いと思います。解凍してできたcorelib.swcファイルを$FLEX_SDK_HOME/frameworks/libs以下に保存すれば、JSONライブラリが扱えます。扱い方はJSON.encode(obj:Object) または、JSON.decode(str:String)です。上の例で言うと次のようにサーバ側に渡しておきます。</p>

<p>
<pre>
var jsonData:String = JSON.encode( {user : "my_name"} );
nc.connect("rtmp://localhost/livetest/", jsonData);
</pre></p>

<p>するとサーバ側で次のように取得できますね。</p>

<p><pre>
    public void onConnect(IClient client, RequestFunction function, AMFDataList params) {
        String jsonData =  getParamString(params, PARAM1);
        JSONObject obj = JSONValue.parse(jsonData);
        getLogger().info("onConnect from : " + obj.get('user'));
    }
</pre></p>

<p>ここでは一番簡単な<a href="http://www.json.org/java/simple.txt">json.simple</a>のパッケージの利用を想定しています。（<a href="http://blog.katsuma.tv/2007/02/org_json_simple.html">Javaで手軽にJSON - org.json.simple </a>）JSONで値を渡しておけば、何かと応用は効いてくるので直接オブジェクトを渡すよりも、もしかすると便利かもしれませんね。</p>

<h3>まとめ</h3>
<p>長くなったので、とりあえずこのあたりで一度終わっておきます。あとSharedObjectの扱いやASの関数呼び出しなんかの話もあるのですが、また別の機会に＞＜</p>
