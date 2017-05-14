---
title: Xcodeのプロジェクトテンプレートファイルをカスタマイズする
date: 2011/01/16 04:40:14
tags: xcode
published: true

---

 <p>半年ぶりの更新ですが、特に脈略もなく唐突にXcodeとopenFrameworksの話をします。</p>

 <p>最近、趣味で<a href="http://www.openframeworks.cc/">openFrameworks</a>を触りだしたのですが、XCodeの開発環境を触るのも１年ぶりだし、そもそもC++を書くのは数年ぶりすぎて前に書いたのいつだっけ、、というくらいのレベルでした。
   そんな感じなので、まずは開発環境を完璧にしようと思った矢先、出鼻をくじかれる問題が。</p>

 <h3>テンプレートから作成したプロジェクトがビルドできない</h3>
 <p>openFrameworkは2011年1月16日時点でバージョン0.062が最新となっています。
ダウンロードページから最新ファイルを解凍すると、Xcode用のテンプレートディレクトリ「xcode templates」が内包されてあり、このディレクトリをXcodeが起動していないときに下記のいずれかに配置すると、
Xcode側で認識されopenFrameworksのアプリケーション用のプロジェクトを作成できる、とあります。</p>

<p>
<pre>
/Library/Application Support/Developer/3.0/Xcode/Project Templates/openFrameworks
/Library/Application Support/Developer/Shared/Xcode/Project Templates/openFrameworks
~/Library/Application Support/Developer/3.0/Xcode/Project Templates/openFrameworks
~/Library/Application Support/Developer/Shared/Xcode/Project Templates/openFrameworks
</pre>
</p>

<p>場所はどこでもよかったのですが、僕は一番下の「~/Library/Application Support/Developer/Shared/Xcode/Project Templates/openFrameworks」に「xcode templates/Project Templates/openFrameworks/Mac OSX Empty Example」ディレクトリを配置し、
「$OF_ROOT/apps/projects」以下で新規プロジェクトを作成しました。ちなみに、openFrameworksのアプリケーションを作成するときは、このapps以下で作成するのがお作法のようです。（ここじゃないとライブラリがロードできなくてそもそもビルドが全く通らない）
配置後にXcodeを起動すると、新規プロジェクトでテンプレートを洗濯するダイアログでUserTemplateで配置したディレクトリ名のテンプレートが追加されていることが確認できると思います。
ところが、ここからMac OSX Empty Exampleを選択し、そのままビルドを行うと以下の２つのエラーが出てビルドできませんでした。</p>

<p><pre>
Line Location ツール:0： Command /bin/sh failed with exit code 1
Line Location ツール:0： "_usleep$UNIX2003", referenced from:
</pre></p>

<p>さすがにこれだと意味不明すぎて対応ができません。検索してもいまいちピッタリな情報がひっかからないな。。。と思って、そもそもの環境がなんかおかしいのかな、と思いapps/examples/emptyExampleをビルドしてみると、これはビルドが通ります。
と、なると「このemptyExampleをテンプレートに使えないか」の仮説で、emptyExampleを上記のパスに配置して、新規プロジェクト(プロジェクト名test)作成後にビルドしてみたところ、</p>

<p><pre>実行可能なファイルがありません</pre></p>

<p>と、ダイアログが表示され今度はビルドできません。</p>

<p>単体だとビルドが通るのに、テンプレートにしたらダメということは、命名系がなんかおかしいのかな、、と思いよくよくダイアログを見てみると、ビルドの結果test.appを実行すべきはずなのに、emptyExampleDebug.appを実行しようとして、コケてるみたい。
要するに、テンプレートが任意の実行ファイル名を受け付けるべき箇所で、exampleからファイルをコピーしてきただけなので、変数扱いされずに定数扱いされていたことが問題だったよう。そこで、templateディレクトリ配下でemptyExampleをgrepして、全部変数に置換してあげれば解決しそうです。</p>

<p>grepすると、project.pbxprojファイル内で該当文字列が発見されるので、これを「プロジェクト名.app」にしてあげます。プロジェクト名は<strong>«PROJECTNAME»</strong>を利用すると、プロジェクト作成時の名前に置き換えることができるので、これを利用します。
置換後、またまた新規プロジェクトを作成しなおし、ビルドをしてみると今度こそやっとビルドが通り、実行ファイルを実行することを確認できたとおもいます。</p>

<h3>完成したテンプレート</h3>
<p>と、いうわけで完成したテンプレートをまとめておきます。このテンプレートを元にプロジェクトを作成すると、空のウィンドウだけを起動するアプリケーションを作成できます。</p>
<p><ul>
<li><a href="https://github.com/katsuma/XcodeTemplates/tree/master/openFrameworks">https://github.com/katsuma/XcodeTemplates/tree/master/openFrameworks</a></li>
</ul></p>

<h3>まとめ</h3>
<p>openFrameworksの勉強をする前に、そもそもXcodeのカスタマイズの仕方に集中しすぎて本質から外れたことに注力しすぎちゃいました。。が、この知識を知っておけば、自分にだけ便利なオレオレスケルトンのテンプレートを作成できるので、
価値は割と大きいかな、と思えます。次回以降は、やっとコードが書ける状態になったので、実際にopenFrameworksネタで何か書きたいと思います。</p>



