---
title: モダンブラウザでAppletを扱うときに知っておくこと
date: 2009/04/07 07:41:42
tags: develop
published: true

---

<p>[09/04/07 16:00 追記]　embedでの呼び出し結果の表に誤りがあったので訂正しました。</p>

<p>
世間ではiPhone OS3.0で騒がれていますが、そんな中メインストリームとは逆行してJava Appletについていろいろ調べていました。
</p>


<h3>情報が少なすぎる</h3>
<p>
世間的にはJava Appletの話なんて枯れすぎてる話題なので、いくら調べても2000年過ぎの情報ばかりが大半です。「ただしこの方法ではNetscape4.0以上の環境では。。。」とか言われても困るわけです。今どきのWebアプリケーションらしくJavaScriptと連携させるにはどうすればいいんでしょうか。そもそもappletのロード方法１つとってもSafariやChromeなんかのモダンブラウザに対応したロード方法とかまったくわかりません。あとJava Runtimeのインストールチェックなんてどうすればいいのでしょうか？？疑問は尽きません。
</p>

<p>そこで、今回これらの情報、</p>
<ol>
<li>JavaScriptからAppletを呼び出す方法</li>
<li>AppletからJavaScriptを呼び出す方法</li>
<li>モダンブラウザに適したAppletのロード方法</li>
</ol>
<p>について調べてみたのでまとめておきたいと思います。</p>

<h3>Java Runtime のバージョンチェック</h3>
<p>そもそもAppletを実行できる環境であるかどうか、を判定する必要がありますが次のようなロジックで確認をすることが可能になります。</p>
<ol>
<li>Applet側でRuntimeのバージョン情報をpublicなフィールドに格納しておく </li>
<li>JavaScriptから1.のフィールドを参照する </li>
<li>参照に失敗、または参照先の値が不正な場合はRuntimeがない、と判断。参照先に値があった場合はその値がバージョン情報</li>
</ol>

<p>
次に、JavaScriptとの連携を考えるわけですが、ここでは「JavaScriptからAppletのメソッドを呼び出す」「AppletからJavaScriptの関数を呼び出す」の２パターンがあります。まず、前者の方から考えていきましょう。</p>

<h3>AppletからJavaScriptを呼び出す</h3>
<p>こちらは非常にシンプルで「document.{$AppletをロードしたHTML要素のid}.{$appletにおけるpublic修飾子のメソッド、またはフィールド}」でアクセスすることができます。たとえば次のようなAppletがあるとします。</p>

<p>
<pre>
import java.applet.Applet;

public class VMInfo extends Applet {
  public String jreVersion = "";
  public void init() {
    this.jreVersion = System.getProperty("java.version");
  }
}
</pre></p>

<p>
また、次のようにappletタグでappletをロードしておくとします。
</p>


<p><pre>
&lt;applet name="app" code="VMInfo" mayscript="true" archive="plugin.jar" width="430" height="200"&gt;&lt;/applet&gt;
</pre></p>


<p>このとき、JavaScriptからAppletのjreVersionフィールドにアクセスする場合、</p>

<p><pre>
document.app.jreVersion
</pre></p>

<p>で、アクセスが可能です。ここでのappはapplet要素のname属性値になります。非常に簡単ですね。</p>


<p>また、FlashのExternalInterface経由でJavaScriptからFlashのメソッドにアクセスする場合、IE系はdocument経由、それ以外のブラウザはwindow経由でFlashの参照を取得するなど、参照の取得方法は異なります。ところが、Appletの場合はIEでもFirefoxでもChromeでもすべて同じ「document経由」で参照を取得する、というのは１つのポイントになります。</p>


<h3>AppletからJavaScriptを呼び出す</h3>
<p>先ほどとは逆に、JavaからJavaScriptのメソッドを呼び出す方法について考えてみます。方法としては、</p>

<ol>
<li>JSObjectを利用する方法 </li>
<li>共通 DOM API を介してアクセスする方法</li>
</ol>

<p>の2種類の方法が存在します。ここでは単純な1の方法を紹介します。</p>

