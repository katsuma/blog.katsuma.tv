---
title: TwitterAPIでひとことガジェット
date: 2007/04/24 02:12:11
tags: gadgets
published: true

---

<p><a href="http://blog.katsuma.tv/2007/04/jsonptwitterapi.html">「JSONPのTwitterAPIを試してみました」</a>のつづき。</p>

<p>昨日はあまりにオレオレBlogパーツだったので、もうすこし汎用的なものに。IDを入力することで最新のひとことを表示するBlogパーツ（ガジェット）にしてみました。これくらいのパーツは本家で用意されてるっちゃーされてるんですけども、見た目があまり好きじゃなかったので自前でサクサクと。</p>

<p>
<img src="http://blog.katsuma.tv/images/twitter_jsonp_2.gif" alt="twitter" />
</p>

<p>で、使い方はこんな感じです。基本的に昨日とかわらないです。</p>

<p>サイドバーなんかに以下のコードをコピペ。</p>
<p>
<pre>
&lt;script type="text/javascript" src="http://blog.katsuma.tv/js/twitter.js"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
loadTwitter('3224511');
&lt;/script&gt;
&lt;div id="viewTwitter"&gt;&lt;/div&gt;
</pre>
</p>

<p>loadTwitter()の中に数字は個人IDです。この取り方は<a href="http://blog.katsuma.tv/2007/04/jsonptwitterapi.html">ここ</a>参照。ちょっとイレギュラーな取り方かもだけども。</p>

<p>で、以下、作業メモ</p>

<p>
<ul>
<li>背景画像とpadding使ったCSSをスッキリ書くのが面倒だったんでFlash使った</li>
<li>更新日時も出力しようと思った</li>
<li>けどFlashVarsで半角スペース入った文字列がうまくわたらない。。。</li>
<li>JSONの文字列をそのままモリっとわたしてActionScriptでパース？</li>
<li>JSON.asとか使えば楽チンなんで明日とかに見よう</li>
</ul>
</p>

<p>な、感じです。横幅とかはこのBlog用に最適したものなんで、一般的なは少し大きいサイズかも。もしこんなの使いたいなんて人いたらコメントかトラバもらえれば。リクエストも時間あったら受け付けるかもです。で、今後はPOSTのAPIを見ていこうと思います。</p>
