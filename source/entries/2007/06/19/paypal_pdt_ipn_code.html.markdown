---
title: Paypal「PDT」「IPN」を使った決済とバックエンドの統合(2)
date: 2007/06/19
tags: paypal
published: true

---

<p>今回も<a href="http://blog.katsuma.tv/develop/paypal/">Paypalシリーズ</a>の続きです。前回まではこれらのエントリーをご参照ください。</p>

<p>
<ul>
<li><a href="http://blog.katsuma.tv/2007/06/paypal_buy_now.html">Paypalを使った「今すぐ購入」ボタンの作り方</a></li>
<li><a href="http://blog.katsuma.tv/2007/06/paypal_pdt_ipn_intro.html">Paypal「PDT」「IPN」を使った決済とバックエンドの統合(1)</a></li>
</ul>
</p>

<p>さて、前回まででPaypalを利用した場合の自サイトとPaypalサイトとのデータの流れについて、概略を説明しました。今回はその中でPDT、IPNを実際に実装する際の注意点についてまとめておきたいと思います。今回の話は、主に次のPDFファイルの内容を重要な点だけまとめ直して、ハマった点を追記したものなので、あわせて読まれることをお勧めします。</p>

<p>
<ul>
<li><a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/JP/pdf/PP_OrderManagement_IntegrationGuide.pdf">注文管理インテグレーションガイド</a></li>
<li><a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/pdf/PP_Sandbox_UserGuide.pdf">Sandbox ユーザーガイド</a></li>
</ul>
</p>

<h3>Sandbox</h3>
<p>いきなり本物のクレジットカード情報でやりとりをするわけにはいかないので、閉じられたテスト環境内でまずは実験を行うことになります。Paypalは、このテスト環境を提供するためにSandboxという概念のサービスを提供しています。</p>

<p>Sandboxを利用する際は、まず<a href="https://developer.paypal.com/">PayPal Developer Central</a>のアカウントを取得する必要があります。「Sign Up Now」から登録フォームを埋めていきます。埋め終わると、確認メールが届く。。。はずなのですが、僕は登録したときにメールがまったく届きませんでした。とりあえず登録したアドレス情報でログインできるかな？と思ったけど無理。と、いうのもメールアドレスが認証されないとログインできないんですね。</p>

<p>困り果ててPaypalに「何とかしてくれ」メールを投げた結果「障害起きてるんでちょっと待ってくれ。でもいつ直るかわかんない」と、まぁなかなか投げやりな返事。。。結果、１日後に確認メールが届かないままいつの間にやらログイン可能になっていました。Developer CentralはForumを見ている限り、結構サーバエラーが起こっているようなので、怪しい挙動をしているときは、ForumにPOSTしてみるなり、Paypalに直接メールしてみるなりしてみてもいいと思います。</p>

<p>Developer Centralにログインできたら、今度はSandboxで利用するテストユーザを作成します。ログイン後、「Sandbox」のタブをクリックし、「Create Account」でテストユーザが作成できます。ここで複数のアカウントを作成すると、作成したアカウント間で（閉じたSandboxの空間内において）支払いを行うことができます。僕は</p>

<p>
<ul>
<li>サービス提供者（Businessアカウント）</li>
<li>サービス購入者1（Personalアカウント）</li>
<li>サービス購入者2（Businessアカウント）</li>
</ul>
</p>

<p>の３人分のアカウントを作成し、テストを行いました。</p>

<p>また、ここで作成したSandbox内のPaypalアカウントのクレジットカード番号の情報は、Sandbox内において使うことが可能です。つまり、「（Sandboxにおける）アカウントは持っていないが、クレジットカードは持っている」というユーザの環境のテストを行うことも可能です。なので、アカウントを作成する際は、ユーザの全情報（ID、Password、メールアドレス、姓、名、電話番号、CC番号など）をメモっておくと、後でテストの際に便利になります。アカウントを作成した後は、Developer Centralにログイン後、「Sandbox」のタブから、アカウントをラジオボタンで選択して「Launch Sandbox」のボタンをクリックすることで、Sandboxが起動できます。</p>


<h3>PDT</h3>
<p>PDTは<a href="http://blog.katsuma.tv/2007/06/paypal_pdt_ipn_intro.html">以前のエントリー</a>で述べたとおり、Webのフローと同期してPayplaから自サイトに対して決済が完了した旨を呼び出す仕組みです。当然Paypal以外の第三者からや、決済完了を偽装した不正な命令が実行される可能性があるので、PDTを受け付けるサーバサイドのスクリプトは、PDTの内容を検証する必要があります。</p>

