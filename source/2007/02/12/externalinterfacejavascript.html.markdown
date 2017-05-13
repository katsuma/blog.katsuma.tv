---
title: ExternalInterfaceを使ったFlashの呼び出し元制御
date: 2007/02/12
tags: actionscript, javascript
published: true

---

ActionScriptでExternalInterfaceを利用するとActionScriptからJavaScriptを呼び出せることができるのですが、普通に使うとJavaScript側で関数定義を行っておく必要があります。


たとえばActionScript側で
<blockquote>var ua = ExternalInterface.call("getUserAgent");</blockquote>

のように呼び出し、JavaScript側で

<blockquote>function getUserAgent(){
 return navigator.userAgent;
}
</blockquote>

のような定義を行っておく必要があります。


あるに決まってます。。と今日の今日まで思ってたのですが、よく考えたらcallの引数って無名関数でもOKな、はずなんですよね。実はこれって結構便利。



たとえば先に書いたコードはこんな感じで書き換えられます。


<blockquote>var ua = ExternalInterface.call("function() { return navigator.userAgent }");
</blockquote>


こうすりゃわざわざJavaScript側で関数を定義する必要もなく、手軽にJavaScriptを呼び出せます。


あと、ブラウザの機能を使うときにActionScriptだけでは難しいことも、JavaScriptを使えば楽にできることは多々あるのですが、無名関数で呼び出すことでコードの隠蔽も可能になります。


つまり、swfにJavaScriptを埋め込むことでユーザ側にコードを見られることも（ほぼ、ある程度、）防ぐことができ、swfの呼び出し元制御による不正利用も防ぐことが可能になります。


たとえば

<blockquote>var clientHost : String = ExternalInterface.call ("function() { return window.location.hostname }").toString ();
if(clientHost.indexOf("hoge.com")==-1){
 trace("呼び出し元が不正です！");
}
</blockquote>


なんてことも可能となります。


JavaScript側でhostname取得関数を定義しておくと、ユーザ側で上書き定義されたJavaScriptを用意＋勝手に作ったHTMLで不正利用なんかも簡単にできちゃいますが、無名関数を使ってswfに埋め込むことで、それについてもある程度回避は可能になるわけですね。
