---
title: meeting24.tvをリリースしました
date: 2008/11/14
tags: diary
published: true

---

<p><a href="http://meeting24.tv/" title="meeting24.tv by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3135/3028970312_91d73bd73f_o.png" width="117" height="38" alt="meeting24.tv" /></a></p>

<p>「<a href="http://blog.katsuma.tv/2008/11/samurai7_by_ug_live.html">サムライ7の配信</a>」の次は僕が担当していたプロジェクトについて。超簡単にWeb会議ができるソリューション「<a href="http://meeting24.tv/">meeting24.tv</a>」をリリースしました。</p>

<p><ul>
<li><a href="http://meeting24.tv/">meeting24.tv</a></li>
</ul></p>

<p>会議を開きたい人は</p>

<p><ul>
<li>ログイン</li>
<li>会議名入力</li>
</ul></p>

<p>だけで完了です。ちょー簡単。</p>

<p>これで会議用URLが発行されるので、あとはこのURLをメールやIMで参加者に共有すればOKです。参加者はログインが必要ないので、URLをクリックすれば作成した会議室に入ることができます。

無料版では6人まで同時に会議ができます。また、有料アカウントを購入いただくと、人数制限が24人までになったり、パッケージを自社内でホスティングすることも可能です。</p>

<h3>技術的な話</h3>
<p>今回はサーバ周りとJavaScriptを僕が、クライアントのFlashを<a href="http://twitter.com/ishida">ishida</a>が実装しています。クライアント側はかなり工夫がされてあって、</p>
<p><ul>
<li>複数のカメラデバイスから「それっぽいもの」を自動検出（キャリブレーション）</li>
<li>何人参加しても通信料を一定値以下に抑えるためにフレームレートの動的な変更</li>
<li>話者を優先的にフレームレートを上げる</li>
<li>ハウリング抑制</li>
<li>「使い方に困ってそう」と判定したらチュートリアルを自動起動</li>
</ul></p>

<p>などなど、細かなネタが盛りだくさんです。</p>

<p>サーバサイドはLAMP, memcachedとCakePHPで構成して、gettextを使って国際化対応もしています。ブラウザの言語設定を切り替えると勝手に英語/日本語が切り替わるのが特徴的です。</p>

<p>最近は社内のミーティングや他社さんとのミーティングもこれ使ってやってますけど、自分たちで作っておきながらも普通に便利です。移動コスト・ゼロでサクっとはじめられるのはかなりいい感じです。ご興味ある方はぜひお試しください。ちなみに以前お伝えした<a href="http://live.utagoe.com/">Utagoe Live100</a>のID空間と統一していますので、そちらのアカウントをお持ちの方はそちらのIDでもログイン可能です。</p>


