---
title: mixiの絵文字を消去するbookmarklet
date: 2008/03/01
tags: javascript
published: true

---

<p>
会社で「mixiの日記で文字が多すぎると読みにくくて仕方ない」みたいな話がでて、「それFirebugのコンソールでなんとかなりそうだな」と思ってTwitterにこんなのをつぶやいてみた。</p>

<blockquote>mixiで絵文字OFFるとき⇒Firebugで var e = $x('//img[@class="emoji"]');for(var i=0,l=e.length; i&lt;l i++){ e[i].style.display='none';}
<p>
via <a href="http://twitter.com/ryo_katsuma/statuses/763853426">Twitter</a></p>
</blockquote>



<p>そうしたら<a href="http://labs.gmo.jp/blog/ku/">ku</a>さんから「map map」なレスが。</p>

<blockquote>@ryo_katsuma mapmap $x('//img[@class="emoji"]').map( function(e){ e.style.display='none' } )
<p>
via <a href="http://twitter.com/ku/statuses/763855508">Twitter</a></p>
</blockquote>

<p>普段mapあまり使わなかったから、こっちの方が1行で書けて確かにいいなーと思いつつ、せっかくなんでBookmarkletにしてみました。xPathどうしようかと思ったけどmixiはprototype.jsロードしてるから$$関数とか使ってあげればCSS記法でノードを抽出できるわけですね。</p>

<p><strong><a href="javascript:(function(){$$('img.emoji').each(function(i){i.hide()});})()">mixi emoji delete</a></strong></p>

<p>上記リンクをブックマーク。スッキリ消えて見やすくなっていい感じです。</p>
<p>それにしても最近jQueryばっか使ってたらPrototype.jsの使い方とかすっかり忘れてた。。</p>