<p>まずは、PDTの機能を有効にします。PDTを有効にするためには、</p>

<p>
<ol>
<li>Developer Centralにログイン</li>
<li>サービス提供者のアカウントを選択した上で、Sandboxを起動します。</li>
<li>指定アカウントでログインし、「マイアカウント」タブの「プロファイル」サブタブをクリックします。</li>
<li>「販売の設定」から「ウェブサイト支払いの設定」をクリックします。</li>
<li>「ウェブサイト支払いの自動復帰」を「オン」にし、「復帰URL」を設定します。このURLがPDTがPOSTされるURLになります。</li>
<li>「支払いデータ転送」をオンにします。</li>
<li>「保存」をクリックし、PDT設定を保存すると設定が正常に保存されたことが表示され、同時に「IDトークン」も表示されます。このIDトークンはPDTの検証で必要になるのでメモしておきます。</li>
</ol>
</p>

<p>PDTの設定が終わったら、とりあえずテスト的に「今すぐ購入」ボタンから決済画面に飛び、決済フローを行ってみます。ここでSandboxでのテストを行うために気をつける点が１点あります。</p>

<h4>Sandboxでのテスト実行上の注意</h4>
<p>Sandboxでのテストを行うときに、PaypalへリクエストURLは</p>
<p>
<pre>http://www.paypal.com/*</pre>
</p>
<p>ではなく、</p>
<p>
<pre>http://www.sandbox.paypal.com/*</pre>
</p>
<p>となり、<strong>sandbox.</strong>をpaypal.の前に付け加えます。これは、Paypalにリクエストを投げる場合における全URLが対象となります。なので、開発する際はこの情報はまとめて変数定義しておいて、本番環境にはすぐに差し替えが可能なように行っておくといいでしょう。</p>

<p>さて、PDTが実際に行われたとき、つまり「復帰URL」に対してリクエストが発行されるときは、そのデータはすべてHTTP GETで送信されてきます。PDTの検証を行う場合、このGETで渡されたデータを次の手順で検証していきます。</p>

<p>
<ol>
<li>変数「cmd」に対して、値「_notify-synch」を設定
<p><pre>cmd=_notify-synch</pre></p>
</li>
<li>変数txで「取引トークン（取引毎の固有なセッション情報みたいなもの）」が渡されるので、同じく<p><pre>tx=<em>value_of_transaction_token</em></pre></p>
の形で設定</li>
<li>変数atに対して、PDT設定時に生成されたIDトークンの値を
<p><pre>at=<em>your_identify_token</em></pre></p>
と、設定します。
</li>
<li>これらの情報をまとめて
<p><pre>http://www.paypal.com/cgi-bin/webscr</pre></p>にPOSTします。もちろんsandbox内では<strong>www.sandbox.paypal.com</strong>になるので注意です。</li>
</ol>
</p>

<p>POST実行後は、PaypalからPOST内容の検証が行われ、その返答が帰って来ます。返答内容は、本文の１行で「SUCCESS」または「FAIL」の１ワードを含めて、NVP形式（name=value形式）で取引の明細データが返ります。たとえばこんな感じ。</p>

<p>
<pre>
SUCCESS
first_name=Jane+Doe
last_name=Smith
payment_status=Completed
payer_email=janedoesmith%40hotmail.com
payment_gross=3.99
mc_currency=USD
</pre>
</p>

<p>ポイントはまず<strong>SUCCESS</strong>が返っているかどうか。ここでSUCESSになっていない場合は、不正なPDTのPOSTバックか、またはPDTの設定が間違っていることになります。取引トークンtxがおかしくないか、IDトークンatはおかしくないか、トークンの期限が切れていないか、なんかの確認をしてみてもいいかもしれません。</p>

<p>また、「payment_status」が、<strong>Completed</strong>になっているかもポイントです。Completed以外は、即時決済されていない場合なので、支払い完了のメッセージを出力する際は要注意です。</p>

<p>これらをまとめてPaypalで<a href="https://www.paypal.com/us/cgi-bin/webscr?cmd=p/xcl/rec/pdt-code">PDTのサンプルソース</a>があります。僕はPHPを利用しているので、PHPのサンプルを参考に実装しました。Paypalのコードはfsockopenを使っていますが、curlを使ってあげるともう少し分かりやすく書けるかもです。PHPのコードはこんな感じになっています。出力部分ははしょってます。</p>

