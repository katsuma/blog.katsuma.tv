---
title: CakePHPでBasic認証対応ページを作る
date: 2008/07/30
tags: php
published: true

---

<p>1.2だとBasic認証対応ページを作るのも超簡単です。</p>

<h3>対応させたいControllerにSecurityコンポーネントを適用</h3>
<p>まずSecurityコンポーネントを利用します。</p>
<p><pre>
	class HogeController extends AppController {
		var $name = 'Hoge';
		var $uses = array('Hoge');
		<strong>var $components = array('Security');</strong>
                ...
       }
</pre></p>

<h3>認証情報を追加</h3>
<p>beforeFilterに認証に必要な情報を追加します。</p>
<p><pre>
		function beforeFilter(){
			parent :: beforeFilter();			
<strong>
			$this->Security->loginOptions = array('type'=>'basic');
			$this->Security->loginUsers = array('katsuma'=>'katsukatsu');
			$this->Security->requireLogin('*');
</strong>
		}
</pre></p>

<p>ここではUser:katsuma, Pass:katsukatsuの認証情報で、全アクションで認証を必要とさせています。認証を特定のアクションのみに限定させたいときは、requireLoginメソッドで、認証を実行するアクション名のリストを指定します。基本的には必要なことはこれだけです。簡単！</p>

<h3>Formは要注意</h3>
<p>一点、要注意な事項としてFormを必要とするView、たとえば何らかのPostを実行するようなFormのViewがあるときに、その<strong>Formを構成する要素はすべてFormヘルパを利用する必要がある</strong>ということです。</p>

<p>inputタグなんかの要素はもちろん、たとえばformタグを書き出すときも</p>

<p><pre>
&lt;form action="/Hoge/add"
</pre></p>

<p>とかじゃダメで、</p>

<p><pre>
&lt;?php e($form->create('Hoge', array('action'=>'add')))?&gt;
</pre></p>

<p>じゃなければダメです。（こうしないと認証がかからない）</p>

<p>これはどうもヘルパを利用すると、Tokenのようなものを全要素に対して自動的に追加して、このTokenがちゃんと追加されていないとSecurityコンポーネントが働かないようです。「formタグくらいどうでもいいだろー」とタカをくくってて、痛い目にあったので皆さんもご注意ください。。<p>


