---
title: 出張Shibuya.JSにいってきました
date: 2007/09/16
tags: javascript
published: true

---

<p>Mozill24のイベントの中の「<a href="http://shibuyajs.org/articles/2007/08/24/Shibuya-js-24">出張 Shibuya.js 24</a>」にいってきました。</p>

<p>Mozilla24はウチの会社がOceanGridで（ほぼ）24時間ライブ中継はしていたのですが、このセッションだけはぜひ生で聞きたかったので、九段下まで出かけて聞いてきました。以下、ざっと感想＋メモです。</p>


<ul>

<li>gyuqueさん
<ul>
<li>Geckoの実装について</li>
<li>コードレベルで詳しい説明があってわかりやすかった</li>
<li>*.c, *.h, *.cpp - 363万行くらい</li>
<li>*.js, *.xul - 39万行くらい</li>
<li>Geckoの実装について</li>
<li>Frame Tree - 視覚情報</li>
<li>Content Tree - DOM Tree</li>
<li>レンダリングは子要素→親要素→全体の微調整、な感じでレンダリングされる</li>
<li>なかなかソース読む機会はなさそうだけども、こういう前提情報を知っておけば便利そう</li>
</ul>
</li>

<li>swdyhさん
<ul>
<li>勝手に「次のページ」が表示されるGM「AutoPagerize」ついて</li>
<li>「SiteInfo」という情報をWikiで管理していて、これを編集することでAutoPagerize対応サイトを増やせることができる</li>
<li>プログラム＋Wiki（集合知）というセットはなかなかいいのかも</li>
<li>この仕掛けはサイボウズラボ奥さんのJapanizeにヒントを得たもの</li>
<li>Wikiを悪意のあるように書き換えられるとダメ。でも自然に浄化されることを期待</li>
<li>この考えでいいと思う。細かなことを考えすぎるといいものも出ないし</li>
</ul>
</li>

<li>amachangさん
<ul>
<li>次世代ブラウザで実装されるJavaScriptの機能ついて</li>
<li>contentEditableがすごかった！リアルタイムで既存のサイトをゴリゴリと書き換えられる</li>
<li>Googleのロゴを消しちゃってYahooのロゴをコピペしたりやりたい放題</li>
<li>これは周りも大ウケ</li>
<li>「オンライン」「オフライン」の切り替えができる（実際に回線の切断を検知する仕掛けではない）</li>
<li>「オフラインキャッシュ」なる概念があるらしい。多分GoogleGearsみたいなものみたいなんだろう</li>
<li>要素の座標取得がしやすくなる。逆に「ある座標に存在する要素を取得」も可能。これはすごい！</li>
</ul>
</li>

<li>D.Makiさん
<ul>
<li>JavaScriptのマルチスレッド化について</li>
<li>なんとなく話は見たことあったけど、JavaのThreadクラスライクな使い方はできるみたい</li>
<li>Thread.sleep(n); みたいなコードも見えた。これは便利すぎる予感。</li>
<li>実体はライブラリをロードするとそれ以降に呼ばれたJavaScriptを細かなブロック単位に分割してトランポリンスタイルに書き換えちゃってるらしい（すごい！）</li>
<li>速度的にはまだまだ速くない。通常のコードの60～300倍程度</li>
<li>でもXHRとの連携とか考えたら必ずしもボトルネックになるとは限らないっぽい</li>
</ul>
</li>


<li>Yu Kobayashiさん
<ul>
<li>ECMA Script4について</li>
<li>やっとこさ仕様をまとめはじめているらしい</li>
<li>ECMA Script3, ActionScript3の上位互換を目指している</li>
<li>classベースになるのでコードの堅牢性は増す。。けどJavaScript得意の自由に書き換えまくりは難しくなりそう</li>
<li>参照実装とかはまだまだ進んでいない</li>
</ul>
</li>

<li>cho45さん
<ul>
<li>PhotoShopのJavaScript Shellの実装</li>
<li>これは凄過ぎて相当笑った</li>
<li>デモで一番ウケたかも</li>
<li>コマンド打ち込みでjpgをロードしてフォント埋め込み、位置調整とか実現してた</li>
<li>PhotoShopはあんまし仕事でいじらないけどもFireworksがこんな感じで操作できたら便利そう！少し調べてみたいなぁ</li>
</ul>
</li>

<li>sendさん
<ul>
<li>jQueryの内部について</li>
<li>jQueryの高速化テクはかなり細かなことをいろいろやっている模様</li>
<li>関数の引数数でちゃんとcall, apply使い分けとか</li>
<li>正規表現をキャッシュとか</li>
</ul>
</li>

<li>へるみさん
<ul>
<li>JavaSciprtのSHA-1ハッシュの高速化について</li>
<li>淡々と話しつつ、どんどん高速化が進む感じが高揚するなぁ</li>
<li>ループを何百万回と回すとき、実はFirefox2よりもIE6の方が速い</li>
<li>FirefoxとIE6のIntegerのメモリの使い方が違うのが理由</li>
</ul>
</li>

<li>kawa.netさん
<ul>
<li>Facsbookアプリの作り方について</li>
<li>日本語の情報があまりに少なすぎるそう</li>
<li>作り始めるなら今のうち？</li>
<li>この方の<a href="http://www.kawa.net/works/js/xml/objtree.html">XMLパーサのライブラリ</a>、かなり便利なので重宝しています。</li>
</ul>
</li>

<li>TAKESAKOさん
<ul>
<li>scriptタグでgifを読み込みながらもJSとして機能させる荒業。凄過ぎて爆笑</li>
<li>この方は低レイヤから高レイヤまで一気に扱うネタが多くて聞いてて楽しい</li>
<li>相変わらずトークが巧み。素晴らしい。</li>
<li>あとUSB接続されたロボット？も操ってた。いまや昔のLiveConnectで確かにできる。</li>
<li>でもLiveConnectはもう捨てられるみたい。。</li>
<li>今となりゃFlashとExternalInterfaceと連携させてFlashからXMLSocketでJavaアプリと連携させることで力技でこんなことも実現できそう</li>
</ul>
</li>

<li>ma.laさん
<ul>
<li>ustreamネタ、、をするつもりだったけど直前全でやめたみたい</li>
<li>以前に作ったライブラリのソースに「はてなスター」のJSをロードしていたことに対して誰もツッコミがなかったことにキレてた</li>
<li>いやぁ、それはなかなか気づかなそうだw</li>
</ul>
</li>

</ul>

<p>と、相変わらずのグダグダし展開もありつつ、皆さん面白い話の連続で相当楽しかったです。ネタの収集場としてこういうのに参加することはホントいいです。</p>

<p>また、<a href="http://www.flickr.com/photos/katsuma/tags/mozilla24/">Flickr</a>に写真をまとめてみたので、雰囲気をつかいみたい方はこちらもどうぞ。</p>
