---
title: PeriodicalExecuterを停止させる
date: 2007/07/20 02:14:04
tags: javascript
published: true

---

<p><a href="http://prototypejs.org/">Prototype.js</a>で定期実行させるための便利オブジェクトPeriodicalExecuterですが、少し前のバージョンまで停止させる方法がありませんでした。clearIntervalさせるためのsetIntervalの返り値が保存されていなかったのが原因です。実際、<a href="http://www.google.co.jp/search?hl=ja&client=firefox&rls=org.mozilla%3Aja%3Aofficial&hs=plE&q=periodicalexecuter+%E5%81%9C%E6%AD%A2&btnG=%E6%A4%9C%E7%B4%A2&lr=lang_ja">少し調べても</a>「停止のためのインターフェースは無いよ」な声ばかり。でも、これウソです。最新のバージョンだと<strong>停止させることは可能</strong>です。</p>


<p>バージョン1.5.0からはPeriodicalExecutorオブジェクトにstop()メソッドが追加されています。コード見れば分かりますが、上記の問題であったregisterCallback関数(setIntervalを行う実体関数)の返り値をメンバ変数に格納させておき、それをstopメソッド内でclearIntervalさせています。</p>

<p>コードを書けばこんな感じになります。</p>

<p><pre>
// hogeを30秒毎に定期実行
var executer = new PeriodicalExecuter(hoge, 30);
// 定期実行を停止
executer.stop();
</pre></p>

<p>それにしても、何でここまでこの機能を引っ張っていたのか。。もう少し早くから実装されてもよかった機能なんですけどね。</p>
