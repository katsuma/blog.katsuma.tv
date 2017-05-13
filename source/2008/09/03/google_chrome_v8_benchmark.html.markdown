---
title: Google ChromeのJavaScriptエンジンV8の性能評価
date: 2008/09/03
tags: javascript
published: true

---

<p>唐突にリリースされたGoogleブラウザこと<a href="http://www.google.com/chrome">Google Chrome</a>ですが、HTMLのレンダリングエンジンこそWebKitながらも、JavaScriptエンジンは自社で作ったもののようです。これは<a href="http://code.google.com/p/v8/">V8</a>という名前のものでオープンソースプロジェクトとしてGoogle Codeにホスティングされています。</p>

<p>そんなV8ですが、ベンチマークを測定できるページが用意されています。</p>

<p><a href="http://code.google.com/apis/v8/run.html">V8 Benchmark Suite - version 1</a></p>

<p>ざっくり言うとスコアが高ければ高いほうがエンジンとしては性能がよさそう。内容としては</p>

<p><ul>
<li>OS kernel simulation benchmark(Richards)</li>
<li>One-way constraint solver(DeltaBlue)</li>
<li>Encryption and decryption benchmark(Crypto)</li>
<li>Ray tracer benchmark(RayTrace)</li>
<li>Classic Scheme benchmarks(EarleyBoyer)</li>
</ul></p>

<p>とのこと。実際のコードは見てないけどとりあえずいろんなブラウザで試してみたらこんな結果でした。おおむね最新ブラウザのみでの計測。IEだけbeta版なのはスミマセン。</p>

<h3>Google Chrome</h3>
<h4>Score: 986</h4>
<ul>
<li>Richards: 1270</li>
<li>DeltaBlue: 1239</li>
<li>Crypto: 766</li>
<li>RayTrace: 673</li>
<li>EarleyBoyer: 1151</li>
</ul>

<h3>Firefox3.0</h3>
<h4>Score: 124</h4>
<ul>
<li>Richards: 121</li>
<li>DeltaBlue: 150</li>
<li>Crypto: 70</li>
<li>RayTrace: 144</li>
<li>EarleyBoyer: 163</li>
</ul>

<h3>Safari3.1.2</h3>
<h4>Score: 109</h4>
<ul>
<li>Richards: 69</li>
<li>DeltaBlue: 95</li>
<li>Crypto: 86</li>
<li>RayTrace: 133</li>
<li>EarleyBoyer: 210</li>
</ul>

<h3>Opera9.5</h3>
<h4>Score: 142</h4>
<ul>
<li>Richards: 86</li>
<li>DeltaBlue: 108</li>
<li>Crypto: 72</li>
<li>RayTrace: 218</li>
<li>EarleyBoyer: 391</li>
</ul>


<h3>IE8 beta2</h3>
<h4>Score: 35</h4>
<ul>
<li>Richards: 27</li>
<li>DeltaBlue: 29</li>
<li>Crypto: 21</li>
<li>RayTrace: 42</li>
<li>EarleyBoyer: 76</li>
</ul>

<p>と、いうわけでスコアだけ見るとGoogle Chrome(V8)の圧勝すぎで、ちょっと逆に怪しく思っちゃうくらいです。 Fx3, Safari3, Opera9.5あたりの比較はこんなかんじ？思ったよりOpera速いな、という印象もあります。あと、IEに至っては、ベンチとってる最中に「すごく遅くなっちゃうのでスクリプトの実行を停止しますか？」的な（いつもの）ダイアログまで出る始末。IE8がんばれ、もっとがんばれ。</p>

<h3>結論</h3>
<p>細かな検証はamachangさんやJohnResigさんあたりが行ってくださる？とも思いますが、「V8すげー速いっぽいぞ！」というくらいの感じは持っていてもいいかもしれません。ただGmailやMapsを見ても体感的に劇的に速くなったとも思えないのも実情です。取り急ぎざっくりしたレポートはこんなかんじ。</p>


