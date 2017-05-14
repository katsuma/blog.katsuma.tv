---
title: JSONPを定期実行する
date: 2007/03/27 02:06:17
tags: javascript
published: true

---

<p>
XHRはドメインを越えて通信ができないので、ドメインを越えてAJAXを行うときはXHR以外の方法を取る必要があります。<a href="http://hail2u.net/blog/coding/jsonp.html">JSONP</a>, iframeなんかの解決法があるかと思うのですが、今回はJSONPの話題をば。
</p>
<p>
JSONPとはJSONデータをcallbackさせたい関数名のパラメータとして受信し、scriptタグを動的生成することでクロスドメインでAJAX（ここまでくると当然XMLとかもはやどうでもいい）を実現する、、、ということなんですけど、文章で書くとワケわかりません。ので、実行コードを書くとこんな感じ。
</p>
<p>
<pre>
http://example.com/data.json?callback=view
</pre>
</p>
<p>
と、callbackさせたい関数名をパラメータに付けて(*1)リクエストを投げると
</p>
<p>
<pre>
view(
 { "state" : "good"}
);
</pre>
</p>
<p>
と、「<strong>callback_function( <em>JSON data</em>);</strong> 」な、形式で返してくれるものがJSONP。こいつのリクエストをXHRでかけるとドメイン越えでデータを受信できないので、scriptタグでJavaScriptをロードさせる要領でリクエストをかけることで、ドメイン越えしてJSONデータを受信する、、というもの。うーん、これ考えた人すごい。(*2)
</p>

<p>
で、このJSONPを定期実行させたい、ということもあるかと思います。要するに定期的にx秒毎に別ドメインにアクセスして最新の情報をゲットしたい、なんてとき。そこで微妙にハマったことがあったのでメモ。
</p>


<p>
単純に考えるとsetIntervalのパラメータにscript要素を追加するような関数を持たせればいいのですが、ポイントはscript要素の追加のさせ方。大きく分けると
</p>
<p>
・document.writeで要素を書き出し<br />
・DOMを利用してscript要素を追加挿入
</p>
<p>
の２つになるかな、と思います。
</p>
<p>
DOMはちょっと苦手なのでdocument.writeの方法をよく使う僕としてはこんな方法を当然のごとく考えました。
</p>
<p>
<pre>
function view(){
  // JSON処理
}
</pre>
</p>
<p>
こんな関数を定義しておいたあとで、次のような関数を定義、実行します。
</p>
<p>
<pre>

function loadSessions(){
  document.write('&lt;scr' + 'ipt type="text/javascript" src="http://example.com/service?callback=view"&gt; &lt;/scr' + 'ipt&gt;');
}

loadSessions(); // (1)
setInterval("loadSessions()", 5000); // (2)
</pre>
</p>
<p>
当然(1)が実行され、サクっと動いたので「よしよし」と思ったら、(2)のsetIntervalで２回目の実行に入ったときに<strong>「viewは定義されていません」</strong>のエラーが。
</p>
<p>
うーん？？？？？
</p>
<p>
これ謎です。setIntervalした後にコールバック関数のviewが上書きされてる or 消されている？ってこと？
</p>
<p>
Firebugで動的に書き換えられてるHTMLを監視していたのですが、setInterval以降、HTMLのソース表示部分が真っ白になってロックされてしまっているような状態で確認が取れませんでした。
（どなたかこの現象が説明できる方、教えていただけないでしょうか。。）
</p>
<p>
で、結局、この理由がよく分からないのでなかなか解決できなかったので、document.writeはあきらめてDOM操作の方法をとることに。上のloadSessions関数をこんな感じで再定義。
</p>
<p>
<pre>
function loadSessions(){
  var readSessionId = 'read';
  var api = "http://example.com/service?callback=view";
  var head = document.getElementsByTagName('head').item(0);

  if(document.getElementById(readSessionId)!=null){
    head.removeChild(document.getElementById(readSessionId));
  }
  var s = document.createElement('script');
  s.setAttribute('type', 'text/javascript');
  s.setAttribute('src', api);
  s.setAttribute('id', readSessionId)
  s.setAttribute('charset', 'UTF-8');
  head.appendChild(s);
}
</pre>
</p>
<p>
もう見たまんま。scriptタグに適当なIDをつけてappendしています。</p>

<p>
ここで、単純にappendするだけでsetIntervalすると、永遠にscript要素が挿入され続けてなんか気持ち悪い...ので、IDを元にscript要素を特定し、その要素を一度削除してから再挿入しています。ここ、applyとかevalとかうまく使うともうちょっと綺麗なコードになるかも？しれません。ここもいい方法あったらぜひ教えていただきたいです。</p>

<p>
で、こっちのDOM操作だとsetIntervalもcallbackがちゃんと実行されました。うーんdocument.writeとなんでここまで挙動が違うのか謎。。だけど、とりあえずJSONPのテクとしてメモメモ。</p>

<p>
</p>
<p>
---</p>

<p>
(*1) 当然のごとくサービス提供側はよくわからない<strong>「関数名っぽいもの」</strong>をパラメータに付けられる可能性があるので、内容チェックは必須。<a href="http://developer.yahoo.com/common/json.html">Yahoo! では [A-Za-z0-9_\.\[\]] に制限されています。</a>うん、納得。</p>

<p>
(*2) 「ドメイン越えするAJAX」=「JSONP」という図式がなんとなくいろんなサイトの説明で見たり、このエントリーもそんな書き出しをしているけど、これって本当はちょっとズレてる？はず。<a href="http://code.google.com/apis/gdata/json.html">GoogleはJSON-in-Scriptなんて名前で呼んでたりするみたい</a>だけど、名前と意味的にはこっちの方が正しいと個人的には思う。
</p>
