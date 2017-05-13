---
title: エントリーにソーシャルブックマークのコメントを追加するJavaScript
date: 2008/04/27
tags: javascript
published: true

---

<p>(追記 : 09/02/12) ソースは<a href="http://github.com/katsuma/sbm-comment/tree/master">githubでホスティング</a>することにしました。</p>

<p>タイトルのようなものを作りました。（<a href="http://blog.katsuma.tv/js/SBMComment.js">SBMComment.js</a>）</p>

<p>説明するより見てもらったほうが早いかも。<a href="http://blog.katsuma.tv/2008/03/notification_by_favicon_change.html">faviconかえるやつのエントリー</a>とかだとわかりやすいと思います。エントリーの下の方にはてブ、del.icio,us、Livedoor Clip、Buzzurlで書かれたコメントを拾ってきて、整形して表示しています。</p>


<h3>経緯</h3>
<p>masuidriveさんが、「<a href="http://blog.masuidrive.jp/index.php/2008/04/17/released-hatena-bookmark-anywhere/">ブログにはてブのコメントを表示するhatana_bookmark_anywhere.js</a>」なんてものを公開されてるのを見て「あーすごくいい！これ欲しかった！むしろやりたかった！」と思っていました。さっそく設置を行おうと思った矢先、どうせだったら他のSBMのコメントも一緒に表示したいなぁ、とも思いました。このあたりのSBMはそれなりのJSON APIを用意してくれているので、ついでに他のSBMのコメントも拾ってくるやつを自作しいてみることにしました。</p>

<p>でも、そもそもこんなこと誰かやってないの？？と思って少し調べてみるとmuumoo.jpさんが<a href="http://muumoo.jp/news/2007/12/14/0commentspoweredbybookmarks.html">Yahoo PipesでJSON APIを作ってくださっている</a>のを発見。（<a href="http://pipes.yahoo.com/pipes/pipe.info?_id=3J_WV8j_2xGssdY4qWIyXQ">Pipesのページ</a>）この出来が超よかったので便乗してのっかってみることにしました。このAPI叩くほうがコードもスッキリして書きやすいし。あと自前サーバにAPIを作るんじゃなくてPipes使うという発想がスマートでとても気に入りました。そんなわけで、muumoo.jpさんのラッパーJSといえばそれまでなのですが、そこそこ融通は効きやすいようにしたつもりです。</p>

<h3>SBMComment.js(とりあえず導入編)</h3>
<p>ページ内のコメントを表示したいところで次のようなコードを追加します。</p>
<p><pre>
&lt;div id="sbm-comment"&gt;&lt;/div&gt;
&lt;script src="http://{どこかのサーバ}/SBMComment.js" type="text/javascript"&gt;&lt;/script&gt;
&lt;script type="text/javascript"&gt;
SBMComment.load({ area : 'sbm-comment'});
&lt;/script&gt;
</pre></p>

<p>そうすると、次のようなコードがdiv id="sbm-comment"の箇所に挿入されます。</p>

<p><pre>
&lt;p id="1206265040"&gt;
&lt;span class="sbm-comment-name"&gt;&lt;a href="http://hatena.ne.jp/"&gt;jkondo&lt;/a&gt;&lt;/span&gt;
from &lt;span class="sbm-comment-type-hatena"&gt;hatena&lt;/span&gt; at &lt;span class="sbm-comment-date"&gt;2008-04-26 22:00&lt;/span&gt;
&lt;/p&gt;
&lt;p class="sbm-comment-description"&gt;これはひどい&lt;/p&gt;
</pre></p>

<p>要するにareaで指定したidの箇所に内容がロードされる、というわけです。コメントが見つからない場合は何もロードされません。</p>

<h3>SBMComment.js(応用編)</h3>
<p>書き出されるHTMLにはそれっぽいスタイル属性をつけているので、CSSでも整形できなくないですが、場合によってはニーズにあわない場合もあると思います。そこで、filterパラメータに整形用filter関数を指定することで、各コメント要素に対してfilter関数にかけて、書き出すHTMLを自由に操作することもできます。たとえばこのblogでは次のようなfilter関数を利用してコメントをロードしています。</p>

<p>( 追記:2008-06-12 2:00 ) 時間情報で、１桁の値のものはゼロで埋めて表示させるようにfilter関数をやや修正しました。前から直そうと思いつつ放置してたのをやっと対処。</p>

<p><pre>
var f = function(bookmark){
		if(bookmark==null) return '';
		var d = [], published = bookmark.published;
		var fillByZero = function (num){
			return num&gt;10? '0'+num : num;
		};
		d.push('&lt;p id="' + bookmark.id + '"&gt;');
		d.push('&lt;span class="sbm-comment-name sbm-comment-type-' + bookmark.type + '"&gt;');
		d.push('&lt;a href="' + bookmark.link + '"&gt;' + bookmark.author + '&lt;/a&gt;');
		d.push('&lt;/span&gt;');
		d.push('  &lt;span class="sbm-comment-date"&gt;' + published.year + '-' + fillByZero(published.month) + '-' + fillByZero(published.day) + ' ' + fillByZero(published.hour) + ':' + fillByZero(published.minute) + '&lt;/span&gt;');
		d.push('&lt;/p&gt;');
		d.push('&lt;p class="sbm-comment-description"&gt;' + bookmark.comment + '&lt;/p&gt;');
		return d.join('');	
};
SBMComment.load( { area : 'sbm-comment-cont', nums : 'sbm-comment-num', filter : f } );
</pre></p>

<p>各bookmarkオブジェクトは、いろんなフィールドを持っているのでそれを好みのHTML要素に振り分けをしているfilter関数を用意します。bookmarkオブジェクトは次のようなフィールドを持っています。<p>

<p><ul>
<li>id : コメントID, 一意な値</li>
<li>type : SBMの種類, 「hatena」「delicious」「livedoor」「buzzurl」のいずれかの文字列</li>
<li>author : コメントを行った人の名前</li>
<li>published : コメントを行ったときの日時オブジェクト, day,day_of_week, hour, minute, month, second. timezone, utime, yearのプロパティをもつ </li>
<li>comment : コメントの内容</li>
<li>tags : ブックマーク時のタグ</li>
<li>link : ブックマークページ</li>
</ul></p>

<p>また、総ブックマーク数を表示したい場合は、表示したい場所のIDを引数オブジェクトのnumsプロパティで設定します。上の例だと「sbm-comment-num」で指定しています。</p>

<p>主な使い方はこんなかんじです。特にライブラリ依存はしていない素直なJSONPのコードなので、いろんなライブラリがロードされていても大丈夫なはずです。なんかバグとか不具合とかあったら教えてください。ライセンスはYahoo Pipes使ったもののライセンスがどうなっているのか、元の作者の方がどのようなライセンス形態をとっているのか、なんかが不明なため、とりあえずMITライセンスにしておきます。(これも問題あったら変更します)</p>

<p>( 追記:2008-04-27 2:00 )このへんの表現の仕方で一番奇麗だなーと思うのは<a href="http://natalie.mu">natalie</a>のコメント欄。たとえば<a href="http://natalie.mu/news/show/id/6735">これ</a>。</p>

<p>ここは記事に対するコメントとSBM経由のコメント、Twitter経由のコメントを全部透過的に同じレベルで扱っているのが素敵な感じ。ここまで一気通貫したものの方こそ、目指したかったゴールですかねー。</p>


