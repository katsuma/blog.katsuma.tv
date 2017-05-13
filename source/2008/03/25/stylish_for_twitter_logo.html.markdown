---
title: Twitterのロゴの色が濃くなったのを元に戻すCSS
date: 2008/03/25
tags: develop
published: true

---

<p>どうもTwitterのロゴの画像がいきなり今日変更になった模様。色味が少し濃くなったみたい。ただTwitterにどっぷり漬かった生活では、こんな少しの変化も違和感を覚えて仕方ないです。</p>

<p>なので、ユーザCSSで少し書き換えてやることで雰囲気を元に戻してやりました。<a href="https://addons.mozilla.org/ja/firefox/addon/2108">Stylish</a>で次の設定を追加。</p>

<p><pre>
h1&gt;a&gt;img{
-moz-opacity: 0.6;
}
</pre></p>

<p>スタイル適用前</p>
<p><img src="http://farm3.static.flickr.com/2244/2357934297_e1aba6659e_o.png" /></p>

<p>スタイル適用後</p>
<p><img src="http://farm3.static.flickr.com/2215/2358767690_102978719b_o.png" /></p>

<p>透明度を変えただけだけども、雰囲気は前の感じに戻った（気がする）。</p>


