---
title: SpiderMonkeyのインストール
date: 2007/12/09 03:19:23
tags: javascript
published: true

---

<p>完全に自分専用の備忘録です。</p>  <p>ちょこっとしたコードやベンチマークとるとき、今までFirebug使ってたんですけども、ファイルにまとまったくらいの規模、100〜200行規模のものだとFirebugだと少し扱い辛いです。で、そんなときに<a href="http://www.mozilla-japan.org/js/spidermonkey/">SpiderMonkey</a>。最近よく使ってます。</p>  <h3>インストール方法</h3> <p>ソースコードを入手＞解凍＞makeくらいで簡単。以下はOSXでの方法。Linuxでもほぼ同じです。</p> <pre>wget ftp://ftp.mozilla.org/pub/js/js-1.7.0.tar.gz<br />tar xvzf js-1.7.0.tar.gz<br />cd js/src<br />make -f Makefile.ref<br />cp Darwin_DBG.OBJ/js /usr/bin/<br /></pre>  <h3>使い方</h3> <p>ターミナル上で「js」とタイプすると、SpiderMonkeyがインタプリタとして起動するのですが、個人的にはファイルを食わせて実行する場合の方が多いです。適当な実行コードを含むファイルを作っておいて</p>  <p>&nbsp;</p><pre>js -f hoge.js</pre><p>&nbsp;</p>  <p>こんな感じで実行。document.write()は無いので、代わりにprint()で情報を出力することになるのは注意。</p>


