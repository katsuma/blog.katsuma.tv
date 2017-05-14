---
title: Wii fitのジョギングゲームのようにGoogleストリートビュー上をジョギングしよう
date: 2008/09/07 22:46:20
tags: java
published: true

---

<p>前回の「<a href="http://blog.katsuma.tv/2008/08/balance_wii_board_google_street_view_jsonp_api.html">バランスWiiボードでGoogleストリートビューを操作するJSONP API</a>」のネタのつづき。バランスボードでできるのだったらWiiリモコン（Wiimote）でもできるよね、というわけで、今回はWiimoteの加速度情報をJSONPで取ってきて、同じようにGoogleストリートビューを操作しています。</p>

<p>Wii fitのジョギングゲームのようにポケットにリモコンを入れてサクサク部屋の中で走ります。曲がるときは十字キーで曲がります。で、動いている様子はこんなかんじ。（初めてiMovieで編集作業してみた！）</p>

<p>
<object width="400" height="300">	<param name="allowfullscreen" value="true" />	<param name="allowscriptaccess" value="always" />	<param name="movie" value="http://vimeo.com/moogaloop.swf?clip_id=1683367&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" />	<embed src="http://vimeo.com/moogaloop.swf?clip_id=1683367&amp;server=vimeo.com&amp;show_title=1&amp;show_byline=1&amp;show_portrait=0&amp;color=&amp;fullscreen=1" type="application/x-shockwave-flash" allowfullscreen="true" allowscriptaccess="always" width="400" height="300"></embed></object><br /><a href="http://vimeo.com/1683367?pg=embed&amp;sec=1683367">Try to run on the google street view like a jogging game of wii fit</a> from <a href="http://vimeo.com/katsuma?pg=embed&amp;sec=1683367">katsuma</a> on <a href="http://vimeo.com?pg=embed&amp;sec=1683367">Vimeo</a>.
</p>

<p>動作原理は前回と同じで、</p>

<p><ol>
<li>Wiimoteの加速度変化をJavaのサーバが取得</li>
<li>localhost上のWebサーバ(Jetty)に加速度情報を通達</li>
<li>リモートホストのサーバからJSONPで加速度を取得</li>
<li>Google Map APIを呼び出し</li>
</ol></p>

<p>の流れです。</p>

<p>ただ、それだけだと全く前回と同じなので、緯度経度情報の変化から走行距離と、その経路情報をリアルタイムに表示させてみました。右上の数字が走行距離、左上のGoogle Mapが経路情報になっています。この２つを表示させたら結構それっぽくなったんじゃないかなーと思います。</p>

<p>このあたりの処理はGoogle Map API使いまくりなわけですが、走行距離に関してはなかなか楽に求められないか調べまくった結果、GPointオブジェクトにdistanceFromメソッドなるものがあるみたいで、これを使うことで簡単に求められました。ソースコード的にはこのへん。</p>

<p><pre>
_TJ.prevPoint = _TJ.currentPoint;
_TJ.currentPoint = _TJ.marker.getPoint(); 
_TJ.distanceHistory += _TJ.currentPoint.distanceFrom(_TJ.prevPoint) /1000;
</pre></p>

<p>よくある２点間の距離を求めるWebサービスなんかはこれ使ってんじゃないかな。今回は、ジョギングするごとにマーカーを道の上に打っていき、その２点間の距離を加算しています。（なので、曲がり角にも対応）。また、あわせてマップ上に走った場所に経路情報としてラインを引いているので「ここは走ったけどここは走ってない」なログを残すことも可能です。</p>

<p>これ、うまくやると同じ時間帯で（Googleストリートビュー上の）近所を走っている人がいたらリアルタイムに表示させたりすると、ゲーム性も高まってなかなか面白いものができるんじゃないかなーと思っています。</p>

<p>コードは一式テスト的な意味もこめてGoogle codeでホスティングさせてみました。（流行のGitとやらに挑戦してみたかったけど、よくわかんなかったので断念）</p>

<p><ul><li><a href="http://code.google.com/p/tokyo-jogging/">Tokyo-Jogging</a></li></ul></p>

<p>ビルド方法なんかはGoogle codeのWikiに簡単に書いてますが、Windowsユーザの人はBluetoothスタック（デバイスドライバ）をWIDOMMのものを利用しないと、おそらくうまく動かないと思います。Macユーザの人は、デフォルトのBluetoothスタックでOKです。このあたり、Windowsはちょっと面倒。</p>

<p>あとはlib/*.jarにclasspath通したらビルドできるはず。実行したらWiimoteの裏フタをあけて「SYNC」ボタンを押すと、"Detected your wiimote" なメッセージを表示して、同期がとれるはずです。同期がとれたら<a href="http://www.tokyo-jogging.com/start/">Webページ</a>にアクセス。</p>

<p>上の通り、ノリで<a href="http://www.tokyo-jogging.com/">tokyo-jogging.com</a>なドメインまで取ったので、できたらWebサービスの形でまとめることができたら、と思っています。まずはもうちょっと使いやすい形にまとめることですね。</p>


