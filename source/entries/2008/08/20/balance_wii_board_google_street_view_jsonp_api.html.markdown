---
title: バランスWiiボードでGoogleストリートビューを操作するJSONP API
date: 2008/08/20 21:43:37
tags: java
published: true

---

<p>先週高校の友達が家に泊まりにきたとき、バランスWiiボードを見て「これでGoogleマップ操作できたら面白そうじゃない？」とぽろっと言ったのをきっかけに「あれ、それできそうだぞ」と思ったので勢いで作ってみました。</p>

<p>動作としては直感的なものになっていて、足踏みするとどんどん進んでいって、左右に重心傾けると向きが変わって前後に重心を傾けるとズームが変わります。百聞は一見にしかずで、映像見てもらったほうが分かりやすいかと思います。</p>

<p>
<object width="400" height="300">	<param name="allowfullscreen" value="true" />	<param name="allowscriptaccess" value="always" />	<param name="movie" value="http://www.vimeo.com/moogaloop.swf?clip_id=1565343&amp;server=www.vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" />	<embed src="http://www.vimeo.com/moogaloop.swf?clip_id=1565343&amp;server=www.vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="300"></embed></object><br /><a href="http://www.vimeo.com/1565343?pg=embed&amp;sec=1565343">Google Street View by Wii Balance Board</a> from <a href="http://www.vimeo.com/katsuma?pg=embed&amp;sec=1565343">katsuma</a> on <a href="http://vimeo.com?pg=embed&amp;sec=1565343">Vimeo</a>.
</p>

<h3>構成</h3>
<p>全体の構成としては次のもので成り立っています。</p>
<p><ol>
<li>バランスWiiボード</li>
<li>Bluetoothレシーバ(iMac)</li>
<li>信号解析モジュール(Java)</li>
<li>ローカルWebサーバ(Jetty)</li>
<li>Javascript(JSONP)</li>
<li>Webブラウザ(出力)</li>
</ol></p>

<h3>バランスWiiボードとBluetoothレシーバ</h3>
<p>言わずもがな例のWii Fitのあれ。まずBluetoothデバイスとしてMacに繋ぐ許可を与える必要があるのですが（ペアリング）、ペアリングするためには<a href="http://www.wiili.org/forum/osx-wiimote-enabler-t229.html">RVL Enabler</a>を使えば何も考えずに簡単に検知できます。（via <a href="http://labs.gmo.jp/blog/ku/2008/03/wiifirefoxjavascriptwiiremocom_firefox3.html">WiiリモコンとFirefoxをjavascriptでつなげるWiiRemoCom Firefox3対応版</a>）RVL Enablerを起動して、バランスWiiボードを近づけて「Search」ボタンをクリックすれば認識してくれるはず。</p>

<p><a href="http://www.flickr.com/photos/katsuma/2781361826/" title="Wii balance board by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3159/2781361826_0b3f989bf5_m.jpg" width="240" height="180" alt="Wii balance board" /></a></p>

<p>MacはいいけどWindowsはどうなんだ？という話になるのですが、おそらくUSB接続なんかのレシーバを用意すれば認識するはず？です。WindowsでWiiリモコンを扱う話もいろいろ出ているので特に問題はなくペアリングまでできるかと思います。</p>

<h3>信号解析モジュール(Java)</h3>
<p>ここが今回の一番のメイン。</p>

<p>最初は<a href="http://blog.yappo.jp/">yappo</a>さんが作られた<a href="http://blog.yappo.jp/yappo/archives/000561.html">Plusen</a>をもとにどうにかしようと思っていたのですが、Cocoa-Perlブリッジの<a href="http://camelbones.sourceforge.net/">CamelBones</a>がLeopardでうまく動かなかったりビルドするものがやたら多かったり、そもそも僕はPerlが苦手だったりと山があまりにも多すぎたので断念。</p>

<p>で、他の方法を探していたらJavaでWiiリモコン、バランスWIiボードの信号を解析してラップしてくれるナイスなモジュールの<a href="http://www.wiili.org/index.php/WiiremoteJ">WIiRemoteJ</a>なんてものを見つけたので、これを利用しました。実際はさらに下のレイヤーであるJNIでBluetoothの信号を受信するためのJSR-082 (Java Bluetooth API) 実装ライブラリも必要になります。今回はWindows XP, Windows Vista, MacOS X,   Linuxと幅広いプラットホームに対応している<a href="http://bluecove.sourceforge.net/">BlueCove</a>を利用しました。</p>

