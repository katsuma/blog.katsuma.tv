---
title: CakePHP1.2のエラーページは仕様が変わってる
date: 2008/06/18
tags: php
published: true

---

<p>（追記:2008/06/20）この内容は表現に不十分な点があります。文末に情報を追記しています。</p>

<p>CakePHPではControllerがみつからない、Viewが無い、なんかのエラーページは、CakePHP1.1ではapp/views/errorに</p>

<p><ul>
<li>missing_action.thtml</li>
<li>missing_controller.thtml</li>
<li>missing_view.thtml</li>
</ul></p>

<p>なんかを用意しておけばカスタムエラーページを表示することができて、露骨に「loginのviewがありません＞＜」みたいなエラーが表示されてセキュリティホールになりうることを回避できます。このviewの命名規則はCakePHP1.2も同じで</p>

<p><ul>
<li>missing_action.ctp</li>
<li>missing_controller.ctp</li>
<li>missing_view.ctp</li>
</ul></p>

<p>を用意しておけばOKです。</p>

<h3>共通処理についての仕様変更</h3>
<p>さて、これらのviewに共通の変数を利用する場合、たとえばログインしているときのログイン名をヘッダに表示するなんてことをエラーページにも適用したい、という場面は当然あると思います。その場合、app/app_controller.phpを用意しておいて、beforeFilterで変数をセットしておけばありとあらゆるviewで適用できます。たとえばこんな形にしておけば全viewで$my_nameで名前の表示が行えます。</p>

<h4>app/app_controller.php</h4>
<p><pre>
&lt;?php
class AppController extends Controller{	
	function beforeFilter(){
		$my_name = 何らかの方法で名前を取得;
		$this -&gt; set('my_name',$my_name);
	}	
}
?&gt;
</pre></p>

<p>ところが、1.2ではこの方法ではエラーページにかぎって名前が取得できません。他のAppControllerを継承したコントローラのページでは取得できるので、どうやらエラーページではAppControllerを継承していないor処理がスルーされている様子。</p>

<p>と、いうわけでエラーページの仕様が変わっているようなので、いろいろと調べてみるとエラーページはcake/libs/error.phpをコピーしてapp/error.phpに配置してあげると、エラー発生時に独自のハンドリングが行える模様。ファイルをコピーしてからapp/error.phpを開いてみるとこんな感じの記述が。</p>

<p><pre>
	function __construct($method, $messages) {
		App::import('Controller', 'App');
		App::import('Core', 'Sanitize');

		$this-&gt;controller =& new AppController();
		$this-&gt;controller-&gt;_set(Router::getPaths());
		$this-&gt;controller-&gt;params = Router::getParams();
		$this-&gt;controller-&gt;constructClasses();
		$this-&gt;controller-&gt;Component-&gt;initialize($this-&gt;controller);
		$this-&gt;controller-&gt;_set(array('cacheAction' =&gt; false, 'viewPath' =&gt; 'errors'));

...

</pre></p>

<p>そう、app_controllerをimportして、そのコンストラクタを作成しているような様子です。にも関わらずbeforeFilterが適用されていないようなので、強制的に呼び出してあげればよさそうです。上のコードに次の１行を付け加えます。</p>

<p><pre>
	function __construct($method, $messages) {
		App::import('Controller', 'App');
		App::import('Core', 'Sanitize');

		$this-&gt;controller =& new AppController();
		$this-&gt;controller-&gt;_set(Router::getPaths());
		$this-&gt;controller-&gt;params = Router::getParams();
		$this-&gt;controller-&gt;constructClasses();
		$this-&gt;controller-&gt;Component-&gt;initialize($this-&gt;controller);
		$this-&gt;controller-&gt;_set(array('cacheAction' =&gt; false, 'viewPath' =&gt; 'errors'));
		<strong>$this-&gt;controller-&gt;beforeFilter();</strong>

...

</pre></p>

<p>これでエラーページでも名前を表示することができました。1.2のリリース版が出たら直ったりするんでしょうかね？取り急ぎ、エラーページで困った人はこれらの情報をもとに対処方法を考えてみてはいかがでしょうか？</p>

<p>（追記 : 2008/06/20） コメントで指摘していただいいたのですが、僕の方の記述も不十分な点がありました。今回のerror.phpはコピーしているだけではあるのですが、実際は「ErrorHandlerを継承した、AppErrorクラスを作成して、そこで処理させるものを用意する」 と、いう表現の方が正しいです。実際、コピー元もApppError extends ErrorHandlerではあるのですが、あくまでコピー元は雛形として考えて、それぞれ場合に応じたAppErrorクラスを用意いただく方がいいと思います。</p>

<p>また、beforeFilterの直接呼出しについての弊害はまだ調べきっていませんが、何か分かり次第ここでもまとめておきたいと思います。</p>
