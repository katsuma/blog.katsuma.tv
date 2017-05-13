---
title: OSS/FSはAJAXアプリケーションに食われていく？
date: 2007/01/06
tags: web20
published: true

---

年末年始は実家に戻っていました。
今回の帰省はここ数年の間では初めて自分のノートPCを持ち帰りませんでした。
実家に去年買ったデスクトップPCがあったのでWebブラウズはフツーにできるのでまーそれで事足りるか、と思ったのが一番の理由ですが、それ以外の大きな理由としてAJAXアプリケーションの台頭です。

仕事以外でPCで行う作業といえばデジカメの写真管理、MSNやGoogleTalkなどIM、mixiやLoocなどの日記に載せるための画像加工（トリミング、リサイズ）なんかが主なわけですが、これ<strong>全部Webで完結できる</strong>んですよね、、、今更ながらこれ気づいたら凄いです。

実家では上記のことをこんな感じでこなしていました。




[ 写真管理 ]
おなじみの<a href="http://www.flickr.com/photos/katsuma/">Flickr</a>を利用しました。
基本的に東京で撮りためた写真はほぼ全てFlickrに上げてるので「これはxxxで撮ったやつで・・・」みたいに親や親戚にいろいろ見せてあげるのは簡単。
あと、タグ検索がこういうときに地味に効いて来ます。秋に青森に行ったときの写真は全部「aomori」タグを付けていたので検索一発。当たり前だろ・・・と思われる機能も地味にこういう時に便利さを実感します。
<a href="http://blog.katsuma.tv/images/07010504.html" onclick="window.open('http://blog.katsuma.tv/images/07010504.html','popup','width=600,height=442,scrollbars=no,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false"><img src="http://blog.katsuma.tv/images/07010504-thumb.jpg" width="400" height="294" alt="" /></a>


[ IM ]
別にクライアントアプリをインストールしちゃってもいいっちゃーいんですが、<a href="http://www.meebo.com">Meebo</a>が相当使えることを実感しました。MSNもWebMessengerを提供していますが、MeeboはMSN, GoogleTalk, Yahooなど各IMを横断して全部一括して単一ページ上で扱えるのが便利すぎます。メッセージ受信でアラートも出るのでフツーにIMとして使えます。
<a href="http://blog.katsuma.tv/images/07010505.html" onclick="window.open('http://blog.katsuma.tv/images/07010505.html','popup','width=1007,height=575,scrollbars=no,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false"><img src="http://blog.katsuma.tv/images/07010505-thumb.jpg" width="400" height="228" alt="" /></a>

[ 画像加工 ]
普段ならトリミングやリサイズなどほんの些細な加工から色調補正までFireworksを使っているわけですが、当然そんなアプリはインストールされていません。で、最近だと画像加工までAJAXアプリでできちゃうわけですね。<a href="http://pixer.us/">Pixer</a>はトリミング、リサイズ、エフェクトなど画像加工に特化したアプリです。UIがかなり直感的なのがいいです。
<a href="http://blog.katsuma.tv/images/07010506.html" onclick="window.open('http://blog.katsuma.tv/images/07010506.html','popup','width=480,height=334,scrollbars=no,resizable=no,toolbar=no,directories=no,location=no,menubar=no,status=no,left=0,top=0'); return false"><img src="http://blog.katsuma.tv/images/07010506-thumb.jpg" width="400" height="278" alt="" /></a>


これまでは既存のソフトウェアはオープンソースソフトウェア（OSS）やフリーソフトウェア（FS）によってどんどん食われていく、という図式が成り立ってきつつあったわけですが、その先をこえて「OSS/FSはAJAXアプリケーションに侵食されつつある」というのを強く感じました。AJAXアプリ自体がOSS/FSであったり、そもそも侵食されることが特にOSS/FSに影響を与えるのか？という議論もあるわけですが、例えばDL数でそのシェアを競っていたアプリは今後はその指標はなくなります。
（PVだったり、または「タスクをこなした数」だったり？）

今年は特に機能限定したAJAXアプリケーションが相当な数でてくると思います。
JavaScriptは最近だと<a href="http://www.openjacob.org/draw2d.html">ベクター画像の描画</a>についてがホットトピックです。VisioのReplaceは確実に起きるでしょうし、こんなものまで作ってくるか・・・！というものもできるでしょうねぇ。全くこの動向は目が離せません。
