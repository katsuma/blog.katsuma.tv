---
title: Yahoo!ブックマークのブックマーク数を取得するAPI
date: 2008/03/18
tags: web20
published: true

---

<p>SBMで被ブックマーク数を取得するときに、Y!ブックマークだけscriptタグでimg取得による方法しか見つからなかったのですが、どうにかテキストで取得できないかな、と考えてYahooツールバーのHTTPヘッダを見てたらなんとか分かりました。RESTなAPIがどうやら存在していた模様。こんな風に取得できます。</p>

<p><pre>http://num.bookmarks.yahoo.co.jp/yjnostb.php?urls=調べたいURL</pre></p>

<p>たとえばblog.katsuma.tvだと</p>

<p><pre>http://num.bookmarks.yahoo.co.jp/yjnostb.php?urls=http://blog.katsuma.tv/</pre></p>

<p>そうするとXMLでブックマーク数の情報が取得できます。こんな感じ。</p>

<p><pre>
&lt;results&gt;
&lt;SAVE_COUNT u="http%3A%2F%2Fblog.katsuma.tv%2F" ct="1"/&gt;
&lt;/results&gt;
</pre></p>

<p>要するにSAVE_COUNT要素のu属性の値に調べたURLがURLエンコードされたもの、ct属性の値にブックマーク数が入っています。これを適当なパーサで読めばOK。</p>

<p>callbackとかtypeとかつけてJSONPで取得できるかどうか調べたけど、有効じゃなかったみたい。素直なJSONP APIがあるかどうかは分からないけど、JavaScriptだけでもどうにかなるはず。時間があったら簡単取得コードとか書いてみたいと思いますよ。</p>


