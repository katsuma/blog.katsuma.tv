---
title: サーバサイドでOS・ブラウザ判定
date: 2007/12/13 02:03:05
tags: php
published: true

---

<p>「そんなのできたらOS毎に分けたHTMLを出力するとき、無駄なdocument.write()だらけにならずに便利なのに、、、」と思ったのですが、よくよく考えたらUserAgent見たらできそう。と、いうわけでPHPで書いてみました。</p>

<p>
<pre>
&lt;?php
$ua = $_SERVER['HTTP_USER_AGENT'];
if(eregi('Windows', $ua)){
	echo('Windows!');
} else {
	echo('Not Windows!');
}
?&gt;
</pre>
</p>

<p>超簡単。UA送ってくれてたらブラウザ判定もいけます。</p>

<p>もちろん「UA偽装されたら、、」とかな話もあるけど、JSに頼らず"そこそこの信頼度"で知れることも大事かな、と。あと、サーバサイドで判定していたらSmartyなんかのテンプレートシステムでコード分けがものすごくシンプルになります。</p>

<p><pre>
{if $os=='win'}
&lt;h1&gt;For Windows User&lt;/h1&gt;
{/if}
</pre></p>

<p>こんな感じでtplファイルに書けます。これをクライアントサイドでやると</p>

<p>
<pre>
if(os=='win'){
 document.write('&lt;h1&gt;For Windows User&lt;/h1&gt;');
}
</pre>
</p>

<p>こんな感じですかね。クライアントサイドでの判別方法の実装側の問題点として、ソース内のHTMLの実体が文字列ばっかりになっちゃって何だか分からなくなること多いこと。タグが入れ子になってきたらよくミスっちゃうことも多いはず。と、いうわけで、ずっとクライアントサイドに振るべきだと思われてた仕事も、サーバ側に振れる仕事は振っちゃってもいいのかな、と思いました。</p>


