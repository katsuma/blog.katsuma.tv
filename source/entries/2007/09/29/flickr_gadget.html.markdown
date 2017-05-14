---
title: Flickrの最新画像表示ガジェット
date: 2007/09/29 16:46:25
tags: gadgets
published: true

---

<p>(追記 : 09/02/12) ソースは<a href="http://github.com/katsuma/flickr-gadget/tree/master">githubでホスティング</a>することにしました</p>

<p>このBlogはトップページに僕のFlickrの最新画像を6枚表示しています。これはFlickrが昔公式Blogパーツとしてscriptタグを埋め込むと表示されるもの、として公開していたものなのですが、いつのまにやら膨大なHTMLコードを埋め込むバージョンに差し換わっていました。</p>

<h3>埋め込みコードとして複雑！</h3>
<p>個人的な意見として、こういうBlogパーツ、ガジェット埋め込みコードは可能なかぎり短く簡潔なコードにすべきだと思っています。あくまでも「飾り」のものなので、わざわざ大層なstyleタグやHTMLコードを大量に要するべきではないと思っています。</p>

<p>ところが、Flickr標準のFlashBlogパーツ埋め込みコードといえば</p>

<p><pre>
&lt;style type="text/css"&gt;
.zg_div {margin:0px 5px 5px 0px; width:117px;}
.zg_div_inner {border: solid 1px #000000; background-color:#ffffff;  color:#666666; text-align:center; font-family:arial, helvetica; font-size:11px;}
.zg_div a, .zg_div a:hover, .zg_div a:visited {color:#3993ff; background:inherit !important; text-decoration:none !important;}
&lt;/style&gt;
&lt;script type="text/javascript"&gt;
zg_insert_badge = function() {
var zg_bg_color = 'ffffff';
var zgi_url = 'http://www.flickr.com/apps/badge/badge_iframe.gne?zg_bg_color='+zg_bg_color+'&zg_person_id=44124397399%40N01';
document.write('&lt;iframe style="background-color:#'+zg_bg_color+'; border-color:#'+zg_bg_color+'; border:none;" width="113" height="151" frameborder="0" scrolling="no" src="'+zgi_url+'" title="Flickr Badge"&gt;&lt;\/iframe&gt;');
if (document.getElementById) document.write('&lt;div id="zg_whatlink"&gt;&lt;a href="http://www.flickr.com/badge.gne"	style="color:#3993ff;" onclick="zg_toggleWhat(); return false;"&gt;What is this?&lt;\/a&gt;&lt;\/div&gt;');
}
zg_toggleWhat = function() {
document.getElementById('zg_whatdiv').style.display = (document.getElementById('zg_whatdiv').style.display != 'none') ? 'none' : 'block';
document.getElementById('zg_whatlink').style.display = (document.getElementById('zg_whatdiv').style.display != 'none') ? 'none' : 'block';
return false;
}
&lt;/script&gt;
&lt;div class="zg_div"&gt;&lt;div class="zg_div_inner"&gt;&lt;a href="http://www.flickr.com"&gt;www.&lt;strong style="color:#3993ff"&gt;flick&lt;span style="color:#ff1c92"&gt;r&lt;/span&gt;&lt;/strong&gt;.com&lt;/a&gt;&lt;br&gt;
&lt;script type="text/javascript"&gt;zg_insert_badge();&lt;/script&gt;
&lt;div id="zg_whatdiv"&gt;This is a Flickr badge showing public photos from &lt;a href="http://www.flickr.com/photos/44124397399@N01"&gt;katsuma&lt;/a&gt;. Make your own badge &lt;a href="http://www.flickr.com/badge.gne"&gt;here&lt;/a&gt;.&lt;/div&gt;
&lt;script type="text/javascript"&gt;if (document.getElementById) document.getElementById('zg_whatdiv').style.display = 'none';&lt;/script&gt;
&lt;/div&gt;
&lt;/div&gt;
</pre></p>

<p>と、かなり膨大なコードとなっています。</p>

<p>カスタマイズ性は確かに高いのですが、埋め込みコードとしてはなんとかこれを隠蔽できないのかなーと思わずにはいられません。<p>

<h3>レンダリングをとめないで！</h3>
<p>Flickrはレスポンスは必ずしも速いと思いません。LDRのサクサク感と比較したら雲泥の差。サイト自体は高機能で使いやすいのですが、画像のロードは重いので、BlogパーツもHTML内でロードするコードが埋め込まれていると、そこでHTMLのレンダリングが止まってしまい、ユーザにイライラ感をつのらせてしまいます。</p>

<p>これを防ぐ方法として、せめて関数呼び出しの方法を提供してくれれば、と思います。関数呼び出しができれば、windowがloadされたタイミング（レンダリングが終了した後）で呼び出せば、体感速度は増します。ところが、提供されてるBlogパーツの多くはまだまだそんな方法をとっているものは少なく、Blogパーツを貼れば貼るだけ、どんどんHTMLのレンダリングが重くなる悪循環を生み出しているものが多く見られます。</p>

<h3>とか言ってる自分のページも</h3>
<p>重いです。トップページは。それもFlickrの画像ロードだけにレンダリングがひっかかって、正直自分自身もイラっとしてました。</p>

<h3>でも、とりあえず写真は貼っておきたい</h3>
<p>なので、遅延ロードできるFlickr用Blogパーツを作成しました。貼り付けコードはこんな感じ。</p>

<p>
<pre>
&lt;script src="http://blog.katsuma.tv/js/flickr.js" type="text/javascript"&gt;&lt;/script&gt;
&lt;script&gt;
var param = {
	'username' : 'katsuma',
	'view_num' : 6
};
new Flickr.Gadget(param);
&lt;/script&gt;
</pre>
</p>

<p>こんな感じ。flickr.jsがロードされるライブラリ。paramのusernameがFlickrのユーザ名（これは必須）、view_numが表示枚数。view_numは指定しない場合は6がセットされます。このコードを埋め込んだ場所にdocument.writeでFlickr画像が表示されます。</p>

<p>paramには表示場所指定できるようにしました。areaを指定した場合、つまり&lt;div id="flickr_area"&gt;&lt;/div&gt;のようなタグをどこかに埋め込んだ後に</p>

<p>
<pre>
var param = {
	'username' : 'katsuma',
	'view_num' : 6,
	'area' : 'flickr_area'
};
</pre>
</p>

<p>なんかで指定してあげると、areaで指定した場所にinnerHTML書き換えで画像が表示されます。つまり、jsはHTMLの下部でロードしつつも特定の場所に画像を表示したい！なんてことも可能です。</p>

<p>ただし、これだけだと、window.load後に表示ができないので、prototypeなりjQueryなり、はたまたwindow.loadに直接上記のコードを指定してあげれば、遅延ロードが可能です。ここはユーザが好きな方法をとれるように、今のところ意図的にロジックに入れていません。たとえばこのサイトはprototype.jsのEvent.observeを使って</p>

<p>
<pre>
&lt;script&gt;
Event.observe(window, 'load', function(){
	var param = {
		'username' : 'katsuma',
		'view_num' : 6,
		'area' : 'flickr_area'
	};
	new Flickr.Gadget(param);

});
&lt;/script&gt;
</pre></p>

<p>こんな感じにしています。</p>

<p>「もうちとスタイルをいじりたい！」という人もいらっしゃるかもしれません。現状は、以前のガジェットと同じ仕様にしていて、</p>

<p>
<ul>
<li>全imgには class="flickrimg"を 追加</li>
<li>imgそれぞれには id="flickrimg<i>N</i>"(<i>N</i>は1,2...の通し番号)を追加</li>
</ul>
</p>

<p>と、いう仕様にしています。なのでCSSで表示位置の調整も可能かと思います。</p>

<p>さて、こんなものを作ってみたものの、かなり「オレオレガジェット」な感じは否めません、、、が、以前作った<a href="http://blog.katsuma.tv/2007/04/twitter_gadget_1.html">Twitterのひとことガジェット</a>も意外といろいろ好意的な意見も聞きましたので、使ってみたい方がいらっしゃれば、ご自由に利用いただければと思います。</p>
