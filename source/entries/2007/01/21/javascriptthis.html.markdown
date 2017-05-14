---
title: JavaScriptにおける"this"
date: 2007/01/21 18:19:27
tags: javascript
published: true

---

<p>仕事で最近マジメにJavaScriptでOOPな開発をしています。<br />
言わずもがなJavaScriptはオブジェクト指向な言語ではありますが、JavaやC#のようなクラスベースなオブジェクト指向ではなく、プロトタイプベースなオブジェクト指向言語です。</p>

<p>
このあたりの話は自分の手でコードを書いたことはなくとも、理屈では分かっていた「つもり」だったので「ほうほう」と適当に流していたのですが、いざ自分で書いてみると相当ハマるハメになりました。
ちょっとまだ理解は完璧ではないのですが、備忘録としてここに記しておきたいと思います。</p><br />


<p>こんなことをしたい、と仮定します。</p>

<p>
・./foo.phpにGETでリクエストを投げる<br />
・レスポンスを受け終わるとshowComplete関数をコールバック<br />
・「Complete!!」と表示する</p><br />

<p>
まーよくありがちな流れです。<br />
僕も何度もこんなコードは書いたことはありましたが、ちょっとオブジェクト指向を意識して書いた途端、まったく動作しなくなってしまいました・・・。</p><br />

<p>
さて、次のコードがその動かないコードなのですが、どこが動かないかすぐに分かりますか？<br />
ちなみに要prototype.jsです。</p><br />

<xmp style="font-size:80%">
 var Foo = Class.create();
 Foo.prototype = {
	url : "./foo.php",
	initialize : function(){
		try{
			var ajax = new Ajax.Request(
				url , 
				{
					method: 'get', 
					parameters: '',
					onComplete : showComplete
				}
			);
		} catch(e){	
		}
	},
	showComplete : function(){
		document.title='Complete!!';
	}
};

// 実行
Event.observe(window, 'load', function(){
	var foo1 = new Foo();
}, false);
</xmp>

<p>ダメな点は２つあります。</p>

<p>
まず、</p>
<br />

<xmp>
var ajax = new Ajax.Request(url , ...);
</xmp>
<p>ではなく、</p>
<xmp>
var ajax = new Ajax.Request(this.url , ...);
</xmp>
<p>と、なります。</p>

<p>
変数urlはFooのプロパティとして存在しているのでグローバル参照じゃダメなのですね。<br />
（JavaScriptの場合、グローバル参照はwindow.<property>と等価です）</p>

<p>このテのコードを書くときはいままでurlなんかはグローバルに定義していたのでハマることはなかったのですが、OOPで実装した途端、まずここでハマりました。<br />
でも、まだダメなんですね。</p><br />

<p>showCompleteの呼び出し方なのですが、先ほどと同じようにthis.showCompleteとしてもダメです。<br />
なぜなら、このコールバックの呼び出し元はイベント発生源であるAjaxオブジェクトであるので（*）、ここでのthisはAjaxオブジェクトを指しています。当然のごとくshowCompleteなんて関数は定義されていないのでここでエラーが出るなり、コールバックが失敗に終わって延々と何も起こらない状態が続いてしまいます。</p><br />

<p>（*）ここが肝なのですが、JavaScriptの場合（と、いうかECMAScript？）「this」のスコープは関数を呼び出したオブジェクトに設定される仕様になっています。なので、闇雲の「this」参照すると、ツボにハマることになります。</p><br />

<p>じゃぁ、どうするかというと、ここでのthisのスコープをズラす必要があります。<br />
イベント登録時にクラスFooの定義時に使用しているthisの参照を指定してあげることで、想定通りのthisが渡ります。prototype.jsではこのちょっと面倒な概念をシンプルにしてくれるbind関数が用意されてあるので、それを使ってあげるとこんな形で書けます。</p>

<p>
<xmp>
onLoading : this.showComplete.bind(this)
</xmp>
</p><br />

<p>これで想定したとおりの、つまり、FooオブジェクトのshowComplete関数が呼び出されます。<br />
（コレは相当ハマった）</p><br />

<p>まとめるとこんな感じになります。</p><br />


<xmp style="font-size:80%">
 var Foo = Class.create();
 Foo.prototype = {
	url : "./foo.php",
	initialize : function(){
		try{
			var ajax = new Ajax.Request(
				this.url , 
				{
					method: 'get', 
					parameters: '',
					onComplete : this.showComplete.bind(this)
				}
			);
		} catch(e){	
		}
	},
	showComplete : function(){
		document.title='Complete!!';
	}
};
</xmp>

<br />

<p>JavaScriptはなかなか奥が深いです。。。クラスベースの言語に慣れているとこの「thisのスコープ移動」にはなかなか理解するのに苦労しました。
とは言え、JavaScriptもまだまだ書く機会は相当多い言語ではあるので、もっと理解を進めたいと思いますよ！</p>
