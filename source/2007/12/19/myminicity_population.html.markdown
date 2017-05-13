---
title: MyMiniCityでPopulationを増やす(ことができるかもしれない)方法
date: 2007/12/19
tags: web20
published: true

---

<p><strong>[追記 : 2007/12/20 14:30] 結局下記の方法だとダメでした。詳細は一番下に書いてます。</strong></p>

<p>今日いきなり人気が出た<a href="http://myminicity.com/">MyMiniCity</a>ですが、<a href="http://blog.livedoor.jp/dankogai/archives/50970498.html">dankogaiさんも言及してるように</a>URLへのアクセスでしかPopulationを増やすことができません。Blogパーツが出るまではなかなかPopulation増やすことができないと思うのでこんなコードをBlogに貼り付けておくのはどうでしょうか？（Population厨とか言われそうだけど）</p>

<p><pre>
&lt;script src="http://{$path_to_js}/prototype.js" type="text/javascript"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
Event.observe(window, 'load', function(){
        var head = document.getElementsByTagName('head').item(0);
	var u = 'http://{$city_id}.myminicity.com';
        var s = document.createElement('script');	
	s.setAttribute('type', 'text/javascript');
	s.setAttribute('src', u);
	s.setAttribute('charset', 'UTF-8');
	head.appendChild(s);
});
</pre></p>

<p>JSONP的な感じでページロード時にリクエストを投げているだけ。${path_to_js}ディレクトリにprototype.jsを置き、{$city_id}のところに自分のMyMiniCityのサブドメインを設定。リファラチェックとかMyMiniCity側でどうなってるのか謎だけどちょっと様子を見てみようと思います。人柱的にこのBlogのエントリーページにだけ入れ込んでみました。</p>

<p><strong>[ 追記 : 2007/12/20 14:30 ]</strong>　冒頭の通り、scriptタグで呼び出しだとダメでした。Blogのアクセス数の割にPopulation全然増えません。。。HTTPでまともに呼び出さないとダメみたいですね。これだと、他にはiframeで呼び出すという卑怯な技を使っちゃうくらいしか思いつかないです。</p>

<p>と、いうわけで埋め込み実験はここで一度終了したいと思います。</p>



