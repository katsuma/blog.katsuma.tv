---
title: ActionScriptで使うlog関数のエラー対策
date: 2008/01/31 19:43:20
tags: actionscript
published: true

---

<p>
ActionScript3で使うと便利なライブラリで<a href="http://subtech.g.hatena.ne.jp/secondlife/20070219/1171872801">log関数</a>があります。 
</p>

<p>
<pre>
log(s);
</pre>
</p>

<p>で呼び出したときに、Firebugがインストールされてあると、console.log(s)が実行される仕掛けです。</p>

<p>ただし、この関数はFirebugがインストールされてあることが前提のものなので、たとえばIEを利用している場合は表示がおかしくなる場合があります。（真っ白になったり。）なので、console.logを呼び出す際にうまくラップしてあげた方がベターです。たとえばこんな感じ。</p>

<p>
<pre>
package {
  import flash.external.ExternalInterface;
  import flash.utils.getQualifiedClassName;

  public function log(... args):void {
    var inspect:Function = function(arg:*, bracket:Boolean = true):String {
        var className:String = getQualifiedClassName(arg);
        var str:String;

        switch(getQualifiedClassName(arg)) {
            case 'Array':
              var results:Array = [];
              for (var i:uint = 0; i &lt; arg.length; i++) {
                  results.push(inspect(arg[i]));
              }
              if (bracket) {
                str = '[' + results.join(', ') + ']';
              } else {
                str = results.join(', ');
              }
              break;
            case 'int':
            case 'uint':
            case 'Number':
              str = arg.toString();
              break;
            case 'String':
              str = arg;
              break;
            default:
              str = '#&lt;' + className + ':' + String(arg) + '&gt;';
        }
        return str;
    }
    
    var r:String = inspect(args, false);
    trace(r)
    ExternalInterface.call('function(){ if(typeof console == \'object\' && typeof console.log == \'function\') return console.log.apply(this, arguments)}', r);
  }
}
</pre>
</p>

<p>console, console.logの存在判定してるだけですけども、忘れて素のlog関数をコードに入れっぱなしにしておくと思わぬハマり方をする場合もあると思うので、こんな風に予防線張っておくのもいいかと思います。</p>