<p>
<pre>
&lt;?php
// read the post from PayPal system and add 'cmd'
$req = 'cmd=_notify-synch';

$tx_token = $_GET['tx'];
$auth_token = "GX_sTf5bW3wxRfFEbgofs88nQxvMQ7nsI8m21rzNESnl_79ccFTWj2aPgQ0";
$req .= "&tx=$tx_token&at=$auth_token";

// post back to PayPal system to validate
$header .= "POST /cgi-bin/webscr HTTP/1.0\r\n";
$header .= "Content-Type: application/x-www-form-urlencoded\r\n";
$header .= "Content-Length: " . strlen($req) . "\r\n\r\n";
$fp = fsockopen ('www.paypal.com', 80, $errno, $errstr, 30);
// If possible, securely post back to paypal using HTTPS
// Your PHP server will need to be SSL enabled
// $fp = fsockopen ('ssl://www.paypal.com', 443, $errno, $errstr, 30);

if (!$fp) {
// HTTP ERROR
} else {
fputs ($fp, $header . $req);
// read the body data
$res = '';
$headerdone = false;
while (!feof($fp)) {
$line = fgets ($fp, 1024);
if (strcmp($line, "\r\n") == 0) {
// read the header
$headerdone = true;
}
else if ($headerdone)
{
// header has been read. now read the contents
$res .= $line;
}
}

// parse the data
$lines = explode("\n", $res);
$keyarray = array();
if (strcmp ($lines[0], "SUCCESS") == 0) {
for ($i=1; $i&lt;count($lines);$i++){
list($key,$val) = explode("=", $lines[$i]);
$keyarray[urldecode($key)] = urldecode($val);
}
// check the payment_status is Completed
// check that txn_id has not been previously processed
// check that receiver_email is your Primary PayPal email
// check that payment_amount/payment_currency are correct
// process payment
$firstname = $keyarray['first_name'];
$lastname = $keyarray['last_name'];
$itemname = $keyarray['item_name'];
$amount = $keyarray['payment_gross'];

}
else if (strcmp ($lines[0], "FAIL") == 0) {
// log for manual investigation
}

}

fclose ($fp);

?&gt;
</pre>
</p>


<h3>IPN</h3>
<p>IPNは、PDTとは違い、支払いが終了したとき、また支払い状態が「Pending」の場合において決済されたとき、失敗したとき、拒否されたときにも別の通知を受け取ることになります。
PDTとは異なり、そのPOSTが実行されるタイミングはWebの決済フローとは非同期のため、IPNの処理スクリプトはブラウザに結果を返すようなものではなく、バックエンドの処理のみを行うものとなります。
</p>

<p>IPNを開始するためには、Paypalプロファイルの設定を変更するか、Webサイトの支払いフォームにnotify_url変数を追加します。僕はプロファイルの設定から次のような設定を行いました。</p>

<p><ol>
<li>Paypalビジネスアカウント、またはプレミアアカウントにログイン</li>
<li>「プロファイル」サブタブをクリック</li>
<li>「販売の設定」「即時支払い通知の設定」をクリック</li>
<li>「編集」をクリック</li>
<li>チェックボックスをクリックし、IPNのPOSTを処理するスクリプトのURLを入力し、「保存」を行います。</li>
</ol></p>

<p>IPNの処理の仕掛けとそいては次のような手順を必要とします。</p>

<p>
<ol>
<li>変数「cmd」に、値「_notify-validate」をセット。
<p><pre>cmd=_notify-validate</pre></p>
</li>
<li>FORM変数に、IPNで受け取った全ての変数、値のセットをそのままの組でPOST</li>
<li>POSTするURLは「https://www.paypal.com/cgi-bin/webscr」</li>
</ol>
</p>

<p>もちろんURLはSandbox上でのPOSTバックを行う場合、「https://www.sandbox.paypal.com/cgi-bin/webscr」になります。また、上記のルールでPaypal側にPOSTすると、応答の本文に「VERIFIED」または「INVALID」の１ワードを含めて、NVP形式の文字列のPOSTバックが行われます。このとき、正当にPaypalにPOSTバックを行っていた場合、VERIFIEDが返されるので、主に次の点を確認します。</p>

