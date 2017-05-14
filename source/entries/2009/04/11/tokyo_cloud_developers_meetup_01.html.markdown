---
title: Tokyo Cloud Developers Meetupに行ってきました
date: 2009/04/11 08:10:09
tags: diary
published: true

---

<p>
<a href="http://www.flickr.com/photos/katsuma/3433147447/" title="@ Tokyo Cloud Developers Meetup by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3639/3433147447_b86e045338_m.jpg" width="240" height="180" alt="@ Tokyo Cloud Developers Meetup" /></a>
</p>

<p>AmazonさんでS3, EC2などのクラウド系のカンファレンス <a href="http://atnd.org/events/481">Tokyo Cloud Developers Meetup </a>が開かれるとのことだったので参加してきました。クロスタワーにあるAmazonオフィスはすごくかっこよかったです！以下、簡単なメモ。</p>

<h3>Jeff Barrさん</h3>
<p>
<ul>
<li>Amazon Web Service : Building Blocks
 <ul>
 <li>Infrastructure</li>
 <li>People</li>
 <li>Payment</li>
 <li>Fulfilment</li>
 <li>Alexa</li>
 </ul>
</li>

<li>Fully programmable
 <ul>
 <li>XML</li>
 <li>SOAP</li>
 <li>REST/HTTP</li>
 </ul>
</li>


<li>Using
 <ul>
 <li>HTTPS</li>
 <li>Private & Public key</li>
 <li>X.500 certificate</li>
 </ul>
</li>

<li>S3
 <ul>
 <li>540,000 Developers</li>
 <li>52,000,000,000 S3 objects</li>
 <li>1,000,000,000,000 S3 requests per year from 90 countries</li>
 </ul>
</li>


<li>EC2
 <ul>
 <li>Region
  <ul>
  <li>US : east</li>
  <li>Euro : west</li>
  <li>Future : ?</li>
  </ul>
 </li>

 <li>Security groups
  <ul>
  <li>outside world to EC2</li>
  <li>EC2 instance to EC2 instance</li>
  <li>IP address</li>
  <li>Network port</li>
  </ul>
 </li>
 </ul>
</li>
</ul>
</p>
<p>(もちろん)英語でのプレゼンだったので聞き取るの必死でした。資料なかったら半分も内容わからなかったと思います。。</p>
<p>一番見所とすると、やっぱりS3の利用状況の数値じゃないでしょうか。１兆リクエストとか数字にされると凄いものがありますね。あとプレゼンのときにちらっと映ってましたけど、JeffさんもS3のクライアントとして<a href="https://addons.mozilla.org/ja/firefox/addon/3247">Organizer</a>を利用されてるみたいです。</p>


<h3>LT : <a href="http://blog.livedoor.jp/sparklegate/">山崎さん</a>(<a href="http://axsh.jp/information/">株式会社あくしゅ</a>)</h3>
<p>
<ul>
<li>Dynamic cloyd configuration "Wakame"</li>
<li>複数インスタンスのEC2おける動的なconfigurationを実現</li>
<li>ロードバランシングなんかもうまくやってくれるみたい（詳細よく理解できませんでした）</li>
<li>RubyForgeで4/22にはリリース予定</li>
</ul>
</p>

<h3>LT : <a href="http://d.hatena.ne.jp/rx7/">並河さん(id:rx7さん)</a></h3>
<p>
<ul>
<li>社内SNS SKIPをリリース</li>
<li>SKIPのSAAS化(SKIPAAS)</li>
<li>EC2, SB2, S3を利用</li>
<li>レスポンスが遅い、英語の情報ばかり、障害おきてもよくわからない(クラウドの中)あたりが悩みの種</li>
<li>EC2の日本進出に期待！</li>
</ul>
</p>


<h3>LT : <a href="http://mtl.recruit.co.jp/mt/mt-search.cgi?IncludeBlogs=19&search=%E3%83%95%E3%83%8A%E3%83%9F%E3%82%BF%E3%82%AB%E3%82%AA">フナミさん</a>(<a href="http://mtl.recruit.co.jp/">MTL</a>)</h3>
<p>
<ul>
<li><a href="http://airyakiniku.cosaji.jp/">AIR YAKINIKU</a>について</li>
<li>SKIPのSAAS化(SKIPAAS)</li>
<li>EC2は開発環境、非同期のバッチ処理なんかに利用</li>
<li>エア焼肉リリース時は回線が相当やばいことになった</li>
<li>1swf, 5flvで200MB超えしてた（すごいw）</li>
<li>その後、２時間でEC2に乗せてクラウド化に</li>
</ul>
</p>


<h3>LT : お名前失念。。(<a href="http://www.manabing.jp/">学びing株式会社</a>)</h3>
<p>
<ul>
<li><a href="http://www.kentei.cc/">けんてーごっこ</a>について</li>
<li>ユーザが増えてきたのでだんだんとサーバを増強</li>
<li>その後クラウドも利用してきた</li>
<li>レスポンスはやっぱり遅い</li>
<li>ので、重めのコンテンツは日本に、軽めのコンテンツはクラウドに、と利用目的を分けてる</li>
</ul>
</p>

<h3>LT : 安藤さん(<a href="http://www.exa-corp.co.jp/">株式会社エクサ</a>)</h3>
<p>
<ul>
<li>EC2はSSLを利用すると遅い</li>
<li>SSLを利用しない場合は問題なく使える</li>
<li>利用にあたって上司を説得する場合において</li>
<li>自家発電しないでしょ？</li>
<li>固定資産を持ちたくないでしょ？</li>
<li>データは暗号化しておけばいいでしょ？</li>
<li>あたりが説得材料になるのでは</li>
</ul>
</p>


<h3>まとめ</h3>
<p>思ったよりも日本のクラウド利用場面ってかなり多そうだなぁ、という印象を持ちました。いろんなサービスもパッと見るくらいだとどこにサーバがあるのかはよくわからないので、今回のような利用実績について生の声を聞くとかなり新鮮な印象を持ちました。
一方で、レスポンス速度や日本語情報の少なさなど、まだまだ問題も多いかと思いますので、このように技術者が集まれる場所がある、というのはすごく有意義だな、とも感じました。</p>


