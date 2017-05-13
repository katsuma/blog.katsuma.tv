---
title: Twitter Incremental Search
date: 2007/05/16
tags: javascript
published: true

---

<p><a href="http://lab.katsuma.tv/twitter_incremental_search/">JSONPを利用したTwitter Incremental Search</a>を作ってみました。</p>

<p><a href="http://blog.katsuma.tv/2007/05/twitter_search_by_jsonp.html">前回（JSONPを利用したTwitter Search ）</a>のやや応用。検索をインクリメンタルサーチ対応させました。Win+IE, Firefoxで確認済。今回も<a href="http://twitter.fm/">Twitter.FM</a>にお世話になっています。いつの間にやら日本語通るようになっていてイィ感じに！</p>

<p>事の発端は<a href="http://w-it.jp/shima/">嶋くん</a>から「prototype.js使ったインクリメンタルサーチを教えて！」と言われて。「すぐ対応するよ！」と言いつつ、やや放置していたのでサックリ作ってみました。以下、簡単な解説。</p>

<p>検索を行うJSONPの仕掛けについては<a href="http://blog.katsuma.tv/2007/05/twitter_search_by_jsonp.html">前回</a>を参考にしていただくことにして、今回はインクリメンタルサーチにのみにフォーカス。ポイントは</p>

<p>
<pre>
Form.Element.Observer(監視対象エレメントID, 監視間隔（秒）,関数オブジェクト);
</pre>
</p>

<p>です。</p>

<p>Form.Element.Observerは、常にフォームの値が変化しているかどうかを監視し、変化があると指定した関数を実行します。監視対象エレメントは、この場合inputエレメント（id="query"）になります。</p>

<p>監視間隔は今回は毎秒行っています。間隔が小さい方がサクサク感は出ますが、もちろんサーバの負荷はそのときと比べて大きくなります。また、関数オブジェクトは、前回作成したsearchTwitter()を指定しています。</p>

<p>ポイントとして、Form.Element.Observerは一度監視を開始すると、その解除を行うことは少なくとも標準のprototype.jsでは、できません。このあたりの話は「<a href="http://blog.katsuma.tv/2007/03/form_element_observer_stop.html">Form.Element.Observerをクリアする</a>」でも書いていますが、prototype.jsを上書きして、clearIntervalを呼ぶようにします。<a href="http://lab.katsuma.tv/js/prototype.js">ここで利用しているprototype.js</a>は、修正を加えたものにしています。</p>

<p>このあたりの処理は、検索以外にもフォームの入力値チェックにも使えますし、応用範囲は結構ありそうなので、一度手を動かしておいてやり方を身に付けておいて損は無いと思います。</p>
