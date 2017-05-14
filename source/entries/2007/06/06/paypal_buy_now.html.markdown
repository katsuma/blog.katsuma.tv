---
title: Paypalを使った「今すぐ購入」ボタンの作り方
date: 2007/06/06 00:03:27
tags: paypal
published: true

---

<p>クレジットカード決済代行サービスは<a href="http://www.google.co.jp/search?hl=ja&client=firefox&rls=org.mozilla%3Aja%3Aofficial&hs=9qv&q=%E3%82%AF%E3%83%AC%E3%82%B8%E3%83%83%E3%83%88%E3%82%AB%E3%83%BC%E3%83%89%E3%80%80%E6%B1%BA%E6%B8%88%E4%BB%A3%E8%A1%8C&btnG=%E6%A4%9C%E7%B4%A2&lr=lang_ja">少しググる</a>だけでも数多く見つかりますが、小額決済の場合は<a href="https://www.paypal.com/j1">Paypal</a>がなかなか便利です。Paypal
は、主に次のような利点があります。</p>

<p>
<ul>
<li>月々の料金なし</li>
<li>設定料金なし</li>
<li>ゲートウェイ料金なし</li>
<li>無料のeBay支払いツールとウェブ支払いツール</li>
<li>不正防止システムの追加料金なし</li>
</ul>
</p>

<p>また、<a href="https://www.paypal.com/j1/cgi-bin/webscr?cmd=_display-receiving-fees-outside">ここ</a>によると国内代金受領時の手数料も比較的低めに設定されて、魅力的です。</p>

<p>じゃダメな点は何だろう、、、といろいろ考えたのですが、利用側の立場だと特にダメな点は見つからないのが本音です。強いてあげるとすると、日本ではまだそこまで広く普及したサービスではないので、ユーザがやや戸惑う可能性がある？？と、いうことくらいです。それでも、Webページの表示は多くの言語に対応していますし、非Paypalユーザもアカウントを作ることなく決済ができるなど、非常に便利なサービスだと思います。</p>

<p>今回は、そんなPaypalについていろいろ調べていたのですが、あまりにもちゃんとまとまった日本語の情報が少ない、ということでそのあたりをまとめてみつつ、「今すぐ購入」ボタンの作り方までをまとめておきたいと思います。</p>

<h3>ドキュメント</h3>
<p>Paypalのサイトはお世辞にも構造が分かりやすいとはいえないです。でも非常に１つ１つのドキュメントの質は高く、うまく見つけて全部読みこなせるか、がポイントになります。重要だと思ったドキュメントは次の通りです。</p>

<ul>
<li><a href="https://www.paypal.com/j1/cgi-bin/webscr?cmd=_display-approved-signup-countries-outside">Paypal対応国一覧</a></li>
<li><a href="https://www.paypal.com/j1/cgi-bin/webscr?cmd=_resource-center">支払いソリューション一覧</a>（超重要。主要なPDFは全部ココ）</li>
<li>[PDF] <a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/JP/pdf/PP_WebsitePaymentsStandard_IntegrationGuide.pdf">ウェブサイト支払いスタンダードインテグレーションガイド</a>（全体的な説明）</li>
<li>[PDF] <a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/JP/pdf/PP_OrderManagement_IntegrationGuide.pdf">注文管理インテグレーションガイド</a>（バックエンドとの統合に重要なPDT、IPNについて）</li>
<li>[PDF] <a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/pdf/PP_Sandbox_UserGuide.pdf">Sandbox ユーザーガイド</a> （Sandbox特有の設定、仕様などについて）</li>
</ul>


<h3>今すぐ購入</h3>
<p>Paypalを使って決済代行サービスを利用するにあたって、すぐに導入できるのは「今すぐ購入」機能です。Paypalのバナーをクリックすることで、Paypalサーバに処理が移り、決済が終了すると自サイトにまた戻ってくる仕掛けです。このバナーの作成方法はいたって簡単で、必要なinputタグをルールに従って生成するだけです。次のような手順をたどればOKです。</p>
<ol>
<li>Paypalにログイン</li>
<li>マーチャントタブをクリック</li>
<li>右の方にさりげなくある「主要機能」の中の「[今すぐ購入]ボタン」をクリック</li>
<li>販売する商品の情報を入力します。内容は文面の通りですが、いくつかポイントがあるので述べておきます。
<ul>
<li>「商品ID/番号」・・・あとで管理画面からトラッキングするためのIDになります</li>
<li>「セキュリティ設定」・・・いろいろ機能が制限されるので、暗号化しないように「いいえ」を選択</li>
<li>「オプション」を追加をクリック</li>
</ul>
</li>
<li>「ボタンを作成」で「今すぐ購入」用のHTMLが作成されるので、これを既存のHTMLに埋め込みます。</li>
</ol>

<p>たとえば「$10」の「はじめてのカツマテレビ」という商品のコードを上のルールに従って生成するとこんな感じのHTMLが仕上がります。</p>

<p><pre>
&lt;form action="https://www.paypal.com/cgi-bin/webscr" method="post"&gt;
&lt;input type="hidden" name="cmd" value="_xclick"&gt;
&lt;input type="hidden" name="business" value="katsuma@xxxx.com"&gt;
&lt;input type="hidden" name="item_name" value="はじめてのカツマテレビ"&gt;
&lt;input type="hidden" name="item_number" value="hajimete_katsumatv"&gt;
&lt;input type="hidden" name="amount" value="10.00"&gt;
&lt;input type="hidden" name="no_shipping" value="0"&gt;
&lt;input type="hidden" name="no_note" value="1"&gt;
&lt;input type="hidden" name="currency_code" value="USD"&gt;
&lt;input type="hidden" name="lc" value="JP"&gt;
&lt;input type="hidden" name="bn" value="PP-BuyNowBF"&gt;
&lt;input type="image" src="https://www.paypal.com/ja_JP/i/btn/x-click-but23.gif" border="0" name="submit" alt="お支払いはPayPalで - 迅速、無料、安全です"&gt;
&lt;img alt="" border="0" src="https://www.paypal.com/ja_JP/i/scr/pixel.gif" width="1" height="1"&gt;
&lt;/form&gt;
</pre></p>

<p>これでとりあえずPaypalにリクエストを投げるところまでができました。売るモノ（たとえば物品など完全に売り切りのモノ）によっては、これだけでも終了、なのですがせっかくなんでユーザＩＤと結びつけるなどのバックエンドとの統合についても考えて見たいと思いますが、これについては次のエントリーで述べたいと思います。</p>

