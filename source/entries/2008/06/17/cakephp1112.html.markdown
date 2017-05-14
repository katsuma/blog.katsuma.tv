---
title: CakePHPを1.1から1.2へ上げるときの注意点
date: 2008/06/17 02:17:46
tags: php
published: true

---

<p>（注意：まだ書きかけです→2008.06.18 書き終わりました）</p>

<p>2008.06.18現在、CakePHP1.2のrc版がリリースされてあり、1.1でアプリケーションを作っていた人もそろそろ1.2に上げようかな、、なんて思っているんじゃないかと思います。最近仕事でさくっとCakePHP1.1で作ったサイトがあったのですが、リリースが落ち着いた瞬間を狙って一気に1.2に上げてみました。そのときのメモを残しておきます。 今回は1.2.0.7125 RC1を利用しています。なお、この移行作業は「<strong>とりあえず警告が出ないレベルで正常動作する」ことを目的</strong>にして作業を行っています。なので、実際は非推奨の方法も混ざっていることもあるかと思いますが、ご注意ください。</p>

<h3>cakeディレクトリ</h3>
<p>ここは全部丸ごと入れ替えます。オリジナルのcakeディレクトリ丸ごと削除→1.2のcakeディレクトリをコピー。</p>

<h3>viewファイルの拡張子を変更</h3>
<p>1.1のときのviewのファイルの拡張子は.thtmlでしたが、1.2になって.ctpに変わっています。１ファイルづつ変更していても疲れるのでこんな感じで一気に変換します。</p>

<p><pre>
for file in *; do mv -i $file `echo $file | sed 's/.thtml/.ctp/'`; done
</pre></p>

<h3>フォームヘルパの変更</h3>
<p>フォームヘルパも書き方が変わって、</p>
<p><pre>&lt;?php echo $html-&gt;input('Timeline/title', ...); ?&gt;</pre></p>
<p>から、</p>
<p><pre>&lt;?php echo $form->input('Timeline.title', ...); ?&gt;</pre></p>
<p>に変わっています。ここで、とりあえず$htmlから$formにだけ変更しておきます。1.2.0.7125 RC1現在、$html変数を利用すると警告が出ますが、$html-&gt;inputの引数のフォーマットは1.1のままでも怒られないようです。これは秀丸のgrep置換などを利用して一気にやってしまいましょう。</p>

<h3>app/config/routes.php</h3>
<p>config系も記述の仕方が変更になっている点が多いです。まずroutes.phpはRouteオブジェクトがRouterクラスに変更になっています。元のapp/config/routes.phpを次のように変更します。</p>
<p><pre>
(1.1)$Route->connect('/home', array('controller' => 'pages', 'action' => 'home'));
(1.2)Router::connect('/home', array('controller' => 'pages', 'action' => 'home'));
</pre></p>

<h3>app/config/core.php</h3>
<p>core.phpはdefineで定義していたものがConfigureクラスを利用するようにします。元のapp/config/core.phpを次のように変更します。</p>

<p><pre>
(1.1) define('debug', 0);
(1.2) Configure::write('debug', 0);
</pre></p>

<p>ただし、基本的にはcore.phpに関しては1.2で内容がかなり変わっているので、実際は変更作業を行うよりも、1.2オリジナルのものを利用した方がよさそうです。</p>

<h3>アプリケーション固有の定数</h3>
<p>アプリケーション特有の定数宣言はどうするのがベストプラクティスなのか分かっていませんが、僕は1.1の時にはapp/config/app.phpと専用のファイルを作成して、defineで定義していたものを用意していたので、これをそのまま流用するためにbootstrap.phpからincludeさせています。</p>

<h4>app/config/app.php</h4>
<p><pre>
&lt;?php
define('APPLICATION_NAME', 'HogeHoge');
define('APPLICATION_SERVER', '192.168.100.10');
...
?&gt;
</pre></p>

<h4>app/config/bootstrap.php</h4>
<p><pre>
&lt;?php
...
// load const values
require_once(APP . 'config/app.php');
...
?&gt;
</pre></p>

<p>このincludeはApp::importを利用する or Configure::writeで定義させる方法を利用した方がいいのかもしれません。（ご存知の方は教えていただければ幸いです）</p>

<h3>Vendor系ライブラリ</h3>
<p>サードパーティなライブラリはapp/vendorsに配置させてapp/config/bootstrap.phpからロードさせると思うのですが、ここでのロード方法も変更になっています。たとえば僕は<a href="http://dbug.ospinto.com/">dBugライブラリ</a>を利用しているので、これをapp/vendors/dBug/dBug.phpに配置しているのですが、このロード方法について、次のように変更になっています。</p>

<p><pre>
(1.1) vendor( 'dBug'.DS.'dBug' );
(1.2) App::import( 'Vendor', 'dBug', array('file'=>'dBug' . DS . 'dBug.php') );
</pre></p>

<p>どうも1.2になってキャメルケースの名前を発見すると自動的にアンダースコアをつけて解釈しちゃうようです。たとえば、</p>

<p><pre>
App::import('Vendor', 'SMTP');
</pre></p>

<p>と、書いた場合は</p>

<p><pre>
app/vendors/s_m_t_p.php
</pre></p>

<p>を見に行ってしまうようです（超厄介。。）サードパーティ製のライブラリについてはこのキャメルケースの解釈は勘弁してほしいんですけども、そうは言っていられないので、上でかいたほうに、arrayでフルパスを指定することでこの仕様を回避しています。</p>

<h3>まとめ</h3>
<p>手元の環境ではこんな感じの移行作業で動作しました。ある程度予想はしていたものの、やっぱり実際に作業してみると結構時間がかかりましたね。。特に定義系の表記法法の仕様変更を追いかけるのに苦労しました。</p>

<p>ただ、実際に移行作業をしてみると1.2の方が圧倒的に多機能で拡張性も豊かなので、移行のメリットは充分にあるかと思います。移行をためらっている方も、そろそろ「えいや！＞＜」の勢いで移行を検討されてはどうでしょうか？</p>


