---
title: MecabとLingua::JA::Summarizeで文章のキーワード抽出をCakePHPで
date: 2008/11/12
tags: php
published: true

---

<p>文章中のキーワード抽出を行いたくなっていろいろ調べていて、次の組み合わせで実現することができました。</p>

<p><ul>
<li>Mecab</li>
<li>Lingua::JA::Summarize</li>
<li>Pecl/Perl</li>
</ul></p>

<p><a href="http://mecab.sourceforge.net/">Mecab</a>は文書の形態素解析に。<a href="http://labs.cybozu.co.jp/blog/kazuho/archives/2006/05/ljs-0_04.php">Lingua::JA::Summarize</a>はサイボウズラボ奥さんのキーワード抽出CPANモジュール。これをCakePHPに組み込みたかったのでPeclのPerlライブラリ（PHPからPerlのコードをダイレクトに呼べる）。導入も特に難しくないので、その導入メモを残しておきます。</p>

<h3>Mecab</h3>
<p>Fedora系Linuxだとyumで辞書ファイルも一緒にさっくりインストールできます。Perlのモジュールも入れておきます。</p>
<p><pre>
sudo yum -y install mecab\*
sudo yum -y install perl-mecab\*
</pre></p>

<h3>Lingua::JA::Summarize</h3>
<p>CPANからインストールできるのですが、僕の環境だとテストでエラーになるのでforce installします。あと、実行時エラーも出たので、次のようにインストールすると回避できました。あらかじめ</p>

<p><pre>
alias cpan='perl -MCPAN -e shell'
</pre></p>

<p>と、しています。</p>

<p><pre>
sudo cpan
install HTML::Strip
install Jcode
install Class::ErrorHandler
force install Lingua::JA::Summarize
</pre></p>

<h3>Pecl/Perl</h3>
<p>これもpeclコマンドでOKです。あらかじめ次のものをインストールしておいたほうがいいかも。２行目の「sudo yum -y install perl-\*」はちょっと強引すぎる気が自分でもしてるのですが、何かしらのperl系モジュールがないとpecl/perlのインストールにコケてしまったことは確か。（このあたりの詳細のメモを失念。。。）</p>

<p><pre>
sudo yum -y install php-devel
sudo yum -y install perl-\*
</pre>
</p>

<p>この上で</p>
<p><pre>
sudo pecl install pecl/perl
</pre></p>

<p>また、extensionにperl.soを登録します。</p>
<p><pre>
sudo vi /etc/php.d/perl.ini
</pre></p>

<p>で、次の１行を追加。</p>
<p><pre>
extension=perl.so
</pre></p>

<p>これで、Apacheを再起動するとPHPでキーワード抽出が可能になります。</p>

<h3>CakePHPに設置</h3>
<p>app/vendors にLingua/JA/ディレクトリを作成し、そこにSummarize.phpを作成します。</p>
<h4>Summarize.php</h4>
<p><pre>
&lt;?php
class Summarize{
	
	private $summarize;
	
	public function __construct(){
		
		$perl = new Perl();
		$perl-&gt;eval('use HTML::Strip;');
		$perl-&gt;eval('use Lingua::JA::Summarize;');
		
		$this-&gt;summarize = new Perl ("Lingua::JA::Summarize", "new",
			array(
				"charset" =&gt; 'utf8',
				"mecab_charset" =&gt; 'utf8',
				"default_cost" =&gt; 2.5,
				"singlechar_factor" =&gt; 0.2
				)
			);
	}
	
	function getKeyword($key, $maxNum=15){
		$this-&gt;summarize-&gt;analyze($key);
		return $this-&gt;summarize-&gt;array-&gt;keywords(
			array(
				"threshold" =&gt; 5,
				"minwords"  =&gt; 1,
				"maxwords"  =&gt; $maxNum
			)
		);
	}
}
?&gt;
</pre></p>

<p>これをapp/config/bootsrrap.phpで読み込ませます。次の１行を最後に追加。</p>
<p><pre>
App::import( 'Vendor', 'Summarize' , array('file'=>'Lingua' . DS . 'JA'  . DS . 'Summarize.php'));
</pre></p>

<p>これでキーワード抽出用のモジュールSummarizeが読み込まれるので、たとえばControllerで次のような処理を行うことができます。</p>

<p><pre>
$summarize = new Summarize();
$keys = $summarize-&gt;getKeyword($word, $num);
</pre></p>

<p>$wordは抽出対象の文章、$numは抽出キーワード数です。$keysは抽出されたキーワードの配列が返ります。返ってくるキーワードの抽出に違和感があれば、Summarize.phpのdefault_cost、singlechar_factorあたりをチューニングしてみましょう。このあたりのパラメータについては<a href="http://labs.cybozu.co.jp/blog/nakatani/2007/03/_linguajasummarize.html">奥さんのドキュメント</a>が最も分かりやすくまとまっていると思います。</p>


