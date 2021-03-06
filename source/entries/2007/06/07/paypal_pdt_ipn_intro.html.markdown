---
title: Paypal「PDT」「IPN」を使った決済とバックエンドの統合(1)
date: 2007/06/07 22:39:51
tags: paypal
published: true

---

<p>前回のエントリー<a href="http://blog.katsuma.tv/2007/06/paypal_buy_now.html">「Pyapalを使った「今すぐ購入」ボタンの作り方 」</a>の続きです。今回、および次回ではPaypalの決済を終えた後に、Paypalからコールバックされる情報を元に、バックエンドとの統合方法、およびマルチバイトを扱う際の注意ポイントを解説していきます。</p>

<p>Paypalからコールバックされる仕掛けは<strong>PDT(支払いデータ転送)</strong>、および<strong>IPN(即時支払い通知)</strong>の２種類があります。これらは一見似ているもので、実際コールバックされる内容はほぼ同じだったりするのですが、実はまったく違う仕掛けなものなので、どちらか一方だけを考慮してもダメで、両方のコールバックともに考慮すべきものです。これらの違いは次の通りです。</p>

<h3>PDT</h3>
<p>PDT の主要機能は、買い手が支払い完了時に自Paypalのサイトから自サイトに自動的にリダイレクトされた時に、支払い取引の詳細を表示することです。つまり、Paypalと自サイトの処理は<strong>同期型</strong>です。（ここがポイント！）なので、PDTによってコールバックされる情報を元にバックエンドと統合を行うことが可能になります。このフローを図で表すとこんな感じになります。</p>

<p>
<img alt="PDTの仕組み" src="http://blog.katsuma.tv/images/07060701.gif"  />
</p>

<p>ところが、実はPDTではバックエンドと統合を行うには不完全となります。・・・と、いうのも、あくまでコールバックされるタイミングは、決済終了後の自サイトに戻る瞬間。なので、もし決済が終了しても、自サイトに戻る前にブラウザを閉じられてしまうと、コールバックされずにバックエンドのDB処理が完結できず、<strong>ユーザは決済を終了したのにDB上では未決済</strong>、という状況になってしまいます。また、払戻し、支払い取り消しなど<strong>必ずしも全取引の通知を受け取るとは限らない</strong>のも、PDTの特徴なのです。</p>

<p>では、どうすればいいのでしょうか？？・・・と、いうことで、このPDTの欠点を補うために、Paypalはもう１つのコールバック方法としてIPNという方法を持っています。</p>


<h3>IPN</h3>

<p>IPNは、PDTと（ほぼ）同じデータがPaypalから自サイトにPOSTされますが、そのタイミングは支払いが終了したとき、また支払い状態が「Pending」の場合において決済されたとき、失敗したとき、拒否されたときにも別の通知を受け取ることになります。つまり、コールバックされるタイミングはWebのフローとは<strong>非同期</strong>に行われます。（これがPDTと違う大きなポイント！）これを図にするとこんな感じ。PDTとは独立してWebフローとは非同期に自サイトへPOSTされてきます。</p>

<p>
<img alt="IPN" src="http://blog.katsuma.tv/images/07060802.gif" width="330" height="240" />
</p>

<p>まとめると、PDTとIPNはこんな感じでバックエンドとの統合ができます。</p>

<p>
<ul>
<li>PDTはWebフローと同期してコールバックされる</li>
<li>なので、「決済は完了しました！」な画面を出力するのはPDTのコールバック時に表示</li>
<li>PDTでは決済が完了しても、その後にブラウザが閉じられる可能性がある</li>
<li>そのためにDBなどバックエンドと統合する際は、IPNでPaypalからコールされた際に、その情報を元にしてDBの処理を行う</li>
</ul>
</p>

<p>全部を強引にまとめるとこんな感じ。</p>

<p><img alt="PDT, IPN" src="http://blog.katsuma.tv/images/07060803.gif" width="360" height="240" />
</p>


<p>また、これらの情報は「<a href="https://www.paypalobjects.com/WEBSCR-460-20070530-1/ja_JP/JP/pdf/PP_OrderManagement_IntegrationGuide.pdf">注文管理インテグレーションガイド（PDF）</a>」がよくまとまっているので、併せて読まれるといいと思います。</p>

<p>さて、今回はPDT、IPNの紹介をしましたので、次のエントリーでは実際にPDTとIPNのコードを書き、その注意点について述べてみようと思います。</p>
