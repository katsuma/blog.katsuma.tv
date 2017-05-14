---
title: ExternalInterfaceでActionScriptの関数呼び出し失敗への対策
date: 2008/02/16 14:56:32
tags: actionscript
published: true

---

<p>[2008.11.19 追記]<br />
関連エントリーとして「<a href="http://blog.katsuma.tv/2008/11/externalinterface_not_work_on_ie_after_body_on_loaded.html">ExternalInterfaceでは対象swfをonLoad以降にロードしてはダメ</a>」を投稿しました。</p>

<p>FlashPlayer8からExternalInterfaceを利用することで、かなり簡単にASからJSの関数を呼び出したり、JSからASの関数を呼び出すこともできるようになりました。で、JSからASを呼び出す場合は、あらあじめAS側でJSから呼び出す関数の名前と、実際に実行する関数の登録を行うことで可能になります。たとえばこんな感じ。</p>

<p>
<pre>
ExternalInterface.addCallback('setMessage', this._setMessage);
</pre>
</p>

<p>これだとJS側でswfのオブジェクトを参照してsetMessageを呼び出すと、AS側で_setMessageが呼び出される仕掛けになります。このときにやってみて初めて体験するハマりポイントが多いので、今日はそのポイントのまとめの話。</p>

<h3>swfの参照</h3>
<p>上記のswfの参照方法はIEとIE以外のブラウザで方法が変わってくるのですが、僕はこんな感じでワンライナーでやってます。</p>

<p><pre>
var player = document.all? window[id] : document[id];
</pre></p>

<p>上の例のidはobject要素のid属性、embed要素のname属性に設定しておく値です。ポイントは<strong>object要素はidに、embed要素はnameに設定</strong>しておくこと。embedでもidに設定すると呼びだしに失敗することもあるので、name属性だけの設定し、id属性には何も設定しないようにすべきです。</p>
<p>また、ここで設定する値は<strong>「*external*」な名前にしておかないとIEでコケる場合があります。</strong>僕は仕事ではライブ系のswfを扱うケースが多いので「externallive」なんて名前にしがち。（<a href="http://quality.ekndesign.com/archives/2006/07/externalinterfa.html">参考情報</a>）</p>

<h3>ExternalInterface.addCallbackが確実に完了してから呼び出す</h3>
<p>考えてみたら当たり前だけど最近ものすごくハマった点。swfはロードに時間かかる場合があるので、個人的にはJSでwindow.load/DOMContentLoaded時に読み込みをさせる場合が多いのですが、「swfを書き出し」→「swfがExternalInterface.addCallbackを実行」→「JSからASの関数を実行」、としたときにタイミングによってはASの関数呼び出しに失敗します。playerの参照はできても、「setMessage is not function」のようなエラーメッセージが出る場合が多いので、swfはロードできていても、addCallbackの処理が完了していないのが問題です。</p>

<p>こういう場合はASの関数をコールする前に、AS側が<strong>addCallbackの処理が完了したことをJS側に通知 or JSが呼び出したい処理をAS側から呼び出す</strong>必要があります。上の例だと、本来はJS側からsetMessageを呼び出すものを、AS側から呼び出します。</p>

<p><pre>
ExternalInterface.addCallback('setMessage', this._setMessage);
ExternalInterface.call('setMessage');
</pre></p>

<p>この例だとASが呼び出される関数(setMessage)をJS経由で呼び出しているので何か変な感じですが、たとえばsetMessage内でJS側からしか参照できないスコープの変数を利用したいときなどには使えるかと思います。要は、(処理フローとして)addCallbackの完了を確実に保証してあげないと、失敗することが多いですよ、という話。</p>

