---
title: YSlow対策でmod_expiresを利用してHTTPレスポンスヘッダにExpiresを追加する
date: 2007/07/31
tags: apache
published: true

---

<p>YSlowの評価に対する改善シリーズ、その2です。mod_deflateを利用してHTTPレスポンスを圧縮させる方法は<a href="http://blog.katsuma.tv/2007/07/yslow_apache_mod_deflate.html">こちら</a>から。</p>

<p>
<ul>
<li><a href="http://blog.katsuma.tv/2007/07/yslow_apache_mod_deflate.html">YSlow対策でmod_deflateを利用してHTTPレスポンスをgzip圧縮</a></li>
</ul>
</p>

<p>前回で、総合ポイントが「F」だったサイトをレスポンス圧縮することで、総合ポイントを「D」にまで上げることができました。今回は、残りの「F」項目の中の「Add an Expires header」についての処理を行いたいと思います。</p>

<p><a href="http://developer.yahoo.net/blog/archives/2007/05/high_performanc_2.html">YSlowの公式サイト</a>によると、「リッチサイトはCSSやらJSやら多くのファイルをロードするために、リクエスト回数も増えちゃうよね。でも変更が少ないファイルについてはExpiresヘッダを追加することで、ユーザにキャッシュさせ、リクエスト回数を減らすことができるよ（大雑把な意訳）」と、あります。つまり、Apache側でExpiresヘッダをレスポンスに追加することで、「このファイルは、xx日までは再リクエストしなくてもいいよ」なルールを決めることができます。このルールを追加することができるのが、<strong>mod_expires</strong>になります。</p>

<p>Expiresのルールは各サイトのポリシーにもよると思いますが、基本的には静的なファイル、更新されることがほとんど無いファイルがそれにあたります。具体的に言えば、gif/jpgなんかの画像ファイル、JS、CSSファイルなんかがそれに当たると思います。とは言え、いきなりガッツリとキャッシュさせてしまうのも、正直不安なところがあります。なので、最初はキャッシュさせる期間は少なめにして、問題なさそうなのを見計らいながら段階的に期間を延ばしていくのがベターかと思います。</p>

<p>具体的にmod_expiresの設定を行う場合は、次のようになります。</p>

<p>例のようにhttpd.confを編集します。まずは「1日分」だけキャッシュさせることにします。</p>

<p>
<pre>
LoadModule expires_module modules/mod_expires.so

ExpiresActive On

ExpiresByType text/css "access plus 1 days"
ExpiresByType application/x-javascript "access plus 1 days"
ExpiresByType image/jpeg "access plus 1 days"
</pre>
</p>

<p>1行目は、mod_expiresをLoad、3行目でExpiresヘッダの追加を有効にしています。5行目以降はMIMEタイプでExpiresヘッダを追加させるファイルを指定しています。今回は出力されるHTMLは動的なサイトを対象としていたため、Expiresヘッダを追加するファイルはCSS、JS、JPGファイルのみにしています。これらの設定を追加した上で、apacheをリスタートさせ、YSlowで測定してみると</p>

<p>
<blockquote><strong>D　3. Add an Expires header
These components do not have a far future Expires header:
(7/31/2007) http://xxxxxx.jpg
</strong></blockquote>
</p>

<p>と、なり、Expiresヘッダが追加されたことに一応の評価はしてくれたものの「もっと頑張れないのか？？」と問い詰められ、「D」の評価をされます。うーん、1日だとどうも短いようです。では3日ではどうでしょうか？httpd.confを修正してみます。</p>

<p>
<pre>
ExpiresByType text/css "access plus 3 days"
ExpiresByType application/x-javascript "access plus 3 days"
ExpiresByType image/jpeg "access plus 3 days"
</pre>
</p>

<p>これで、リスタートをかけてみます。すると</p>

<p><pre><strong>A</strong> 3. Add an Expires header</pre></p>

<p>と、いうわけで、Expiresヘッダの項目について、晴れて<strong>「A」評価になりました！</strong>。また、全体の評価もこれで「D」から<strong>「B」</strong>に格上げされました！どうもYSlowのExpiresの評価基準はこのあたりにあるようです。</p>

<p>このように、mod_deflateの場合と同様に、mod_expiresを有効にして、少しの手間でグっとリクエスト数を減らすことができます。特に画像を多く利用しているサイトでしたら、このテクはかなり有効かと思います。ちなみに、「あ、やっぱファイルに対して修正をかけたい！！」なんて場合はどうすればいいのでしょうか？ユーザにリロードを促さないとダメなのでしょうか？こんな場合はQueryStringを追加してあげることで、別のファイルだと強制的に見なしてあげればOKです。たとえば、hoge.jpgを再読み込みしてもらいたいときは</p>

<p><pre>
&lt;img src="./images/hoge.jpg" alt="hoge" /&gt;
</pre></p>

<p>を</p>

<p><pre>
&lt;img src="./images/hoge.jpg<strong>?070731</strong>" alt="hoge" /&gt;
</pre></p>

<p>の、ように<strong>「?任意の文字列」</strong>（QueryString）をファイル名に追加することで、強制リクエストを促すことができます。これもなかなか使えるテクなので知っておいて損ではないと思います。（FirefoxでFlashのキャッシュが残っちゃう場合なんかによく利用していました）</p>

<p>なお、今回は次のサイトを参考にさせていただきました。参考にさせていただいたサイトの方々、どうもありがとうございました。</p>

<p>
<ul>
<li><a href="http://labs.unoh.net/2007/06/mod_expires_mod_rewrite.html">mod_expires と mod_rewrite を使ってウェブサーバへのアクセスを減らす方法</a></li>
<li><a href="http://www.inter-office.co.jp/contents/183">Webサイトの高速化 ルール3　Expiresヘッダーを追加しよう! (Yahoo! developer netoworkより翻訳)</a></li>
</ul>
</p>
