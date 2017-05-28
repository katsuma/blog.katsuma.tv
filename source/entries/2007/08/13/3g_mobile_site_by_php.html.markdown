---
title: PHP+Smartyで3G携帯サイトを効率的に構築する
date: 2007/08/13 23:47:50
tags: php
published: true

---

最近、新規プロジェクト案件で携帯サイトの構築についていろいろ調査をしています。最初から携帯サイトの構築については、
かなりいろいろな点で懸念はしていたのですが、蓋を開けてみると「やはり、、」と、いうかハマる点がかなり多いです。

そもそも、今回のプロジェクトにおいていろいろなサイトを調査していたのですが、
まだまだPCサイト（XHTML+CSS+JavaScriptなサイト）に比べて、有益な情報がまとまっていないなぁ、、という感想です。
<a href="http://labs.unoh.net/">ウノウラボ</a>さんは本当に素晴らしい情報を開示してくださっていると思いましたが、
かゆいところに手が届くような情報はまだまだ世の中に広がっていないようですので、
僕が調べた点や、実装を進める上で得たTipsなどを共有していきたいと思います。
そこで、今回はPHPで携帯サイトを実装する上でのTipsを記しておきたいと思います。

### 対象機種を3Gに絞る
携帯サイトの構築で最も問題なのが、キャリアや機種に依存する問題があまりに多くて、検証作業が非常に困難な点が挙げられます。
携帯サイトの老舗開発会社であればノウハウや検証体制なども確固たるものがあるでしょうが、自分たちのような新規参入会社にとって、これらを行うことはほぼ不可能です。

ところが、対象機種を<strong>3Gに絞る</strong>ことで、この問題はかなりシンプルになります。
携帯サイトでHTMLの文字コードはハマる点なのですが、<strong>対象機種を3Gに絞ることで、
表示HTMLの文字コードをUTF-8のみ</strong>にすることが可能になります(*)。
UTF-8なサイトであれば、PCサイトでも手がけたことがある人は多いと思いますので、そのノウハウを利用することができます。(*)
ちなみに、この「UTF-8縛り」は、各キャリアの仕様＋社内の全携帯を利用した検証、シミュレータによる検証結果より、この結論に至りました。
もし反例がありましたらコメントなどでお願いします。

### ロジックは1ファイル, 表示はキャリア毎
と、いうわけでPHPでサイトロジックを実装する場合、FedoraなどのUTF-8な環境であれば特に気を付けることはなく、普段通りの実装をすればOKです。ただし、ビューの部分で絵文字を使う場合、各キャリア毎に絵文字のコードが異なっています。そのため絵文字込みのサイトを作る場合は、

<ol>
<li>ビューのファイル（たとえばSmartyのtplファイル）も１つでキャリアごとの絵文字変換テーブルを作成して表示</li>
<li>絵文字込みのtplファイルをキャリア毎に作成し、キャリア毎にtplを切り替えて利用</li>
</ol>

の、どちらかを選択することになるかと思います。メンテを考えると前者の方が楽なんですけども、
絵文字以外にもキャリアごとに利用できる(X)HTMLタグもやや異なっているため、今回は後者を利用することとしました。実際のコードは次のようにしました。


### ディレクトリ構成

smarty/templates/以下に、同じ構成を保ったdcm,sb,auディレクトリを作成します。各ディレクトリ内にはtplファイルを配置します。

```

webapps/
  +- smarty/
  |       +- templates/
  |              +- dcm/
  |                    +- *.tpl
  |              +- sb/
  |                    +- *.tpl
  |              +- au/
  |                    +- *.tpl
  |              +- pc/
  |                    +- *.tpl
  |- mysmarty.php
```

webapps直下にはSmartyクラスを継承したMySmartyクラスを定義したmysmarty.phpを設置します。
mysmarty.phpの内容は次のようなものになります。

```

<?php

require_once('Smarty.class.php');

function &getMySmarty()
{
	static $singleton;

	if (empty($singleton)) {
		$singleton = new MySmarty();
	}
	return $singleton;
}

class MySmarty extends Smarty {

   function MySmarty() {

		// Constructor
		$this->Smarty();

		// set Smarty dir,
		$this->template_dir = WEB_APP_SMARTY_DIR . '/templates/';
		$this->compile_dir  = WEB_APP_SMARTY_DIR . '/templates_c/';
		$this->config_dir   = WEB_APP_SMARTY_DIR . '/configs/';
		$this->cache_dir    = WEB_APP_SMARTY_DIR . '/cache/';

   }

   function show($tpl){
		$carrier = get_carrier();
		$this->display($carrier . "/" . $tpl);
		return;
   }
}
?>
```

ここでは、$smarty->displayメソッドをラップするshowメソッドを用意しています。キャリア判定を行い、
templatesディレクトリ以下の「<キャリア>/*.tpl」を表示させています。

get_carrier関数は、User-Agentからキャリア判定を行うか、IPアドレスで判定を行えばOKです。今回はUAで判定する次のような実装を行いました。

```

function get_carrier(){
	$http_ua = $_SERVER['HTTP_USER_AGENT'];
	$carrier = '';
	if(preg_match("/DoCoMo/",$http_ua)){
		$carrier = 'dcm';
	}elseif(preg_match("/SoftBank/",$http_ua) || preg_match("/Vodafone/",$http_ua) || preg_match("/J-PHONE/",$http_ua) ||
		preg_match("/J-EMULATOR/",$http_ua) || preg_match("/Vemulator/",$http_ua) || preg_match("/MOTEMULATOR-/",$http_ua)){
		$carrier = 'sb';
	}elseif(preg_match("/KDDI-/",$http_ua) || preg_match("/UP\.Browser/",$http_ua)){
		$carrier = 'au';
	}else{
		$carrier = 'pc';
	}
	return $carrier;
}
```

実際にこれらのコードを利用するときは、

```

$smarty =& getMySmarty();
$smarty->show('index.tpl');
```

こんな感じになります。ここではdcm/index.tpl, sb/index.tpl, au/index.tplを参照することになります。
これで、ロジックは共通にしながらも、サクサクと絵文字ふんだんなテンプレートを切り替えて、携帯サイトを構築できるかと思います。

### まだまだ謎なことは多い
携帯の世界は自分にとってまだまだ闇で未知なることが多いです。
絵文字、デコメ、Flash、動画再生・・・など仕様が非公開だったり、まとまった情報が無いものがまだまだかなり多いです。

### まだまだこの世界は伸びるよ！
だからこそ、ひょんなことからブレイクスルーをおこせる可能性がまだまだ潜んでるわけです。
みんなもっと携帯サイトのノウハウについてBlog書くべき！知識、テクを共有すべき！
