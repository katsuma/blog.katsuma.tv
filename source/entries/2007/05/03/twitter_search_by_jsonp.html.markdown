---
title: JSONPを利用したTwitter Search
date: 2007/05/03 04:55:58
tags: javascript
published: true

---

<p>JSONPを利用した<a href="http://lab.katsuma.tv/twitter_search/">Twitter Search</a>を作ってみました。モノを見たほうが早いかも。</p>

<p>(追記：2007/05/03 08:00) Twitter.fmが落ちていることがたびたびあるようです。そのときは検索できません。。</p>
<p>(追記：2007/05/16 03:30) script要素が無限に増殖するのを防ぐために、要素数を1に抑える処理を加えました。</p>


<h3>
<a href="http://lab.katsuma.tv/twitter_search/">Twitter Search</a>
</h3>
<p>- powered by <a href="http://twitter.fm/">Twitter.FM</a></p>
<br /><br />

<p>検索ボックスで適当な単語を入れると非同期通信で検索結果が表示されます。最後にも書いていますが、<del>今のところ<strong>日本語は通りません</strong>。英単語のみです。</del>（2007.05.16 日本語が通るのも確認しました）あと複数クエリもちょっと怪しいです。とりあえず「hungry」「Twitter」とかで検索かけてみると雰囲気が分かります。</p>

<p>元ネタはつい最近できたTwitter検索サイトの<a href="http://twitter.fm/">Twitter.FM</a>。ここが検索APIである<a href="http://twitter.fm/api/">Twitter.FM API</a>を提供してくれているので、これを利用させていただきました。（利用規約とか無かったので勝手に使っちゃったけどマズいかな。。）</p>

<p>APIが提供されてある、、といってもXML/RSSフォーマットしかないので、これをそのまま使うことはできません。JSONP対応してくれていると非常に助かる、、あとJSONフォーマットも対応してくれれば、、と、あれこれ思ったので、思うより動けで次のようなアプローチを。</p>

<p>
<ol>
<li>PHPでJSONP Proxyを作成</li>
<li>callbackで渡されるXMLをちょっと手直し</li>
<li>XMLオブジェクトをJSONオブジェクトに変換</li>
<li>ゴニョゴニョして表示</li>
</ol>
</p>

<p>では、ざっくり解説をば。</p>

<p>
まず1.ですが、要するにAPIは提供してくれているけど、JSONPには対応していない、なサービスに対して、「オレオレJSONP対応」をするために作成しました。発想のネタ元は<a href="http://d.hatena.ne.jp/aql/20060825/1156504899">こちら</a>。本当はこれをそのまま拝借しよう、と思っていたのですが、Twitter.FM APIの場合、リクエストに対して返ってくるものがJSONではなくXML/RSSとなります。なので、
</p>

<p>
<pre>callback(xmlObj)</pre>
</p>

<p>ではなく</p>

<p>
<pre>callback('xmlObj')</pre>
</p>

<p>と、シングルクオートで囲ってあげて、その後でXML解析を必要があります。うーん、微妙。
でも、これをやらないと無理（な、はず）。と、いうわけで即席でProxyを作りました。一応URLをば。</p>

<p>
<pre>
http://lab.katsuma.tv/api/jsonp_proxy.php?callback=[callback関数名]&url=[URLEncodeされたURL]&sq=[on|off]
</pre>
</p>

<p>な書式にしてます。上記の例みたいにしたかったけどとりあえず即席。urlで与えられた内容を「callback+(+'」と「'+)」で囲ってあげるものです。シングルクオートの有無もオプション（sq=on|off）で付けられるように。セキュリティだけ気をつければ(*)そんなに難しいものではないので、さっくりできるはず。<br />(*)今回作成したものは、urlで与えられるものは「http://～」の書式のものだけに限定してます。url=/etc/passwd とか無しで。</p>

<p>このProxy自体は作ることは簡単なのですが、JSONPにまじめに対応させようとすると罠がありました。。。2で書いていますが、XMLが返ってくる際に改行文字入りのXMLが返ってきたら</p>

<p>
<pre>
hoge('&lt;?xml version="1.0" encoding="UTF-8"?&gt;
</pre>
</p>

<p>で、止まってしまい、ここでエラーが起きちゃうんですね。要するに文字列としてなんかおかしいぞ、と。callback関数に渡すXMLは1行で渡さないとダメ。あと、当然ながら渡される文字列にシングルクオートが生で入っていればあらかじめエスケープさせておく必要があります。このあたりもろもろを考慮してProxyを作る必要があります。</p>

<p>3のXML→JSONは<a href="http://www.drk7.jp/MT/archives/001011.html">XML2JSON</a>なサービスもあるんですけど、今回は自前で。ちょうどJSANから「<a href="http://www.kawa.net/works/js/xml/objtree.html">XML.ObjTree - XML～JavaScriptオブジェクト変換クラス</a>」なライブラリがあったので、それを利用しました。これ相当便利すぎるので必見。使い方はこんな感じ。</p>

<p><pre>
var xotree = new XML.ObjTree();
var xml = '&lt;?xml version="1.0"?&gt;&lt;root&gt;&lt;node&gt;Hello, World!&lt;/node&gt;&lt;/root&gt;';
var tree = xotree.parseXML( xml );       	// source to tree
document.write( "message: "+tree.root.node );
</pre></p>

<p>ここまでくると、あとは4で表示だけ。今回はplainなリスト形式で書き出しています。</p>

<p>TODOとして、<strong>検索クエリに日本語が通りません</strong>。英語のみです。これはTwitter.FM API側で対応を願うのみ、、になっちゃうんですが、利用側でいい回避策はないかなぁ、と考え中です。（URLエンコードのクエリを投げてもどうもダメのようで）
ただ、実際のサイトの検索ボックスでは日本語が通っているので、内部的にはOKなのでしょう。APIとして公開した場合に、まだ問題があるのかな。</p>

<p>あと、この検索+結果をうまく整形して使い勝手がいいものにまとめなおしたいです。今のままだと、単純に「APIで遊んだだけ」で終わってしまうので。まずはいろいろおざなりになってるガジェット化かなぁ。</p>
