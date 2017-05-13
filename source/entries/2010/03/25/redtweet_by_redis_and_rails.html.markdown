---
title: redisとRailsでTwitterクローン「RedTweet」を作りました
date: 2010/03/25
tags: ruby, kvs
published: true

---

<p>前回「<a href="http://blog.katsuma.tv/2010/03/start_redis.html">Mac OSXにredisをインストール</a>」で、redisを動かす環境まではできたので、せっかくなんでテスト的に何かサービスを作ってみよう、ということでTwitterクローンのRedTweetを作ってみました。</p>

<p><ul><li><a href="http://github.com/katsuma/RedTweet">RedTweet</a></li></ul></p>

<p>redisを使ったTwitterクローンは、PHP版の<a href="http://retwis.antirez.com/">Retwis</a>と、それをSinatraで書き直した<a href="http://retwisrb.danlucraft.com/login">Retwis-RB</a>があるのですが、サンプルコードはいくらっても世の中に少しは役立つだろうと思ってRails版で実装してみました。オンラインで動作できる環境はないので、git cloneしてscript/serverで手元の起動で確認ください、、と投げやり気味ですみません。とりあえず次の項目は一通り実装しています。</p>

<p><ol>
<li>ユーザID発行</li>
<li>Login / Logout</li>
<li>Follow / Remove</li>
<li>自分のTimeline, Public Timeline, 各ユーザのTimelineの閲覧</li>
</ol></p>

<p>ちなみにRedTweetって名前はRedisとTweetを混ぜて直感でつけた名前で、git pushしたあとで同じ名前のサイトがあることが発覚したくらい直感でつけた名前です。</p>


<h3>目的</h3>
<p>さて、今回はまじめにTwitterクローンを作ることが目的ではなくて、実際は、次の項目を目的として実装してみました。</p>

<p><ol>
<li><a href="http://code.google.com/p/redis/wiki/TwitterAlikeExample">Retwisのデザイン</a>を読んで、それに従って一通り実装してみる</li>
<li>redisのAPIの仕様を学ぶ</li>
<li>RDBを一切使わない、NoSQLでWebサービスを作るためのノウハウを身につける</li>
</ol></p>

<p>結局全て似通った話になるのですが、上記のデザイン仕様書はTwitter的なサービスを作り上げることで、KVSをどのように利用すればいいのか、がかなり分かりやすく説明されてあるので、いい勉強になりました。また、ユーザ情報はString, 各TLはList, Following/FollowerをSetで管理することで、redisの主要なAPIを網羅できたことも、redisの学習に役立ちました。
</p>

<p>と、同時に課題もすでに見えていて、</p>

<p><ol>
<li>スケーリングがどこまでできるかはまだ手元で理解できていない</li>
<li>やっぱりActiveRecord的にラップしたライブラリは必須</li>
<li>Followした瞬間に、そのユーザの過去のTweetを自分のTLに追加できていない</li>
</ol></p>

<p>なんかが今の段階で挙げられます。1.はテストデータを作ることで解決するはず。2.はやっぱりmustだなぁ、と思えるところまでははっきりした理解で、ユーザ名をIDから引くときなど毎回決まったprefixがついたkeyから探索するのは冗長すぎてやってられません。<a href="http://ohm.keyvalue.org/">Ohm</a>というHashとObjectのマッピングライブラリもあるので、このあたりも１度使ってみたほうが良さそうだな、というところ。3.はFollowした瞬間に一定数TweetをListにLPUSHして、そのlistの中で<a href="http://code.google.com/p/redis/wiki/SortCommand">SORT</a>すればいいのかな？？正直、SORTまだよくわかってません。</p>

<h3>まとめ</h3>
<p>というわけで、課題は多いものの、redisとRailsで最低限の動作をするものは実装できました。NoSQLでもサービスを作り上げることは理解できたので、Ohmなど、他のライブラリも使ったりすることで、 redisの利点をもっと伸ばして理解を深めたいな、というところですね。</p>


