---
title: CakePHPとRuby on Railsの違い
date: 2009/05/10 03:48:34
tags: php, ruby
published: true

---

	<p>最近、仕事でRailsを使い始めたので、今までよく使っていたCakePHPとどこが一緒でどこが違うのかをざっくりまとめてみました。まだRailsは勉強中なので、理解が不十分だったり間違っている箇所もあるかと思いますが、それらの点についてはコメントなどでご教授いただければ幸いです。</p>
	
	<h3>Controller</h3>
	<p>CakePHPの場合、任意のアクションにおいて、/users/show/katsuma のように、URLで「/」で区切られているものは、アクション以降の文字列も勝手に引数に分けてくれます。なので、アクション側の定義で</p>
	<p><pre>function show($id, $name)</pre></p>
	<p>のように引数を分けて定義しておいてあげれば、勝手に値が割り当てられることになります。</p>
	
	<p>Railsの場合はconfig/routes.rbで振り分け方法を定義しておいてあげる必要があります。上の例だと</p>
	<p><pre>
	map.connect 'users/show/:id/:name', :controller => 'users', :action => 'show'	</pre></p>
	<p>こんな感じになるでしょうか。</p>
	<p>一方で、Railsの場合、routes.rbはものすごい強力で、map.connetのかわりに好きな名前のメソッドを指定するだけで「(名前)_url」で指定したcontroller, actionなどを含むURLを作成することなんかできたりします。たとえば</p>
	<p><pre>
ActionController::Routing::Routes.draw do |map|
 map.berryz '', :controller => "berryz", :action=> "show"
end</pre></p>
	<p>こんな感じにroutes.rbで定義しておいた上で、</p>
	<p><pre>
berryz_url(:id => 'miyabi')
</pre></p>
	<p>で呼び出すと、</p>
	<p><pre>http://localhost:3000/berryz/show/miyabi</pre></p>
	<p>を意味することになります。Railsすごい。。。！</p>
	<p>また、GETで引数指定で渡ってきたも、routes.rbで指定された引数も、すべて param[:hoge]のシンボル指定で取得できるのも特徴でしょうか。</p>


	<h3>ApplicationController</h3>
	<p>CakePHPの場合、任意のControllerクラスの継承元であるApplicationControllerは "app/" ディレクトリ直下に "application_controller.php" の名前で設置されます。</p>
	<p>Railsの場合は、"app/controllers/" の中に "application.rb"の名前で設置され、その場所と名前が微妙に異なります。</p>
<p>この名前については、これ規約からも外れてるよなぁ。。と思ってたら、どうやらRails 2.3.0からは"application_controller.rb"に名前が変わるようですね。詳しい話はこちらに書いてました。（参照元：<a href="http://d.hatena.ne.jp/takihiro/20081127/1227776059">そういえば ApplicationController ってファイル名の規約を守ってなかったんだな</a>）</p>



	<h3>View(レイアウト)</h3>
	<p>CakePHPの場合、大枠のレイアウトはviews/layouts/default.ctp に、そのレイアウトのHTMLを記述します。</p>
	<p>Railsの場合は、views/layouts/application.rhtmlに記述することになり、その名前は異なります。統一性の観点から言うと、Railsのこの名前の方が個人的には好きです。</p>



	<h3>部分テンプレート</h3>
	<p>CakePHPの場合、部分テンプレート(element)は、views/elements/ 以下に header.ctp の名前で保存しておきます。elementの呼び出す場合は、View側で</p>
	<p><pre>$this->element('header') </pre></p>
	<p>の、ように呼び出します。</p>

	<p>Railsの場合は、特定のcontroller内での共通テンプレート、全controllerでの共通テンプレートとそれぞれ別に分けることができます。
	  前者の場合は、 views/user/_header.rhtml のように、"views/controller名/_{部分テンプレート名}.rhtml"の形式になります。
	  逆に後者の場合、views/shared/_header.rhtmlのように、"views/shared/_{部分テンプレート名}.rhtml" の形式になります。</p>
	<p>部分テンプレートの呼び出し方は、前者の場合は、&lt;%=render :partial=>'header'/&gt; のように、後者の場合は :partialで指定する値が"shared/header"のようになります。</p>
	<p>この点については、Railsはここまで細かい指定がなくてもいいのにな、、と思います。Cakeの方が直感的な規約だし、呼び出し方も簡単かな、と。</p>



	<h3>Filter</h3>
	<p>Cake,Railsともにcontrollerにおいて、その前後にフィルタをかけることが可能です。いわゆるbeforeFilter, afterFilterですね。
	  Cakeでは特定のController、またはApplicationControllerにおいてbeforeFilter/afterFilterアクションを定義しておくことで、そのフィルタを通すことが可能です。</p>
	<p>Railsの場合、フィルタにはメソッドはもちろんですが、クラス、ブロックの３つのレベルで指定可能です。また、複数のフィルタが定義されている場合は、その定義された順番にフィルタが適用されます。</p>
	<p>このRailsの細かな指定は凄い、としか言いようがないかんじ。特にブロックで渡すことができる柔軟性は使いこなせばすごく便利そうな印象です。（まだ自分はそこまで使いこなせてません）</p>

	<h3>静的ファイル</h3>
	<p>CakePHPの場合、画像やCSSファイルなど、静的ファイル（や、routes.phpのルーティングに外れるもの）は、"webroot/" 以下に設置しておけばOKです。</p>
	<p>逆に、Railsの場合は、"public" ディレクトリに設置することになり、そのディレクトリ名が異なっています。</p>
	<p>これについては、Railsを意識しまくったCakeとしては、どうしてここの名前だけ変えたのかはよく分かりません。。。</p>


	<h3>まとめ</h3>
	<p>ざっと目につきやすい相違点をまとめてみました。Railsについてはまだまだ触り始めたばかりなので、相違点はまだまだあるでしょうし、注意して理解を深めて行きたいと思います。
	 また、今回こうやって相違点を考えていくことで、むしろお互いの理解が深まるんじゃないかな、とも思っています。</p>
	<p>ちなみに、チュートリアルについて、<a href="http://book.cakephp.org/ja/">book.cakephp.org</a>は日本語化されてるわけですが、<a href="http://guides.rubyonrails.org/">guides.rubyonrails.org</a>は日本語化されてないんでしょうか？？
	  すごくよくまとまってそうなので、できれば日本語で読んでみたいのですが。。</p>



