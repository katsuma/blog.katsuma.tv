---
title: jQueryでTwitterぽいエフェクトをかける
date: 2008/03/12 18:40:21
tags: javascript
published: true

---

<p>JavaScriptの小ネタはあまりウケないことを理解しつつのエントリー&&個人的な備忘録です。</p>

<p>TwitterのSettingsで設定変更したときのホワっとメッセージが出て、しばらく表示した後に、スっと消えるあの感じ。あれをjQueryで書く。こんな感じにするとそれっぽくなった。</p>

<p><pre>
var t = setTimeout(
 function(){
  $('#fadeout-text').fadeOut(3000);
  clearTimeout(t);
 }, 2000);
</pre></p>

<p>fadeOutだけでなんとかなるかなと思ったけど、時間を調整してもそれっぽくならなかった。最初に数秒間、普通に表示させてからスっと消さなきゃそれっぽくならないのでsetTimeoutでfadeOutの実行をズラしてみた。あと、fadeOutじゃなくてhide使うと領域(#fadeout-text)がだんだん小さくなりながら消えていったので、ちょっとイメージとズレてた。setTimeoutのズラした時間はもう少し長くてもいいかもしれない。これ、フォームのPOST実行後の結果表示みたいなときに、さりげなく使うとちょっといい感じ。</p>