<p>
JSObjectクラスのメソッド群を利用すると、HTML ページの DOM へのアクセスが容易になります。JSObjectを利用する場合、次のjarファイルをクラスパスに通しておく必要があります。</p>


<p><pre>{$jdk}\jre\lib\plugin.jar</pre></p>

<p>
plugin.jarにクラスパスを通すと、netscape.javascript.JSObject を利用することが可能になります。JSObjectはstaticメソッドでglobalなwindowオブジェクトの参照を取得します。windowオブジェクトの参照を取得すると、あとは任意のJavaScriptのコードをeval()で実行することが可能になります。たとえばwindow.alert()を呼び出す場合は次のようなコードになります。</p>

<p><pre>
import java.applet.Applet;
import netscape.javascript.JSObject;

public class VMInfo extends Applet {
   public void init() {
　　JSObject win = JSObject.getWindow(this);
　　String jsContext = "alert()";
　　win.eval(jsContext);
   }
}</pre></p>


<p>要はActionScript3におけるExternalInterface.callのようなもの、というイメージで良いと思います。JSObectのAPIについては、<a href="http://java.sun.com/javase/ja/6/webnotes/6u10/plugin2/liveconnect/jsobject-javadoc/netscape/javascript/JSObject.html">こちらのドキュメント</a> にまとまっているので、さらに詳しく知りたい方はご参照ください。</p>

<p>ここで1つポイントとして、JSObjectを利用してappletとJavaScriptとの連携を行うときは、appletをロードするときのHTML要素に対して「mayscript」属性を追加しておく必要があります。属性値はtrueにでもしておけばいいですが、実際は属性が存在すれば問題は無いようです。このあたりの話は「<a href="http://moyolab.blog57.fc2.com/blog-entry-64.html">JavaScriptを使用するアプレットの単体テスト</a>」で述べられていますので、ご参考ください。</p>


<h3>ロード方法</h3>
<p>さて、appletのロード方法についても、パッと考えただけでもいろんな方法が思いつきます。</p>

<ol>
<li>appletタグでロード </li>
<li>objectタグでロード </li>
<li>embedタグでロード</li>
</ol>

<p>
Flashのような発想をすると、objectタグとembedタグの組み合わせでロードするのが本筋のような気もしますが、とりあえずこれまでで述べてきたJavaScript連携のコードを含んだAppletのロードを全パターンで試してみました。</p>

<p>
対象となるAppletのコードは次のようにしています。
appletがロードされると、JREのバージョン、およびベンダ情報を取得し、JS側のVMInfo.notify()を呼び出します。（Java→JavaScript呼び出しの確認）</p>

<p><pre>
import java.applet.Applet;
import java.awt.TextField;
import netscape.javascript.JSObject;

public class VMInfo extends Applet {
&nbsp;&nbsp;&nbsp; 
&nbsp;&nbsp; &nbsp;public String jreVersion = "";
&nbsp;&nbsp; &nbsp;public String jreVendor = "";

&nbsp;&nbsp; &nbsp;private TextField versionField;
&nbsp;&nbsp; &nbsp;private TextField vendorField;

&nbsp;&nbsp; &nbsp;public void init() {
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;this.jreVersion = System.getProperty("java.version");
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;this.jreVendor = System.getProperty("java.vendor");
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;this.versionField = new TextField(jreVersion, jreVersion.length());
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;this.vendorField = new TextField(jreVendor, jreVendor.length());
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;add(versionField);
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;add(vendorField);
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// callback
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;JSObject win = JSObject.getWindow(this);
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;String jsContext = "VMInfo.notify({\"version\":\"" + jreVersion + "\", \"vendor\":\"" + jreVendor + "\"})";
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;win.eval(jsContext);
&nbsp;&nbsp; &nbsp;}
}

</pre></p>

<p>
検証するJavaScriptの関数VMInfo.norifyは次のように用意しておきます。構造は単純で、Objectを引数に受け取り、alertで確認しています。
</p>

