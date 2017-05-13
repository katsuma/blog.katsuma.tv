---
title: CakePHPでランダムにレコードを取得する独自findメソッド
date: 2008/06/27
tags: php
published: true

---

<p>CakePHPも1.2になって、findAllが非推奨になってfind('All')に置き換わったように、findHoge系なメソッドは全部findに集約して、第一引数でそのselectタイプを指定するように仕様が変更になりました。最初はこの流れはちょっと面倒くさいなぁとも思ったのですが、実際は自分の都合のいいようなタイプをどんどん追加しやすくなっているので、この仕掛けはうまく使えばすごく便利。</p>

<p>たとえば、タイトルのようなもの。あるUserテーブルの中からランダムに50人分のレコードを取り出すfind('random')とか実装したいときはこんな感じ。</p>

<p><pre>
&lt;?php
class User extends AppModel {
	var $name = 'User';
	function find($type, $queryData = array()){
		switch ($type) {
			case 'random':
				return $this-&gt;find('all', 
					array(
						'order' =&gt; 'rand()',
						'limit' =&gt; 50
					)
				);
			default:
				return parent::find($type, $queryData);
		}
	}	
}
?&gt;
</pre></p>

<p>$typeで追加したいタイプを指定してswitchで振り分け、defaultのタイプについては親クラスのfindにそのまま処理を丸投げすることで、シンプルな機能拡張ができます。</p>

<p>あと、MySQLだと"order by rand()"でランダムに並び替えができるので、これを利用して先頭50件を取得しています。単純にランダムにするだけだとlimitはもちろんなしでOK。これ見たら分かると思いますけど、すごく簡単に機能拡張できるのがいいかんじ。最新20件を取得する「find('latest')」や、人気の20件を取得する「find('popular')」みたいなメソッドとか作っておくと、使い回し効きそう。</p>

<h3>ところで</h3>
<p>上で例で挙げたレコードのランダム取得とか、ついfind('All')でとりあえず全件取得してからcontrollerでごちゃごちゃした処理をかいたり、find('All')の第二引数で技巧的なオプションをつけてみたりしがちだけども、あらかじめメソッドを追加しておいたModelに丸投げしておくとcontrollerがすっきりシンプルになって、結果的に可読性もあがってよさげ。自分もfindの後でごちゃごちゃした処理をよく書いていたので、これを機にModelに処理を任せるようにいろいろリファクタリングしようと思います。</p>

<p>このあたりの話は、CakePHP開発者メンバーによる「<a href="http://c7y.phparch.com/c/entry/1/art,mvc_and_cake">Best Practices in MVC Design with CakePHP (php|architect’s C7Y)</a>」がすごくいい話で、さらに<a href="http://www.sooey.com/journal/2008/03/26/717/">Sooeyさんがこれを和訳してくださってる</a>のが素晴らしくいい感じ。Cakeに限らずMVCモデルなフレームワークの一般的な話としても通じる話だとお思うので、このあたりに携わる人とすれば一度目を通しておいて損はないと思います。</p>


