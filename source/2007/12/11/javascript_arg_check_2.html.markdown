---
title: 変数の存在を確認する方法と速度比較（その２）
date: 2007/12/11
tags: javascript
published: true

---

<p>前回に「<a href="http://blog.katsuma.tv/2007/12/javascript_arg_check.html">関数の引数を存在確認するための高速化Tips</a>」と題したエントリーを書きましたが、その後に<a href="http://blog.gakkie.com/">gakkie</a>からいろいろ意見をいただきました。</p>

<blockquote>
<p>
@ryo_katsuma 露骨ってほどの差には見えないがw 条件文がtrueでも同じ結果になる？<三項演算子
</p>
<p><a href="http://http://twitter.com/gakkie/statuses/470029492">Twitter /  gakkie</a></p>
</blockquote>

<blockquote>
<p>
@ryo_katsuma ついでに、10万回で50msの違いっていうのはJSにおいて重要なのかがちょっと気になったお。</p>
<p><a href="http://twitter.com/gakkie/statuses/470820452">Twitter / gakkie</a></p>
</blockquote>

<p>あと、その後にチャットで話した結果、自分自身で納得したのですが、前回のエントリーで言いたかったことは<strong>「関数の引数うんぬんとかはどうでもよくて、"変数が存在するかどうか" を考えたとき、その確認方法によっては速度が変わることがある」</strong>と、いうことが一番言いたかったんだな、、ということに自己完結。また、確認方法についても「関数呼び出しを行う時間を含める/含めない、によっても純粋な判定時間とはずれる？」と、いう話にもなったり。</p>

<p>と、いうことで「関数呼び出しを含まない」「真偽の２パターン」を考慮してもう一度測定し直してみました。検証コードは次のとおり。</p>

<p>
<pre>
const LOOP = 10000000;
var start, end;

// logging
function log(){
	//return console.log.apply(this, arguments);
	return print.apply(this, arguments);
}



function checkStrTernary(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret = (arg=='foo')? arg : 'bar';
	}
	end = new Date();
	log('[checkStrTernary]\t' + (end-start));
}


function checkStrIf(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret;
		if(arg=='foo'){
			ret = arg;
		} else {
			ret =  'bar';
		}
	}
	end = new Date();
	log('[checkStrIf]\t'+ (end-start));
}


function checkArgsLogicalAdd(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret =  arg || 'bar';
	}
	end = new Date();
	log('[checkArgsLogicalAdd]\t ' + (end-start));

}
function checkArgsTernary(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret =  arg ? arg : 'bar';
	}
	end = new Date();
	log('[checkArgsTernary]\t ' + (end-start));

}
function checkArgsIf(arg){
	start - new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret;
		if(arg) {
			ret = arg;
		} else {
			ret = 'bar';
		}
	}
	end = new Date();
	log('[checkArgsIf] \t' + (end-start));
}


function checkNullTernary(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret = (arg!=null)? arg : 'bar';
	}
	end = new Date();
	log('[checkNullTernary] \t' + (end-start));
}

function checkNullIf(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret;
		if(arg != null){
			ret = arg;
		} else {
			ret = 'bar';
		}
	}
	end = new Date();
	log('[checkNullIf] \t' + (end-start));
}


function checkTypeTernary(arg){
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		var ret = (typeof(arg) != 'undefined')? arg : 'bar';
	}
	end = new Date();
	log('[checkTypeTernary] \t' + (end-start));
}

function checkTypeIf(arg){
	var ret;
	start = new Date();
	for(var i=0; i&lt;LOOP; i++){
		if(typeof arg != 'undefined'){
			ret = arg;
		} else {
			ret = 'bar';
		}
	}
	end = new Date();
	log('[checkTypeIf] \t' + (end-start));
}

/*
 * Testing
 */
(function(arg){
	checkStrTernary(arg);
 	checkStrIf(arg);
	checkArgsLogicalAdd(arg)
 	checkArgsTernary(arg);
	checkArgsIf(arg);
	checkNullTernary(arg);
 	checkNullIf(arg);
	checkTypeTernary(arg);
 	checkTypeIf(arg);
})(/*'foo'*/);
</pre>
</p>

<p>存在確認の中では関数呼び出しは行わないように。あと、コード簡単だから解説なんて必要ないと思いますけど、上から順番に</p>

