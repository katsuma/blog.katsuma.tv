---
title: はてなスターを付けてみました
date: 2008/12/17 02:35:54
tags: diary
published: true

---

<p>かなり今更ですけど、各エントリのタイトルにはてなスター付けてみました。CSSもあわせて少し変更。MT + <a href="http://vicuna.jp/">mt.Vicuna</a>のテンプレート使っている人は参考になるかと思います。</p>

<h3>Topページ</h3>
<p>以下のコードをページ下部に追加。はてなではheadタグの中に、と書いてあるけどページ全体のレンダリング速度を上げたいので下部に書いた方がベター。</p>

<p><pre>
&lt;script type="text/javascript" src="http://s.hatena.ne.jp/js/HatenaStar.js"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
Hatena.Star.Token = 'xxxxxxxxxx';
Hatena.Star.SiteConfig = {
  entryNodes: {
    'div.section': {
      uri: 'h2 a',
      title: 'h2',
      container: 'h2'
    }
  }
};
&lt;/script&gt;
</pre></p>

<p>CSSに以下の行を追加。</p>

<p><pre>
div.entry h2 span.hatena-star-star-container a,
div.entry h2 span.hatena-star-comment-container a{
	border:none;
}
</pre></p>

<h3>エントリページ</h3>
<p>同じように以下のコードを下部に追加。</p>
<p><pre>
&lt;script type="text/javascript" src="http://s.hatena.ne.jp/js/HatenaStar.js"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
Hatena.Star.Token = 'xxxxxxxxxx';
Hatena.Star.SiteConfig = {
  entryNodes: {
    'div#main': {
      uri: 'window.location',
      title: 'h1',
      container: 'h1'
    }
  }
};
&lt;/script&gt;
</pre></p>


