---
title: YSlow対策でmod_deflateを利用してHTTPレスポンスをgzip圧縮
date: 2007/07/30 23:56:16
tags: apache
published: true

---

<p>もう、いろんなニュースサイトで言われていますが、
Yahooからページパフォーマンス計測ツールの「<a href="http://developer.yahoo.com/yslow/">YSlow for Firebug</a>」が
リリースされました。Firebugをインストールしている上で、YSlowをインストールすると、Webサイトの高速化を行うためのポイントと、
現状についてのポイント表示を行ってくれます。</p>

<p>これ、実際に試してみるとよく分かるのですが、いかに工夫をしていないサイトは、改善の余地があり余っているか。。
ほんと身を引き締められます。ちなみにYSlowでは次の項目をポイントに挙げています。</p>

<blockquote>
<p>
<ol>
<li>Make Fewer HTTP Requests</li>
<li>Use a Content Delivery Network</li>
<li>Add an Expires Header </li>
<li>Gzip Components</li>
<li>Put CSS at the Top</li>
<li>Move Scripts to the Bottom</li>
<li>Avoid CSS Expressions</li>
<li>Make JavaScript and CSS External</li>
<li>Reduce DNS Lookups</li>
<li>Minify JavaScript</li>
<li>Avoid Redirects</li>
<li>Remove Duplicate Scripts</li>
<li>Configure ETags</li>
</ol>
</p>
<p><a href="http://developer.yahoo.com/yslow/help/">YSlow User Guide</a>より抜粋</p>
</blockquote>

<p>これらの観点から、総合的なポイントを算出してくれます。最も良いのがAランクで、最も悪いのがFランク。
自分のサイトはどうだろう？と、いうわけで直近で仕事で作っていたサイトを計測してみると<strong>「F」</strong>でした。。。orz
ちなみにGoogle.comは「A」、Yahoo.comで「B」、Yahoo.co.jpで「C」でした。
Yahooも国内外でランクが違うのはなかなか興味深いです。また、CSS＋JavaScriptガリガリのサイトの場合、結構工夫していないと、
すぐにランクは落ちてしまうと思います。みなさんも自サイトは要チェック！</p>

<p>さて、仕事サイトが「F」だったのですが、「F」のままだとWeb屋としてちょっとシャクですし、手直ししてみたいと思います。
自分の場合、各項目については、こんな結果でした。</p>

<p>
<ol>
<li>B : Make Fewer HTTP Requests</li>
<li>F : Use a Content Delivery Network</li>
<li>F : Add an Expires Header </li>
<li>F : Gzip Components</li>
<li>A : Put CSS at the Top</li>
<li>C : Move Scripts to the Bottom</li>
<li>A : Avoid CSS Expressions</li>
<li>n/A : Make JavaScript and CSS External</li>
<li>A : Reduce DNS Lookups</li>
<li>C : Minify JavaScript</li>
<li>A : Avoid Redirects</li>
<li>A : Remove Duplicate Scripts</li>
<li>F : Configure ETags</li>
</ol>
</p>

<p>これで総合で<strong>「F」</strong>です。。。うーん、悔しい！まずは各項目の中から、「F」である項目から対処していきたいと思います。
（数が多すぎて）どれから手をつけてもいいのですが、今回は「Gzip Components」について、対応してみたいと思います。</p>

<p>これは要するにHTTPのレスポンスを圧縮することで、レスポンスを速くしよう！という狙いです。
Apache2.0, 2.2系統なら<a href="http://httpd.apache.org/docs/2.2/ja/mod/mod_deflate.html">mod_deflate</a>を
利用することでレスポンスの圧縮が可能です。
ちなみにApache2.2系からはmod_filterがどうも推奨されているようなのですが、まとまった情報が少なかったので、
今回はmod_deflateを利用してみることにします。</p>

<p>対応方法は非常に簡単。httpd.confについて次の項目を追記します。</p>

<p>
<pre>
LoadModule deflate_module modules/mod_deflate.so

&lt;Location /&gt;
SetOutputFilter DEFLATE
BrowserMatch ^Mozilla/4 gzip-only-text/html
BrowserMatch ^Mozilla/4\.0[678] no-gzip
BrowserMatch \bMSI[E] !no-gzip !gzip-only-text/html
SetEnvIfNoCase Request_URI\.(?:gif|jpe?g|png)$ no-gzip dont-vary
Header append Vary User-Agent env=!dont-vary

AddOutputFilterByType DEFLATE text/html
AddOutputFilterByType DEFLATE text/plain
AddOutputFilterByType DEFLATE text/css
AddOutputFilterByType DEFLATE text/xml
AddOutputFilterByType DEFLATE application/x-javascript
AddOutputFilterByType DEFLATE application/xml
AddOutputFilterByType DEFLATE application/rdf+xml
&lt;/Location&gt;
</pre>
</p>

