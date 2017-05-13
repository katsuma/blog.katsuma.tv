---
title: BlogをiPhone対応させてみました
date: 2008/07/30
tags: diary
published: true

---

<p>iPhone持ってないので実機確認はしてないのですが、シミュレータ上で確認しながら、このBlogをiPhone対応させてみました。</p>

<p>させてみました、と言いつつも大したことはやってなくて</p>

<p><ul>
<li>サイドバーを非表示(コンテンツ表示幅が小さくなって読みづらいから)</li>
<li>CSSをやや修正</li>
<li>metaタグを追加</li>
</ul></p>

<p>だけです。具体的には、まずlinkタグで読み込んでいる大元のCSSであるstyles-site.cssの最後に次の内容を追加。</p>

<p><pre>
@media screen and (max-device-width: 800px){ 
  #utilities { display:none }
  #content { min-width:800px; max-width:1280px }
  body.double div#main { width : 100%; border-right : none}
  li, dt, dd { font-size : 90%; } 
}
</pre></p>

<p>サイドバーの#utilityを非表示にして、コンテンツ部分の#contentの幅を最適化。あといろいろ折り返されていた箇所が多かったので、li, dt, dd要素のサイズを小さくしています。</p>

<p>その後にmetaタグに次の内容を追加。</p>

<p><pre>
&lt;meta name = "viewport" content="width=728" /&gt;
</pre></p>

<p>これでこんな感じにすっきり収まっています。（シミュレータ上ですけど）</p>

<p><a href="http://www.flickr.com/photos/katsuma/2715799675/" title="iPhone CSS by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3232/2715799675_77bbc693fc_m.jpg" width="127" height="240" alt="iPhone CSS" /></a></p>

<p>即席で作ったんですけど、何もやらないよりは表示はマシになりました。ただサイドバーをなくしてしまったので、ナビゲーションが悪くなっているのでここは専用のカスタマイズを行ってあげたほうがよさそうですね。</p>