<p>これらの使い方も簡単で、Eclipseのビルドパスに入れておくだけでOKで、複雑なことは何もありません。WiiRemoteJのパッケージを解凍するとサンプルプログラムのWRLImpl.javaがあるので、これをビルド、実行するとWiiリモコンの加速度センサのx, y, z軸方向の変化の様子を見ることができます。</p>

<p><a href="http://www.flickr.com/photos/katsuma/2780565189/" title="WiiremoteJ sample program by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2046/2780565189_d7a39dd08e_m.jpg" width="240" height="177" alt="WiiremoteJ sample program" /></a></p>

<p>バランスWiiボードを操作するときもサンプルのWiiリモコンを扱うのと基本的に大きく変わりません。BalanceBoardListenerをimplementsするclassを用意しておいて、</p>

<p><pre>
BalanceBoar balanceBoard = WiiRemoteJ.findBalanceBoard();
balanceBoard.addBalanceBoardListener(this);//thisは自身のクラス
</pre></p>

<p>などとしておきます。addBalanceBoardListenerすると、BalanceBoardからのいろんなイベントが起こるので、そのリスナbuttonInputReceived, combinedInputReceived, disconnected, massInputReceivedを実装します。今回は重心の動きを知りたいので、実際はmassInputReceived(BBMassEvent evt)だけまじめに実装すればOK。BBMassEventは、バランスWiiボードを４分割（左上、右上、左下、右下）したときにそれぞれの領域でどれくらいの力が加わったか、のイベントとなります。こんな感じで取得できます。</p>

<p><pre>
double topLeft = evt.getMass(MassConstants.TOP, MassConstants.LEFT);
double topRight = evt.getMass(MassConstants.TOP,  MassConstants.RIGHT);
double bottomLeft = evt.getMass(MassConstants.BOTTOM, MassConstants.LEFT);
double bottomRight = evt.getMass(MassConstants.BOTTOM,  MassConstants.RIGHT);
</pre></p>

<p>ただ、実際は上下左右の４方向で取得できたほうが都合がいいので、これを補正します。試行錯誤の結果、単純にこんな感じでよさそう。</p>

<p><pre>
double top = evt.getMass(MassConstants.TOP, (int)Math.floor((MassConstants.LEFT + MassConstants.RIGHT)/2));
double right = evt.getMass((int)Math.floor(MassConstants.TOP + MassConstants.BOTTOM),  MassConstants.RIGHT);
double BOTTOM = evt.getMass(MassConstants.BOTTOM, (int)Math.floor((MassConstants.LEFT + MassConstants.RIGHT)/2));
double left = evt.getMass((int)Math.floor(MassConstants.TOP + MassConstants.BOTTOM),  MassConstants.LEFT);
</pre></p>

<p>要するに取得する領域を幅の平均でならしておきます。値もそれっぽいものが返ってきたので（多分）問題ないはず。</p>

<h3>力の分布からバランスボードの踏み方を推定</h3>
<p>上で書いた方法で４つの領域にどれくらいの力が加わったかが取得できるので、この値から実際に「どんな格好でバランスボードを踏んでいたか？」を推定します。</p>

<p>この推定方法が実際はかなり苦労しました。。多分一番時間がかかったところ。何せなかなか思い通りの推定ができないし、ノイズがものすごい量で入ってくるし、そのノイズを無視する閾値をどれくらいにするかを測定するために毎晩バランスボードを踏んだり降りたり、、な毎日でした。で、いろんなパターンを考えて試行錯誤した結果、辿り着いた推定方法はこんなアルゴリズム。実はかなり単純。</p>

