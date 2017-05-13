---
title: TwitteAPIでひとことガジェット + Incremental Search
date: 2007/05/22
tags: gadgets
published: true

---

<p>TwitterAPIやTwitter.fmでいろいろ遊んでました</p>

<ul>
<li><a href="http://blog.katsuma.tv/2007/04/twitter_gadget_1.html">TwitterAPIでひとことガジェット</a></li>
<li><a href="http://blog.katsuma.tv/2007/05/twitter_search_by_jsonp.html">JSONPを利用したTwitter Search</a></li>
<li><a href="http://blog.katsuma.tv/2007/05/twitter_incremental_search.html">Twitter Incremental Search</a></li>
</ul>

<h3><a href="http://lab.katsuma.tv/twitter_search_gadget/">Twitter Incremental Search Gadget</a></h3>
<p>今回、これらを全部まとめてガジェット化にしてみました。</p>
<p><a href="http://lab.katsuma.tv/twitter_search_gadget/"><img alt="Twitter Gadget" src="http://blog.katsuma.tv/images/07052102.gif" width="158" height="110" /></a></p>

<p>まとめただけなので、特に前回から新機能はありません。デフォルトで最新のTwitterの最新ひとことを表示し、「Input Your Keywords」の箇所に、検索したい文字列を入れれば<a href="http://twitter.fm/">Twitter.fm API</a>経由で検索結果も表示します。</p>

<p>ただ、以下のコードをはりつければ、ご利用のBlogでも同じようなガジェットを利用できます</p>

<p>

<textarea rows="8" cols="80" onfocus="javascript:this.select()">
<link rel="stylesheet" type="text/css" href="http://lab.katsuma.tv/twitter_search_gadget/TwitterSearchGadget.css" />
<div id="twitterGadget"></div>
<script type="text/javascript" charset="utf-8" src="http://lab.katsuma.tv/js/prototype.js"></script>
<script type="text/javascript" charset="utf-8" src="http://lab.katsuma.tv/js/ObjTree.js"></script>
<script type="text/javascript" charset="utf-8" src="http://lab.katsuma.tv/twitter_search_gadget/TwitterSearchGadget.js"></script>
<script>
initTwitterGadget('3224511');
</script>
</textarea>
</p>

<p>例によって最後のinitTwitterGadget()の引数の文字列は自分のTwiterID。<a href="http://blog.katsuma.tv/2007/04/twitter_gadget_1.html">IDの調べ方はこのへん</a>。このBlogのサイドバーも新しいのに変えたかったんだけども、今回Flash使わずにAll-JavaScript＋CSSで作ったら、元のCSSと干渉して表示が崩れたorz （多段？のCSSのデバッグ難しいなぁ）</p>

<p>きっと（割と）プレーンなHTML+CSSの上だとさっくり表示されるはずです。WinIE7+Firefox2で確認。もし使ってくださった方などいらっしゃったら、ここのコメントやはてブのコメントなんかをいただければと思いますよー。</p>