<p>
<ul>
<li>文字列比較（三項演算子）</li>
<li>文字列比較（if文）</li>
<li>変数比較（論理和）</li>
<li>変数比較（三項演算子）</li>
<li>変数比較（if文）</li>
<li>null比較（三項演算子）</li>
<li>null比較（if文）</li>
<li>型比較（三項演算子）</li>
<li>型数比較（if文）</li>
</ul>
</p>

<p>それぞれ変数に何か値（か、fooの文字列の場合も含）があればtrue, 無かったらfalseの場合で比較。結果は次の通り。単位は1000万回実行したときの秒数です。実行環境はFedora7上のSpiderMonkeyです。</p>

<table cellspacing="0" cellpadding="3" border="1" id="tblMain_0" style="font-size: 10pt;" class="tblGenFixed"><tbody><tr><td style="height: 0px; width: 194px;" class="cAll"/><td style="height: 0px; width: 64px;" class="cAll"/><td style="height: 0px; width: 64px;" class="cAll"/></tr><tr><td class="g s0"/><td class="g s1">TRUE</td><td class="g s1">FALSE</td></tr><tr><td class="g s1">checkStrTernary</td><td class="g s2">4687</td><td class="g s2">4693</td></tr><tr><td class="g s1">checkStrIf</td><td class="g s2">4843</td><td class="g s2">4935</td></tr><tr><td class="g s1">checkArgsLogicalAdd</td><td class="g s2">3795</td><td class="g s2">3791</td></tr><tr><td class="g s1">checkArgsTernary</td><td class="g s2">3985</td><td class="g s2">3993</td></tr><tr><td class="g s1">checkArgsIf</td><td class="g s2">8275</td><td class="g s2">8400</td></tr><tr><td class="g s1">checkNullTernary</td><td class="g s2">4726</td><td class="g s2">4452</td></tr><tr><td class="g s1">checkNullIf</td><td class="g s2">4543</td><td class="g s2">4648</td></tr><tr><td class="g s1">checkTypeTernary</td><td class="g s2">5117</td><td class="g s2">5684</td></tr><tr><td class="g s1">checkTypeIf</td><td class="g s2">5422</td><td class="g s2">5469</td></tr></tbody></table>

<h3>考察</h3>
<p>前回と結局のところ内容はほぼ変わりませんが、面白い点もいくつかあります。</p>
<p><ul>
<li>同じ比較方法の場合、if文よりも三項演算子の方がやや速い</li>
<li>もっとも高速な方法は論理和を使う方法</li>
<li>もっとも時間がかかる方法は型比較をif文で行う方法</li>
<li>null比較、型比較で三項演算子を利用すると真偽によって速度が（割と）変わる</li>
</ul></p>

<p>三項演算子を使うと速さが変わるのは前回のエントリでHaraさんがTBくれて言及していただけました。</p>

<p>
<blockquote>
<p>
if文は「文」なのに対し、三項演算子は「式」なので、解釈系（インタプリタ）や翻訳系（コンパイラ）が分岐除去の最適化をしやすいんじゃないかと思います。</p>
<p><a href="http://blog.pa-n.com/2007/12/if.html">if文と三項演算子</a> - <a href="http://blog.pa-n.com/">Pa works</a></p>
</blockquote>
</p>

<p>文よりも単純な構成である式の方が分岐除去の最適化が効いてくるんじゃないか？な推測。うーん、コンパイラな下地がある方のお言葉はありがたい。。。あと、型比較やnull比較において真偽で時間に差がついてきちゃうのも、分岐除去にクセがあるのかもしれないですね。このあたりの話はSpiderMonkeyのソース読めば追いかけられるのかなぁ。今後ちゃんと読んでみよう。</p>

<p># そういえば、某大手Webサービスのエンジニアの中には、三項演算子マニア？がいるそうで、ほぼ全ての分岐は三項演算子で書くとか（！）</p>

<h3>ざっくりまとめ</h3>
<p>JavaScriptでは簡単な分岐なら三項演算子を積極的に使っても損は無いと思います。また変数の初期化なんかは論理和演算子での初期化も良さそう。</p>

<h3>他の言語</h3>
<p>解釈系、翻訳系で違いを見てみたいなぁ。翻訳系の方が直感的に考えても分岐除去の最適化を頑張ってくれてるはずなので、差が無いと思うんだけども。これも今度ベンチとってみよう。</p>
