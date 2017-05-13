---
title: サーバからの通知方法にfaviconの動的変更を利用する
date: 2008/03/23
tags: javascript
published: true

---

<p>GmailやLDRなどもそうですが、最近はWebアプリケーションでも「起動させっぱなし」を基本路線に置いているものも増えてきています。そういうときにポイントとなるのが「(サーバ側で変更が発生したときに)サーバからの通知をブラウザにどうやって知らせるか？」ということ。ブラウザでページを開かれている場合だと、変更箇所を専用のボックスエリアを設けて、適当に目立たせておけばいいのですが、別タブで開かれている場合などには、タブをユーザが切り替えるまでは、その変更を通知することができません。そんなときに、「差分の大きな複数のfavicon(*)を動的に変更させることで通知と同等の効果が期待できないか？」という話。(全然違うfaviconをアニメーションさせることで目立たせられないか？という狙い)</p>

<h3>faviconの変更は割と単純</h3>
<p>まずfaviconが動的に変更させることができないか？の検証ページを作ってみました。</p>
<p><ul><li><a href="http://lab.katsuma.tv/favicon/">Favicon test</a></li></ul></p>
<p>「change favicon」ボタンをクリックすることでfaviconのアイコンがサングラスをかけたりメガネをかけたりシャキシャキ入れ替わります。動作確認ブラウザはFirefox2.0.x,3.0b, Opera9.26のみ。Safari3.1やIE7は変化なし。</p>

<p>コードの元ネタは「<a href="http://softwareas.com/dynamic-favicon-library-updated">Dynamic Favicon Library Updated</a>」のページから。作者さんは専用のライブラリを作られているようだけどもjQueryだけでも何とかなるだろうと思ってコードをおっかけてたら何とかなった。仕掛けは単純でlink要素のhref属性で読み込んでいるfaviconのパスを動的に変更させているだけ。でも単純にhrefの値を変更させているだけだとダメで、<strong>一度link要素を削除して、その後にfaviconのパスを変更したlink要素を再挿入</strong>。これでちゃんと変更が認識されます。そのへんの話がこのあたり。</p>

<p><pre>
$('#favicon').remove();
$('meta:last').after($(document.createElement('link')).attr('id', 'favicon').attr('rel', 'shortcut icon').attr('href', icon));
</pre></p>

<p>要素の特定が面倒なのでfaviconを読んでいるlink要素には「favicon」IDをあらかじめ振っておいて、meta要素の最後に再挿入。どうでもいいけどjQueryで要素を動的に作成するための関数ってあるのかな？普段って要素特定ばかり使っているから、要素作成についての方法が地味に見つからなかった。</p>

<h3>window.blur, window.focusを拾う</h3>
<p>通知は他タブに切り替わっている場合のように、フォーカスがあたっていない場合は常に通知をし続けておきたい訳ですから、window.blur, window.focusイベントでうまく処理します。デモは
<a href="http://lab.katsuma.tv/favicon/">さっきのページ</a>で「alert by favicon」ボタンクリックで開始。ウィンドウにfocusがあたっている場合はfaviconが5回変更されて停止、focusがあたっていない場合はfaviconが変更され続けて、focusが当たった瞬間に停止します。説明難しいから実際に試していただいた方が早いか、と。</p>

<p>コードとしては、先に上げた例のものをベースにsetIntervalで回しているだけで、windowイベントをトリガにフラグを切り替えclearIntervalしている単純なものです。読んでみると分かるかな、というものです。そのへんの話がこのあたり。</p>
<p><pre>
function alertFavicon(){
	var isFocused=true, favID=0;
	$(window).focus(function(){isFocused = true});
	$(window).blur(function(){isFocused = false});	
	var timer = setInterval(function(){
		if(favID>10 && isFocused){
			clearInterval(timer);
			favID=0;
		}
		var icon = (favID%2==0)? 'http://lab.katsuma.tv/favicon/favicon2.ico': 'http://lab.katsuma.tv/favicon/favicon.ico';
		$('#favicon').remove();
		$('meta:last').after($(document.createElement('link')).attr('id', 'favicon').attr('rel', 'shortcut icon').attr('href', icon));
		favID++;
	}, 500);
}
</pre></p>

<h3>サーバサイドからの通知方法としては割と有効</h3>
<p>ここからは個人的感想にもなりますが、サーバサイドからの通知方法の1つとして、faviconを変更しつづけたアラート方法は割と有効なんじゃないかな、と思います。FxとOperaしか使えないものの、なかなか視覚的に訴えるものは大きいので、ユーザに新着情報をリーチさせる手段として検討してみてもいいんじゃないかな、と思いますよ。もちろん過度に使うとチカチカ動きすぎてうざったい印象をユーザに持たれてしまうので、そのあたりのバランス感覚は言わずもがな重要になってきます。</p>

<p>
（2008/03/24 11:50 追記）
皆さんからブクマ経由でいい反応をいただいてテンション上がってます。
IE, SafariでもFaviconを変更させるHackテクをご存知の方はぜひ教えていただきたいと思います。
（IEはどうもキャッシュが厳しそうなんですよねー）
</p>