<p>
<ol>
<li>変数payment_statusｇた「Completed」かどうかを確認</li>
<li>txn_idが処理済みの過去のデータと比較し、重複していないか確認</li>
<li>商品名item_name、価格mc_gross、通貨mc_currencyなどが正しいかどうかを確認</li>
</ol>
</p>

<p>ここで、一点要注意な点があります。それは<strong>文字コードには相当注意そいなければいけない、ということです。</strong>僕は普段、HTML, CSS, JavaScript, PHP, MySQLの保存データなど、もろもろのデータは全てUTF-8で統一しています。（厳密にはActionScriptはITF-8、それ以外はUTF-8Nです。）そこで、当然Paypalに最初データを渡すときもUTF-8で渡しているのですが、IPNで返ってくるデータは、<strong>何も設定をしなければマルチバイト文字が含まれている場合は「Shift-JIS」に、マルチバイトを含んでいない場合は「Windows-31J」になります。</strong></p>

<p>これは非常に厄介すぎます。文字コードの処理に失敗すると、上記ルールのとおりPaypalから呼ばれたNVPの変数＆値を「そのまま」送っても、文字コードの関係上不正なデータとみなされるケースもあるのです。（と、いうか僕はずっとみなされました）。では、どうするのかというと、PaypalからのPOSTデータは、<strong>全てUTF-8で固定にしてしまえばよいのです。</strong></p>

<p>Paypalからのコールされるデータの文字コードの変換方法は、次の通りです。</p>

<p>
<ol>
<li>「マイアカウント」→「プロファイル設定」→「言語のエンコード」「詳細オプション」</li>
<li>「エンコード方式」をUTF-8に</li>
<li>「PayPalから送信されたデータと同じエンコード方式を使用しますか(IPN、ダウンロード可能なログ、メールなど)?」を「UTF-8」</li>
</ol></p>

<p>で、OKです。ここでIPNの具体例のコードサンプルを書いておきます。PHPのサンプルを書いておきましが、それ以外の言語のサンプルコードは<a href="https://www.paypal.com/j1/cgi-bin/webscr?cmd=p/pdn/ipn-codesamples-pop#php">ここ</a>にあるので、あわせてご参照ください。</p>

<p>
<pre>
&lt;?php
//PayPalシステムからポストを読み込み、「cmd」を追加
$req = 'cmd=_notify-validate';

foreach ($_POST as $key =&gt; $value) {
$value = urlencode(stripslashes($value));
$req .= "&$key=$value";
}

// PayPalシステムへポストバックして検証
$header .= "POST /cgi-bin/webscr HTTP/1.0\r\n";
$header .= "Content-Type:application/x-www-form-urlencoded\r\n";
$header .= "Content-Length:" . strlen($req) ."\r\n\r\n";
$fp = fsockopen ('www.paypal.com', 80, $errno, $errstr, 30);

// ポストされた変数をローカル変数に割り当て
$item_name = $_POST['item_name'];
$item_number = $_POST['item_number'];
$payment_status = $_POST['payment_status'];
$payment_amount = $_POST['mc_gross'];
$payment_currency = $_POST['mc_currency'];
$txn_id = $_POST['txn_id'];
$receiver_email = $_POST['receiver_email'];
$payer_email = $_POST['payer_email'];

if (!$fp) {
// HTTPエラー
} else {
fputs ($fp, $header .$req);
while (!feof($fp)) {
$res = fgets ($fp, 1024);
if (strcmp ($res, "VERIFIED") == 0) {
// payment_statusがCompletedであることを確認
// txn_idが現在までに処理されていないか確認
// receiver_emailがお客様のPayPal主メールアドレスであることを確認
// payment_amountとpayment_currencyが正しいことを確認
// 支払いを処理
}
else if (strcmp ($res, "INVALID") == 0) {
//手動での調査のログ
}
}
fclose ($fp);
}
?&gt;


</pre>
</p>

<h3>ユーザの声も大事に</h3>
<p>PDT/IPNの開発で困ったときは、<a href="http://www.pdncommunity.com/">フォーラム</a>がかなり役たちます。自分が困っていることは、大抵世界中の人たちも困っていることがほとんどなので、同じような質問を捜してみることをおすすめします。</p>

<p>また、IPNのテストとして、サードパーティのテストサイトもトラブル解決の手立てになるかと思います。<a href="http://paypaltech.com/Patrick/ipntstips.htm">こちら</a>や<a href="http://paypaltech.com/Stephen/test/ipntest.htm">こちら</a>もあわせて参考ください。</p>
