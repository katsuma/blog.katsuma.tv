---
title: JavaScriptの定数宣言は高速化につながるか？
date: 2007/10/30
tags: javascript
published: true

---

<p>JavaScriptでFirefoxがconst(定数宣言)をサポートしていることをフと思い出しました。で、定数宣言って速度向上とかにつながるのかな？思ってついカッとなってベンチマークとるコードをかいてみました。こんな感じ。</p>

<pre>
&lt;html&gt;
&lt;head&gt;&lt;title&gt;const test&lt;/title&gt;&lt;/head&gt;
&lt;body&gt;
&lt;script&gt;
	window.load = monitor();
	
	function monitor(){
		var A = "TestA";
		const B = "TestB";

		var Klass = {
			C : "TestC"
		};

		// 1st test
		var start = new Date();
		for(var i=0; i&lt;10000000; i++){
			var b = A;
		}
		var end = new Date();
		console.log("A:" + (end-start));

		// 2nd test
		var start = new Date();
		for(var i=0; i&lt;10000000; i++){
			var b = B;
		}
		var end = new Date();
		console.log("B:" + (end-start));

		// 3rd test
		var start = new Date();
		for(var i=0; i&lt;10000000; i++){
			var b = Klass.C;
		}
		var end = new Date();
		console.log("C:" + (end-start));	
	}
&lt;/script&gt;
&lt;/body&gt;&lt;/html&gt;
</pre>

<p>1000万回ループで回してグローバル変数、定数宣言した変数、static変数にアクセスして、そのアクセス時間を比較。結果はこんな感じでした。</p>

<h3>測定結果</h3>
<p>
<table border="1">
<tr>
<td>Test</td><td>msec</td>
</tr>
<tr>
<td>A(グローバル変数)</td><td>2333</td>
</tr>
<tr>
<td>B(定数)</td><td>2323</td>
</tr>
<tr>
<td>C(クラス変数)</td><td>2935</td>
</tr>
</table>
</p>

<h3>結局</h3>
<p>グローバルに宣言した場合、普通の変数も定数もアクセス時間に違いはほとんど無いようで。1000万回アクセスして10msec程度しか違わないので、普通にコード書く分には無視できそうです。あと、変数をオブジェクトに収めたほうが遅くなってるのは理由がよく分かってません。。実行時アクティベーションオブジェクトの初期化とかそんな話までなっちゃってるのかな？（<a href="http://d.hatena.ne.jp/amachang/20060924/1159084608">このあたり</a>気になった）</p>

<p>と、いうわけで結論としては、constは<strong>変数をreadonlyにするだけ</strong>、ということになるのかな。詳しい方いらしたら教えてください！</p>