<p><ol>
<li>4方向の力(f<sub>1</sub>, f<sub>2</sub>, f<sub>3</sub>, f<sub>4</sub>)の割合r<sub>n</sub>を求める(r<sub>n</sub>=f<sub>n</sub>/Σf<sub>i</sub>)</li>
<li>r<sub>n</sub>の最小値m<sub>n</sub>=min(r<sub>n</sub>)を求める</li>
<li>m<sub>n</sub>以外のr<sub>i</sub>が、全て閾値thを超えていた場合、r<sub>n</sub>の方向の真逆を踏んでいたこととする（m<sub>n</sub>が左の場合、上、右、下方向にかかる力が閾値を超えていた場合は右側を踏んでいたことと見なす）</li>
<li>閾値を超えていなかった場合は、真ん中を踏んでいたことと見なす</li>
</ol></p>

<p>これだけ。超シンプル。でもこれくらいでちょうどいい感じの結果でした。あと結果の履歴をとって、そこから判断とかも行っていたのですが、そこまでやらなくても方向検知のレベルであれば、実際は問題のない結果なのでこれで良しとしました。</p>

<h3>Webサーバ</h3>
<p>で、方向検知までできるとWeb屋としてはこの結果をなんとかHTML+Javascriptにフィードバックしたい、となります。そこでローカルでWebサーバ(Jetty6.1)を立てて、リモートのWebサイトからJSONPでアクセスできるようなAPIを作ることにしました。</p>

<p>「リモートのサイトからlocalhostにアクセスできるの？」という話が出るかもしれませんが、ファイルシステムにアクセスするのではなく、あくまで外部サイトのホストがたまたまlocalhostだった、ということなので問題なくアクセス可能です。このあたり、P2Pストリーミングソフトなんかだと、クライアントソフトがデータをかき集めてきて、Webサーバ上のプレイヤがlocalhostから再生する、なんて流れになるのと同じように考えてみればいいと思います。</p>

<h3>Javascript(JSONP)</h3>
<p>今回WebサーバでJettyを選んだのはCometが簡単に実装できたことが理由に上げられます。JSONP+Cometな組み合わせはLingrが既に実績ありましたし、Cometじゃないとポーリングを繰り返ししすぎるのもなんだか気持ち悪いです。実際はバランスWiiボードからの情報は全部JSONPで拾うには速度が足りないのですが、よほど細かなゲームを実装とかしない限り、特に今回のストリートビューのデモのようなものであれば、気にならない取りこぼしでした。</p>

<h3>Webブラウザ(出力)</h3>
<p>出力についてはJSONPで取得した情報をもとに、ステップなのか、どちらかの方向に傾いているのか？をJavaScriptで判断し、Google Map APIの関数をコールしています。この判断も単純に、３回連続した値がきたかどうかで判断しています。たとえばCENTERに重心がかかっていたものが３回連続できたら、真ん中を踏み続けていたということからステップしていたんだな、のような感じです。</p>

<h3>ハードウェアとJavaScript連携はおもしろい！</h3>
<p>今回のデモはとりあえず動くものを作りたかったので、凝った作りに全くなっていないし、超汚いコードになっていますが、localhostのJavaScriptで特別なオブジェクトを生成することで、このモジュールをインストールしているかどうか、の判定もリモートのサイトで行うことも可能です。</p>

<p>また、Wiiリモコンやヌンチャクの情報もWiiRemoteJは扱うことができるので、JSONP APIを同じように用意してあげて、ExternalInterfaceを使えばFlashとも連携できて、あれ、これ普通にWii本体なしでゲーム作れるんじゃね？？と、夢も膨らみまくりです。うおー。</p>

<h3>ソースコード一式</h3>
<p>超汚いまま整形なしですが、勢いで置いておきます。でもあとで改訂するかも。（これcodereposとか利用させてもらったほうがいいのかな）</p>

<p><a href="http://lab.katsuma.tv/walker/MapWalker.zip">MapWalker.zip</a></p>

<p>Javaのソースのtv.katsuma.walker.MapWalkerをビルド＆実行して、バランスWIiボードのSYNCボタンを押して認識させた後に<a href="http://lab.katsuma.tv/walker/">ここ</a>をアクセス。うまく起動できれば実際の渋谷を「本当に歩く」ことができます！（起動できていない場合、アクセスしてもJavaScriptエラーでとまっちゃいます。ここエラー処理いまサボってます。あとSYNCボタンおして例外で落ちちゃうことが割とあるのですが何回か繰り返すと繫がると思います＞＜）</p>


