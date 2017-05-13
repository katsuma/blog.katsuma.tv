---
title: JavaScriptによるテーブルの列でソート
date: 2006/12/17
tags: javascript
published: true

---

Excelなど表で出力されるデータは列の先頭をクリックしてソートしたいことが多々あります。WindowsならExplorerでも標準でありますよね、例のアレ。

Web1.0的考えならクリック毎にサーバで処理してソートされた表のHTMLを生成してブラウザに返して・・・な流れになりますが、Web2.0なこのご時世はJavaScriptだけで解決できます。デモは<a href="http://lab.katsuma.tv/order_by_column/">こちら</a>。

利用しているライブラリは<a href="http://prototype.conio.net/">prototype.js</a>と<a href="http://skit.dip.jp/lab/js/order_by_column">order_by_sort.js</a>。
後者は公式サイトがダウンしちゃってるみたいなんで気になる人は<a href="http://lab.katsuma.tv/js/order_by_column.js">デモページからご利用ください</a>。



order_by_sort.jsのポイントは<strong>既存のtableに非常に組み込みやすい</strong>の一点に尽きます。&lt;thead&gt;, &lt;tbody&gt;タグを使ったtableなら何も修正する必要はありません。もし&lt;thead&gt;, &lt;tbody&gt;を付けていないtableなら、1行目の&lt;tr&gt;から&lt;/tr&gt;までをtheadタグで囲ってやり、tr→thに変換するだけでOK。そして最後に次の関数を呼び出します。

&lt;script type="text/javascript"&gt;
&lt;!--
new OrderByColumn("<em>tableID</em>",["<em>type_of_column</em>", ... ]);
//--&gt;
&lt;/script&gt;

tableIDはtableタグに付けたidです。デモでは「sample_order_by_column_table」にしています。
type_of_columnはどのように整列させるか、を記したものです。文字列による整列なら"string", 数値による整列なら"number"を記します（ソースを見る限り、この２種類のみの対応のようです。）デモでは

<blockquote>
new OrderByColumn(
 "sample_order_by_column_table",
 ["string","number","string"]
);
</blockquote>

と、呼び出しています。（スペースの都合上、改行しています）

あと、幾つかTipsを。

整列させたくない列はthead内に「th」ではなく、「td」で定義させます。
HTMLの文法的には微妙ですが、てっとり早く解決するにはとりあえずこれで回避できます。

また、aタグに囲まれたデータ（デモではCommunityの列）の場合、aタグにtitle属性を他の属性よりも先に記すことで整列可能です。titleでしかるべき値をセットしておかないと思ったような動作をしてくれません。


tableの整列ライブラリは<a href="http://www.mochikit.com/">MochiKit</a>にもあるみたいですが（試してないです・・・）、こんな感じで手軽に組み込めるのはいいですね。
