---
title: Kitasando.asで発表してきました
date: 2008/12/07
tags: actionscript
published: true

---

<p>秘密裏にこっそりmixiさんで行われたKitasando.asで発表してきました。お題が「Flash - Server 通信の世界」だったので、<a href="http://meeting24.tv">meeting24.tv</a>をネタにしながらWowza Media Serverの導入から監視までの一通りをざっくり話してきました。以下、発表資料です。</p>

<div style="width:425px;text-align:left" id="__ss_824463"><object style="margin:0px" width="425" height="355"><param name="movie" value="http://static.slideshare.net/swf/ssplayer2.swf?doc=20081206wowza-1228581289347870-9&rel=0&stripped_title=kitasandoas20081206wowzamediaserver-presentation" /><param name="allowFullScreen" value="true"/><param name="allowScriptAccess" value="always"/><embed src="http://static.slideshare.net/swf/ssplayer2.swf?doc=20081206wowza-1228581289347870-9&rel=0&stripped_title=kitasandoas20081206wowzamediaserver-presentation" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="355"></embed></object></div>



<p>全体的に割とニッチな話題ではあるものの、mixiさん、Kayacさん、ウチの会社のまわりの人たちで20人弱が集まって、内容もすごく勉強になりました。発表のメモはこんな感じ。</p>



<h3>某サービスについて</h3>
<p><ul>
<li>Kunzoさん</li>
<li>内容はここでは書けません＞＜</li>
<li>（でもすごく面白かった！）</li>
</ul></p>

<h3>"kamaitachi" perl flash media server</h3>
<p><ul>
<li>typesterさん</li>
<li>PerlのFMS実装、kamaitachiについて</li>
<li>CPANでインストールできる</li>
<li>exapmlesの中に動くものはぜんぶはいってる</li>
<li>Kamaitachi::Service::xxxx</li>
<li>サービスをwithしてあげると有効になる</li>
<li>録画もできる！</li>
<br />
<li>Sniffer::RTMP</li>
<li>RTMP専用のスニファ</li>
<li>汎用的なものを利用しててもだめ</li>	
<li>パケットの最初からでしかキャプチャできない</li>
<li>途中からだとうまくいかない</li>
</ul></p>

<p>kamaitachiのことは前回のShibuya.pmを見てなんとなく概要は知っていたのですが、RTMP専用のスニファを作られていたことは知りませんでした。というか、これすごく便利そう。。。</p>

<h3>Red5の絶対ハマらないインストール方法</h3>
<ul>
<li>Kayacの方、名前失念。。。</li>
<li>Red5のantは使うと絶対にうまくいかない</li>
<li>MacにインストールしてそれをSCPでサーバに上げる</li>
<li>これ以外の方法はやめたほうがいい</li>
<li>サーバに上げたあとにant server とか実行しないように！</li>
</ul>
</p>

<p>Red5はリビジョンごとに挙動がかなり変わるので最近使ってなかったのですが、インストールスクリプトまで挙動が変わっていたとは。。それにしてもインストーラ使ってできたバイナリをサーバに上げるって方法は意外に盲点。ant serverの下りはすごく笑ったw</p>

<h3>効率よい柴犬の閲覧方法</h3>
<p><ul>
<li><a href="http://twitter.com/ishida">ishida</a>のネタプレゼン</li>
<li><a href="http://www.google.co.jp/search?q=%E6%9F%B4%E7%8A%AC%E3%80%80Ustream&lr=lang_ja&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:ja-JP-mac:official&client=firefox-a">柴犬ブーム</a>に乗った<a href="http://live.utagoe.com/">Live100</a>の話</li>
</ul></p>
<p>直前までtakesakoメソッドで資料作ってたけど結局ほとんど破棄していたのが笑ったw</p>

<h3>じゃんけんゲームで学ぶFlash と FMS(red5)のネットゲーム開発　#1？</h3>
<p><ul>
<li>越川直人さん</li>
<li>Red5 0.8rc1を使ったゲーム</li>
<li>最新のSharedObject#setDirtyメソッドにはバグがある</li>
<li>強制更新が通知されない</li>
</ul></p>
<p>やっぱRed5はまだまだ不具合多そうだなぁ、という印象。あと微妙な心理戦を演出してたのがちょっといいかんじ。</p>

<h3>まとめ</h3>
<p>今回はストリーミングサーバの通信話が多かったですけど、次回はJS-ASの通信の話とかも聞きたい＋話せたら話したいかもです。ExternalInterfaceって謎の仕様がすごく多いからちゃんと知識を共有したいなぁ、と思う次第です。</p>


