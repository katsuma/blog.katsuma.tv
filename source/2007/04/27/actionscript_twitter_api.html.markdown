---
title: ActionScriptのTwitterAPIが全く使えない件について
date: 2007/04/27
tags: web20
published: true

---

<p> 
<ul>
<li><a href="http://blog.katsuma.tv/2007/04/jsonptwitterapi.html">JSONPのTwitterAPIを試してみました</a></li>
<li><a href="http://blog.katsuma.tv/2007/04/twitter_gadget_1.html">TwitterAPIでひとことガジェット </a></li>
</ul>
</p>

<p>の、続きを作っていました。by ActionScript2で。「なんで今更ActionScript2?流行りは3でしょ？
」と、いう話もあろうかと思いますが、世の中の流れがあまりにもAS3に走っているので、ここで敢えて2で作ることも意味はあるかな、なんてひねくれ気質がチラリ。と、いうわけでこんなBlogパーツを作ろうと思ってました。</p>

<p>
<ol>
<li>自分の最新ひとことを表示</li>
<li>Flickrみたく、textareaをクリックで編集開始</li>
<li>テキストを編集してEnterで新規ひとことをPOST</li>
<li>1へ戻る</li>
</ol>
</p>

<p>で、ASのAPIも公開されている、ということで特に問題もなくサクサクと進んでました。が、ところが。</p>



<p>情報の取得は問題なくできるのに、更新がまっっったくできない。なんだこりゃーと思ってサーバからのレスポンスを見てみるとこんなものが。</p>

<p>
<blockquote>Sorry, due to abusive behaviour, we have been forced to disable posting from external websites. If you are posting from an API tool, please ensure that the HTTP_REFERER header is not set.</blockquote>
</p>

<p>うわーーAPI意味ねーーw　てか誰だよ悪さしたやつw</p>

<p>と、思ったら時を同じくしてid:amachangさんも同じものにハマってたみたいで。<br />
<a href="http://d.hatena.ne.jp/amachang/20070425/1177528905">http://d.hatena.ne.jp/amachang/20070425/1177528905</a><br />
JavaScriptのは試してないんだけども、とりあえずASのAPIは現状、まったく使えない、ということで結論付けられたのでした。。。（がっかり）</p>

<p>とりあえず、前回までに作ってたのでビミョーなバグとかあったんで、そいつを手直してTwitterで遊ぶ方法は方向性を変えようと思います。いやー構想含めると２日ほどほんとつぶしたなぁ。</p>
