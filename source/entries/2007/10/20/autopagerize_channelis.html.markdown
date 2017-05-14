---
title: クロスブラウザ対応したAutopagerizeもどきの実装
date: 2007/10/20 12:30:01
tags: javascript
published: true

---

<p>Greasemonkeyで「次へ」のリンクがあるようなサイトを無限スクロール可能にさせる<a href="http://userscripts.org/scripts/show/8551">Autopagerize</a>というGMScriptがあります。「次へ」のリンク箇所、次のページ内容、内容を挿入する箇所などをXPathで記述（SITEINFO）し、これらのSITEINFO情報はWikiで管理されてあるので、Autopagerizeが実現できるページはユーザ側でどんどん増やしていくことが可能。なので、気づけば「あ、このサイトも勝手にスクロールされる！！」な発見も多く、非常に素晴らしいGMScriptです。Mozilla24のShibuya.JSで知ったのですが、これ無しじゃもうやってられないくらい愛用しています。</p>

<p>で、ウチでリリースしている<a href="http://channel.is/">Channel.is</a>のサイト、最近ややコンセプトが変わってスタートページは各ビデオ共有サイトの横断検索が可能なサービスになっているのですが、ここの検索結果もAutopagerizeのSITEINFOに登録していました。すると社内で結構評判良かったので、せっかくなんでGMだけにとどめておくのではなく、モダンブラウザ全部対応したスクリプトをスクラッチから書いてみました。</p>

<p>（例）<a href="http://channel.is/?q=video">[ 検索 ] video</a></p>

<p>注意事項として、本家のAutopagerizeのWikiには、channel.isのSITEINFOを削除いただくよう、要請を出しているのですが、コンフリクトを起こす可能性もあるので、Autopagerize導入済みの方は「ユーザスクリプトを実行しないサイト」で「http://channel.is/*」を指定いだければと思います。</p>

<p>以下、実装上のメモです。</p>

<p><ul>
<li>動作確認済みブラウザはIE6以上、Firefox2.0、Opera9.0, Safari3.0b。今時なブラウザならほぼ大丈夫（、、なはず）</li>
<li>実体は<a href="http://channel.is/js/pagerize.js">pagerize.js</a></li>
<li>prototype.js1.5.1.1ベース、String#evalJSON()利用。eval()でもよかったんだけど何となく</li>
<li>スクロール量や、要素の座標位置についての情報をまとめるのにやや苦労した</li>
<li>このあたりはPagerize.get*()あたりにまとめてるので、参考にしたい方はどうぞ</li>
<li>本家はXPathゴリゴリだけども、IEではXPath使えないし、これだけのためにxpath.js使うのもアレなので、JSON API作ってXHRで「次へ」のページ要素を取得＋innerHTML追記、の方法にした</li>
<li>スクロールイベントをトリガに先読みさせるとき、先読みをブロックさせる方法をうまく実装しないと無限先読みを引き起こさせうる。ここが厄介</li>
<li>結局先読みをスタートさせるとブロック開始→先読みさせた内容を描画開始するとブロック解除</li>
<li>この辺りはまだやや改良の余地あるかも</li>
</ul></p>

<p>この手のサービスはIEのXPath対応がやっぱ肝ですねぇ。各サイトが先読み用のそれなりのAPIを提供してくれないと、やっぱり苦しいかも、という印象でした。</p>

