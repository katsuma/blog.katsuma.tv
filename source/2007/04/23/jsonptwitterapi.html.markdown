---
title: JSONPのTwitterAPIを試してみました
date: 2007/04/23
tags: javascript
published: true

---

<p>
<img src="http://blog.katsuma.tv/images/twitter_jsonp.gif" alt="TwitterAPI" />
</p>

<P>
TwitterAPIでJSONがサポートされている、ということで自分の最新ひとことを表示するスクリプトを書いてみました。トップのサイドバーに表示させています。（女の子画像は本家からこっそり拝借）</p>

<p>（2007/04/24 追記）<br />
この後、Flashを使ったガジェットになりました。<a href="http://blog.katsuma.tv/2007/04/twitter_gadget_1.html">詳しくはこちら。</a>
</p>

<p>
コードは次のとおりです。表示のところだけ要prototype.jsですが、結構単純なコードです。実行はloadTwitter()をコール。
</p>

<p>
<pre>
function loadTwitter(){
	var api = "http://twitter.com/statuses/user_timeline/3224511.json?callback=viewTwitter&count=1";
	var s = document.createElement('script');
	var head = document.getElementsByTagName('head').item(0);

	s.setAttribute('type', 'text/javascript');
	s.setAttribute('src', api);
	s.setAttribute('charset', 'UTF-8');
	head.appendChild(s);
}
function viewTwitter(json){	
	var states = json;
	var latest_state = states[0];
	$('twitter').innerHTML = latest_state.text;
}
</pre>
</p>

<p>
var api = ... のところが、JSONリクエストのURLです。callback=がコールバックさせる関数名、count=が配列サイズになります。今回はcallback関数にviewTwitterな名前を利用しています。サイズは最新１件でいいので１に。あと、フォーマットはRSSもあるみたいだけども<a href="http://watcher.moe-nifty.com/memo/2007/04/twitter_api_b68f.html">JSONが一番安定しているらしいですね</a>。メモメモ。
あと、user_timeline/3224511の箇所の数字は僕のIDになるのですが、この取得方法がよくわからなかったので、</p>

<p>
<ol>
<li>Twitterのマイページ(Your Profile)に飛ぶ</li>
<li>HTMLのソースを見るとheadタグの中にRSSのリンクがあるのでチェック</li>
<li>&lt;link rel="alternate" type="application/atom+xml" title="ryo katsuma (Atom)" href="http://twitter.com/statuses/user_timeline/3224511.atom" /&gt; みたなところ</li>
<li>この最後の数字の箇所が自分のID（な、はず）</li>
</ol>
</p>

<p>
と、バカっぽい方法で取得してみました。これもっといい方法があるはず。。。（ドキュメント見落としてる可能性が相当高い）
</p>

<p>
で、肝心のJSONフォーマットはこんな感じで返ってきます（見やすいように改行してます）。
</p>

<p>
<pre>
[
{
"created_at":"Sun Apr 22 14:02:05 +0000 2007",
"text":"MT\u306e\u30c8\u30e9\u30d0\u9001\u4fe1\u304c\u3084\u305f\u3089\u30df\u30b9\u308b\u3002\u3002",
"id":35956112,
"user":{
	"name":"ryo katsuma",
	"profile_image_url":"http:\/\/assets3.twitter.com\/system\/user\/profile_image\/3224511\/normal\/flickr.jpg?1175528350",
	"screen_name":"ryo_katsuma",
	"description":"\u6075\u6bd4\u5bff\u3067\u50cd\u304fWeb\u5c4b",
	"location":"\u8c4a\u5cf6\u533a",
	"url":"http:\/\/katsuma.tv",
	"id":3224511,"protected":false
}
]
</pre>
</p>


<p>
重要なのはtextプロパティ。ここに内容がはいってきます。</p>
<p>
<pre>
$('twitter').innerHTML = latest_state.text;
</pre>
</p>
<p>
な、箇所では、id=twitterなdivのinnerHTMLをその内容で書き換えています。
もし、ユーザ情報も取得してゴニョゴニョしたい方はobj.user.screen_nameや、obj.user.locationなんかを使ってあげればいいでしょう。HTMLの方は単純で
</p>
<p>
<pre>
&lt;script type="text/javascript" src="http://blog.katsuma.tv/js/twitter.js"&gt;&lt;/script&gt;
&lt;div id="twitter"&gt;&lt;/div&gt;
</pre>
</p>

<p>だけです。twitter.jsの中身は上記コード＋loadTwitter()な内容になっているので、jsをロードしたら実行されるようにしています。</p>

<p>で、TwitterAPIは認証が今更BASIC認証というのがオサレじゃないと思うのですが、別の方法も実装をすすめているようです。以下、<a href="http://groups.google.com/group/twitter-development-talk/web/api-documentation">Twitter Development Talk</a>より抜粋。</p>

<blockquote>At the time of writing, the Twitter engineers are working an additional authentication scheme similar to Google’s AuthSub or Flickr’s API Authentication.
</blockquote>

<p>
・・・と、いうことなので、そちらを待ちましょう。特にFlickr形式な認証（トークン認証）は非常にスマートだと思うので、そちらはかなり気になりますねぇ。</p>
