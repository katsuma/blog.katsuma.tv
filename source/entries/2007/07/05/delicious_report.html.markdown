---
title: del.icio.us Report(α版)を作ってみました
date: 2007/07/05
tags: javascript
published: true

---

<p><a href="http://lab.katsuma.tv/del.icio.us_report/"><img alt="delicious_report.gif" src="http://blog.katsuma.tv/images/delicious_report.gif" width="430" height="450" border="0" /></a></p>

<p><a href="http://airy.web.infoseek.co.jp/cgi-bin/forgotthemilk/labo/hatena-report/index.cgi">Hatena Report</a>はUIも使い勝手もいいので、定期的にヒマつぶしに見てしまうのですが、<a href="http://lab.katsuma.tv/del.icio.us_report/">del.icio.us Report</a>も欲しい！！と思ったので作ってみました。（ただし超α版）。使い方は上の図のとおり。URL入れて１クリックでレポートを作成します。有益な情報が多い<a href="http://labs.cybozu.co.jp/">サイボウズ・ラボ</a>さんを例として利用させていただきました。で、以下、メモです。</p>

<h3>仕様や動作条件</h3>
<p><ul>
<li>Firefox2.0しか動作確認していません。yield文使ってるのでIEは動きません。</li>
<li>基本的にBlogを対象としてます。</li>
<li>サイト内URL数は1000を上限にしてます。なのでサイトによっては正確な値は出ないかもしれません。</li>
<li>サイト内URL抽出は<a href="http://developer.yahoo.co.jp/search/web/V1/webSearch.html">Yahooウェブ検索API</a>を利用しています。が、ここのresultとstartの違いがよく分かっていません。（50が最大なのか1000が最大なのか？？）</li>
<li>見た目のUIは後回し中です。</li>
</ul>
</p>

<h3>面倒だった点、未解決な点</h3>
<p><ul>
<li>ロジックは単純。Yahoo検索APIでURL情報を拾って、del.icio.usにPOSTしているだけ。</li>
<li>Yahoo検索APIで「inurl:hoge」が効かない？mt-search.cgiなんかのURL情報は省きたかったけどうまくいかなかった。</li>
<li>del.icio.usに<a href="http://blog.katsuma.tv/2007/06/delicious_error.html">ものすごい勢いでPOSTしまくると怒られる</a>。全URLを毎回POSTしてみたらこの結果。</li>
<li>なので、１リクエストあたり15件（del.icio.usの仕様上の上限値）までのURL情報を入れて、リクエスト間に1秒値のsleepを入れてる。</li>
<li>ここでの「1秒値のsleep」に勉強がてらyield文を使ってみてます。これ使いこなせたらすごい楽しげ。（勉強メモ <a href="http://d.hatena.ne.jp/amachang/20060805/1154743229">[1]</a> <a href="http://piro.sakura.ne.jp/latest/blosxom/webtech/javascript/2006-08-07_yield.htm">[2]</a>）</li>
</ul></p>

<p>と、いうわけでまだまだ見た目とかひどすぎるんですけども、とりあえずザックリと挙動だけは確認できるかな、と。あと今回はとにもかくにも<strong>yield文</strong>！このいい勉強になりました。</p>


<p><strong>2007.07.09 追記</strong><br/>
進捗度をグラフで表示しました。悩んだ割りにには、「Callback数/POST数」の単純なロジックで実現できました。</p>

<p><strong>2007.07.08 追記</strong><br />サイト内の各ページのURL取得はYahooのインデックスに完全依存しているので、実際の被ブックマーク数とはズレが生じています。あくまで「目安を知る」ということで、その点だけご理解よろしくお願いいたします。</p>