<p>Locationのところは各環境に合わせてください。ある階層のみに対応させる場合はDirectoryとかでもいいと思います。
上記の前半は、圧縮についての全般的なルールです。圧縮を可能に、gzip圧縮を扱うことができない古いブラウザからのリクエストについては、
圧縮したレスポンスを返さない、画像ファイルについては圧縮しても無意味（すでに圧縮されているデータ）なので圧縮しない、
などの設定になります。</p>

<p>後半は、圧縮対象のファイルをMIMEタイプによって指定しています。
上記では全部バラして書きましたが、少し冗長なのでこんな書き方でもOKです。</p>

<p>
<pre>
AddOutputFilterByType DEFLATE text/html text/plain text/css text/xml application/x-javascript...
</pre>
</p>

<p>さて、これでhttpdを再起動させて、実際に圧縮できているかどうか確認します。
確認はYSlowのFirebug上の「YSlow」タブの「Performance」で、「Gzip components」の箇所を確認するのもいいですし、
もっと細かな圧縮量が知りたい場合は、
<a href="http://www.port80software.com/surveys/top1000compression/#checkyoursite">このサイト</a>から
確認することも可能です。
調べ方はとても簡単で、調査対象URLを入れて「go」を押すだけでOK。
ちゃんとgzipされたレスポンスを返した場合は、「圧縮後/圧縮前」のそれぞれのサイズを算出してくれます。</p>

<p>では、さっき「F」だった、つまりレスポンス圧縮について何も対応していなかった僕のサイトを入れてみると、</p>

<p>
・圧縮前：12754 bytes→<br />
・圧縮後：3608 bytes
</p>

<p>というわけで<strong>72.0%</strong>も圧縮されました！！（ちょっと予想以上の圧縮に笑ったw）
また、YSlowの評価もgzipの項目が「F」から一気に「A」になりました。あわせて総合ランクも「F」から「D」に上がりました！</p>

<p>と、いうわけで、ほんの少し手を入れてあげるだけでグーンと効果があるので、mod_deflateをまだ試していないWeb屋さんは、ぜひ検討をば。
もちろん圧縮についてはCPUを食うので、現状でWebサーバのCPUリソースを結構消費している場合は要検討ですよ。</p>

<p>また、あわせてチェックしておきたいこととして、mod_deflateは圧縮アルゴリズムに少しクセがあるようです。
最初上記の設定ではHTMLファイルの圧縮についてはすんなりいったのですが、
<strong>JavaScript、CSSファイルのレスポンスは全く圧縮されませんでした。</strong>
（この場合、YSlowの評価は、「まだまだJS, CSSファイルが頑張れるはず！」と、いうわけでgzipの項目は「D」ランクでした。）
ところが、特に設定を変えることなく何回かアクセスを行っていると、これらのファイルも圧縮されるようになりました。
このあたりは<a href="http://www.shudo.net/diary/2007jul.html#20070727">CTOとも話していた</a>のですが、
どうもこんな仮説が浮かびました。</p>

<p>
<ul>
<li>「どうも毎回確実に圧縮するのではないかも？」</li>
<li>「ファイルサイズによって圧縮効率がありそうか無さそうかを考えている？」</li>
<li>「リクエストが多い、一定以上のファイルが圧縮対象になる？？」</li>
</ul></p>

<p>うーん、、まだまだ謎です。時間があったらmod_deflateのソースを呼んでみたいなぁ、、とも思っていますが、
この辺りの項目については、今のところ未確認です。もしかしたら僕の設定ミスがあったのかもしれませんが、
上記項目について、もしご存知の方がいらしたら、教えていただければと思います。</p>

<p>[ 追記 ] 2007/07/31 14:00<br />
今回のエントリーに関してはこれらの記事を参考にさせていただきました。
<ul>
<li><a href="http://zapanet.info/blog/item/961">ファイルを圧縮するmod_deflateの効果</a></li>
<li><a href="http://www.inter-office.co.jp/contents/184">Webサイトの高速化 ルール4　コンポーネントを圧縮しよう! (Yahoo! developer netoworkより翻訳)</a></li>
</ul>
<p>参考にさせていただいたサイトの方々、どうもありがとうございました。</p>
</p>

<p>[ 追記 ] 2007/08/05 17:18<br />
コメントでかつきちさんから、css/JavaScriptのgzipについて、</p>
<pre>
SetEnvIfNoCase Request_URI\.(?:gif|jpe?g|png)$ no-gzip dont-vary
</pre>
<p>ではなく、</p>
<pre>
SetEnvIfNoCase Request_URI "\.(?:gif|jpe?g|png)$" no-gzip dont-vary
</pre>
<p>だと、早く圧縮された、との報告もありました。この方法を試してみるのも手かもしれません。<br />
（かつきちさん、ご報告ありがとうございました！）
</p>