<p>.<pre>
&lt;script type="text/javascript"&gt;
 //&lt;![CDATA[
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; var VMInfo = {
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;notify : function(info){
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;var version = info.version || "";
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;var vendor = info.vendor || "";
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;window.alert([version, vendor]);
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;};
 //--&gt;
&lt;/script&gt;
</pre>
</p>

<p>
あわせて、JavaScript→Javaの呼び出しの確認として、次のようにAppletのプロパティを直接参照してみます。
</p>

<p><pre>
&lt;script type="text/javascript"&gt;
//&lt;![CDATA[
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; alert(document.app.jreVersion);
//--&gt;
&lt;/script&gt;
</pre></p>


<h4>呼び出し方法は実はこれではダメ</h4>
<p>当初、この組み合わせでいろいろ試していたのですが、実はOperaだけJavaScript→Javaの呼び出しで失敗することが多くて(undefinedが返る)、さてどうしたものか、と悩んでいました。それ以外のブラウザでは正確にAppletのプロパティにアクセスできるので、アクセス方法は間違ってることは無さそう。OperaはAppletへのアクセスはサポートしてないのかな、、と思ってたときに、そういえばAJAXまわりの話題でOperaはロードのタイミングが他のブラウザと比べておかしい、みたいな話題を見たことをフと思い出しました。「もしやappletがロードし終わる前にアクセスしようとしてる？」と思い、プロパティへのアクセスをwaitをかけてズラしてみました。</p>


<p><pre>
&lt;script type="text/javascript"&gt;
//&lt;![CDATA[
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; var d = document;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; setTimeout(function(){alert(d.app.jreVersion)}, 3000);
//--&gt;
&lt;/script&gt;
</p></pre>


<p>ビンゴ！</p>
<p>setTimeoutでアクセス時間をズラしてあげることで、Operaでもアクセスが可能になりました。やはりOperaはAppletへのプロパティアクセスが他のブラウザよりも早く(?)行われていたみたいです。本当は3000ms決め打ちじゃなくて、一定回数試行した方がいいのですが、とりあえず今回の実験はこの方法を取る事にして、いろんなappletロード方法の組み合わせと比較してみたいと思います。</p>

<p>ちなみに、今回試したブラウザの細かなバージョンについては、IE 7, Firefox 3.0.8, Safari 3.2.2, Opera 10.00 alpha, Chrome 2.0.171.0となっています。すべてWindows XP上での動作確認です。</p>

<h4>パターン1 : appletタグでロード</h4>
<p>まずは一番シンプルでレガシーな方法。</p>

<p><pre>
&lt;applet name="app" code="VMInfo" mayscript="true" archive="plugin.jar" width="430" height="200"&gt;&lt;/applet&gt;
</pre></p>

<p>結果は次の通り。</p>

<table cellpadding="3" cellspacing="0" border="1">
<thead>
<tr>
<th width="25%">Browser</th>
<th width="25%">表示</th>
<th width="25%">JS→Java</th>
<th width="25%">Java→JS</th>
</thead>
</tr>
<tbody>
<tr>
<td width="25%">IE7</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td width="25%">Fx3</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td width="25%">Safari3</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td width="25%">Opera10</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td width="25%">Chrome2</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
</tbody>
</table>


<p>全部OK! レガシーな方法はモダンブラウザでもちゃんと動くようです。</p>

<h4>パターン2 : objectタグでシンプルにロード</h4>
<p>次にobjectタグでロード。ただし、オプション情報はすべてobject要素の属性に設定するシンプルなロード方法にしてみます。</p>

<p><pre>
&lt;object id="app" classid="java:VMInfo" archive="plugin.jar"
mayscript="true" type="application/x-java-applet" width="230"
height="100"&gt;
</pre></p>

<p>結果は次の通りとなりました。</p>


<table cellpadding="3" cellspacing="0" border="1">
<thead>
<tr>
<th width="25%">Browser</th>
<th width="25%">表示</th>
<th width="25%">JS→Java</th>
<th width="25%">Java→JS</th>
</tr></thead>
<tbody>
<tr>
<td width="25%">IE7</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
<tr>
<td>Fx3</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td>Safari3</td>
<td align="center">○</td>
<td align="center">×</td>
<td align="center">○</td>
</tr>
<tr>
<td>Opera10</td>
<td align="center">○</td>
<td align="center">×</td>
<td align="center">○</td>
</tr>
<tr>
<td>Chrome2</td>
<td align="center">○</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
</tbody>
</table>


<p>この形式だとIEだと表示すらしてくれませんでした。JSからの呼び出しもなかなかうまくいかない模様です。
むしろシンプルな方法だとobjectタグを利用した場合、IE以外のブラウザでも表示してくれるのは新しい発見でした。</p>



<h4>パターン3 : objectタグでparamタグと組み合わせてロード</h4>
<p>次にparamタグと組み合わせてobjectタグでロード。</p>

<p><pre>
&lt;object id="app"
classid="clsid:8AD9C840-044E-11D1-B3E9-00805F499D93" width="230"
height="100"&gt;
&lt;param name="code" value="VMInfo"
/&gt;
&lt;param name="archive" value="plugin.jar" /&gt;No
applet
&lt;/object&gt;
</pre></p>

<p>結果は次の通りとなりました。</p>


<table cellpadding="3" cellspacing="0" border="1">
<thead>
<tr>
<th width="25%">Browser</th>
<th width="25%">表示</th>
<th width="25%">JS→Java</th>
<th width="25%">Java→JS</th>
</tr></thead>
<tbody>
<tr>
<td width="25%">IE7</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td>Fx3</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
<tr>
<td>Safari3</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
<tr>
<td>Opera10</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
<tr>
<td>Chrome2</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
</tbody>
</table>


<p>これも面白い結果。object/paramの組み合わせ方法はやはりAppletの場合でもIEしか有効では無い模様です。</p>

<h4>パターン4 : embedタグでロード</h4>
<p>次にパターン2,3とは逆にembedタグのみでロードしてみました。</p>

<p><pre>
&lt;embed code="VMInfo.class" width="230" height="100" name="app"
type="application/x-java-applet;version=1.6"
pluginspage="http://java.sun.com/javase/downloads/ea.jsp" /&gt;
</pre></p>

<table cellpadding="3" cellspacing="0" border="1">
<thead>
<tr>
<th width="25%">Browser</th>
<th width="25%">表示</th>
<th width="25%">JS→Java</th>
<th width="25%">Java→JS</th>
</tr></thead>
<tbody><tr>
<td>IE7</td>
<td align="center">×</td>
<td align="center">×</td>
<td align="center">×</td>
</tr>
<tr>
<td>Fx3</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td>Safari3</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
<tr>
<td align="center">Opera10</td>
<td align="center">○</td>
<td align="center">○(*)</td>
<td align="center">○(*)</td>
</tr>
<tr>
<td width="25%">Chrome2</td>
<td align="center">○</td>
<td align="center">○</td>
<td align="center">○</td>
</tr>
</tbody>
</table>

<p>こちらは、IE, Opera以外は総じて良い結果になりました。
Operaは、JavaScriptからJavaの呼び出しにおいて、「○」としましたが、不安定なことが多く成功したりしなかったり、ということが繰り返されていたことを注釈として付け加えておきます。</p>

<h3>まとめ</h3>
<p>モダンブラウザにおいてもJavaScriptからAppletの呼び出し、AppletからJavaScriptの呼び出しなど、言語間の連携は可能であることが確認できました。また、Appletのプログラムは、その呼び出し方法によってブラウザごとでまったく挙動が異なることが分かりました。特に気にしなければappletタグで呼び出すのが最も安定した呼び出し方法で、IEのみでロードをさせたいときはFlashと同じくObject/paramタグの組み合わせで呼び出すのがベストなようです。</p>

<p>さて、今回はここで終わりますが実はappletの呼び出し方法はappletタグでの呼び出しはベストな解ではありません。</p>
<ul><li>Java-pluginがインストールされていないときの自動プラグインインストール</li>
<li>appletのキャッシュコントロール</li></ul>
<p>などを考えたいときに、もっと凝った方法を取る必要があります。この話は次回に書いてみたいと思います。</p>


