---
title: JSONの文字列リテラルはダブルクオートしか使えない
date: 2008/02/26 01:38:51
tags: actionscript
published: true

---

<p><pre>
{ "name" : "katsuma"}
</pre></p>

<p>はOKだけども</p>

<p><pre>
{ "name" : 'katsuma'}
</pre></p>

<p>はダメ。細かい！＞＜</p>

<p>JavaScriptの中だけで完結してたら特に怒られないので気づかないんだけども、ActionSciriptでJSON扱ってるときに何も考えなかったらドハマリすることがある。最近も小一時間これにハマってた。具体的に言うと、たとえば<a href="http://code.google.com/p/as3corelib/">corelib</a>パッケージのJSONデコーダ使うときに、シングルクオート使うとパースエラーになってコケてしまう。</p>

<h3>そもそも仕様は？</h3>
<p>今更ながら見直してみると、<a href="http://json.org/">Stringの定義はちゃんとダブルクオート使え</a>ってちゃんと言ってますね＞＜</p>

<p>あまりに基本すぎてスルーしてると痛い目にあう、典型的な話でした。</p>


