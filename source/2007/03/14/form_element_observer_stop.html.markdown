---
title: Form.Element.Observerをクリアする
date: 2007/03/14
tags: javascript
published: true

---

<p>
<a href="http://www.prototypejs.org/">Prototype.js</a>を使うと、フォームの内容を監視してコールバックを実行させることが簡単に実装できます。
たとえばこんな感じ。</p>

<blockquote>
<xmp>
new Form.Element.Observer('input_hoge',1,
 function(){ window.title=$F('input_hoge');}
);</xmp>
</blockquote>

<p>
これはid=input_hogeのテキストフィールドの値を1秒間隔で取得して、タイトルに反映させる、というもの。Form.Element.Observerの最後の引数は関数を渡すのですが、無名関数でももちろんOK。ちょこっとしたことならこっちの方が楽かも。
</p>


<p>
さて、ここで問題は実はこのObserverをクリアする方法が無い、ということ。Prototype.jsは他にもTimerをクリアできない問題があったような。。。（記憶あやふや）なんとなく気持ち悪いのでいろいろ調べていたら、綺麗に解決されてる事例があったのでメモ。
</p>


<p>
<a href="http://blog.nomadscafe.jp/archives/000576.html">blog.nomadscafe.jp</a>より引用。
Form.Element.Observerのprototypeをいろいろいじっています。以下のコードをPrototype.jsに追加。
</p>

<blockquote>
<xmp>
Form.Element.Observer.prototype.registerCallback=function(){
    this.interval = setInterval(this.onTimerEvent.bind(this), this.frequency * 1000);
};
Form.Element.Observer.prototype.clearTimerEvent=function(){
    clearInterval(this.interval);
};
Form.Element.Observer.prototype.onTimerEvent=function(){
    try{
        var node = this.element.parentNode.tagName;
    }catch(e){
        this.clearTimerEvent();
    }    
    var value = this.getValue();
    if (this.lastValue != value) {
        this.callback(this.element, value);
        this.lastValue = value;
    }
};
</xmp>
</blockquote>


<p>
つまり、監視対象のオブジェクトがなくなったらclearIntervalしてあげよう、というもの。
なので、「もうこのオブジェクトはいらない！」のタイミングでinnerHTMLを書き換えてしまえば監視対象から外れます。

</p>


<p>
元記事では、明示的にあるリンクのクリックをトリガにしてinnerHTMLを書き換えてたけども、監視はフォームの要素が対象になるので、「focusIn」→監視開始、「focusOut」→監視終了、というトリガでうまくまとまらないかな？？、、、と、思いつつまだ未検証です。あと、clearIntervalのトリガにtry-catchを利用しているのも、ちょっと考えてみたいです。
</p>　
