---
title: "「F-site Adobe Flash CS3 Professional ことはじめ」に参加してきました"
date: 2007/05/15
tags: actionscript
published: true

---

<p>
<a href="http://www.flickr.com/photos/katsuma/496356360/" title="Photo Sharing"><img src="http://farm1.static.flickr.com/199/496356360_fe7e37bec0_m.jpg" width="240" height="180" alt="F-site Seminar" /></a>
</p>

<p>F-site主催のセミナー「<a href="http://f-site.org/articles/2004/03/25003056.html">Adobe Flash CS3 Professional ことはじめ</a>」に参加してきました。Flashオンリーのセミナーに参加するのは初めてです。AS3はフリーでのコンパイラ環境は整っているのですが、それでもはやりGUI上で操作できるCS3環境は気になる存在。と、いうわけで以下、セミナー上でのメモです。</p>



<h3>「Adobe Flash CS3 Professional 概要」西村真里子さん(Adobe社) (30分) </h3>
<p>
<ul>
<li>CS3シリーズは今回、Adobe過去最多の同時発売</li>
<li>Master Collectionは全ソフト混みのパッケージ</li>
<li>Flashは上位シリーズ全てにバンドル</li>
</ul>
</p>
<p>
<a href="http://www.flickr.com/photos/katsuma/496356656/" title="Photo Sharing"><img src="http://farm1.static.flickr.com/208/496356656_7b8257f923_m.jpg" width="180" height="240" alt="Flash CS3 @  F-site Seimar" /></a>
</p>

<p>
<ul>
<li>FlashPlayerのインストール率は98%</li>
<li>FlashPlayer9のインストール率は2007年3月現在で81.8%</li>
<li>Flash CS3のコードネームはBLAZE</li>
</ul>
</p>

<p>
<ul>
<li>主な主機能として、Photoshop, Illustratorとの連携</li>
<li>PhotoshopはレイヤごとにFlashへのインポート時に調整可能（どういう意味だっけか。。）</li>
<li>Illustratorはレイヤごとにベクタ / ビットマップを選択してインポート</li>
<li>Illustratorの内部エンジン「Lucky Engine」を公開することで、Flashとの細かな連携を図った</li>
<li>アニメーションからActionScriptに書き出すことも可能に（後述するけど、この機能は使えない）</li>
</ul>
</p>

<p>
<a href="http://www.flickr.com/photos/katsuma/496388909/" title="Photo Sharing"><img src="http://farm1.static.flickr.com/192/496388909_5d25c1d06e_m.jpg" width="240" height="180" alt="Adobe Bridge @ F-site Seminar" /></a>
</p>

<p>
<ul>
<li>Adobe Bridgeはかなり便利そう</li>
<li>Adobe製品の（ほぼ）すべてのフォーマットのファイルをプレビュー可能に</li>
<li>今回からFLVファイルの再生が可能に</li>
</ul>
</p>

<ul>
<li>6/22に販売開始予定</li>
<li>Masters Collectionは7月末</li>
<li>動画編集系がやや遅れている模様</li>
</ul>
</p>



<h3>「とうとうAS3がやってきた」野中文雄さん (60分)</h3>
<p>
<ul>
<li>AS3は（正直）難しい</li>
<li>「浮き輪をつけて25m泳ぐ」のがAS1, AS2</li>
<li>「いきなりクロールで25m泳ぐ」のがAS3</li>
</ul>

<ul>
<li>"[Esc] f n" と打つことで（Escape, スペース, f, スペース, n）"function"と出力するショートカット</li>
<li>実は結構前のバージョンのFlashから実装されていたらしい</li>
<li>処理を加えるときは"function + addEventListener"で</li>
</ul>

<ul>
<li>今、本を執筆中</li>
<li>2章まで終了</li>
<li>でも、まだまだ1割くらい</li>
</ul>
</p>

<h3>「デザイナーからみるCS3の良し悪し」笠居トシヒロさん＆サブリンさん (60分)</h3>
<p>
<a href="http://www.flickr.com/photos/katsuma/496389259/" title="Photo Sharing"><img src="http://farm1.static.flickr.com/199/496389259_daed3e9166_m.jpg" width="240" height="180" alt="Flash CS3 @  F-site Seimar" /></a>
</p>

<p>

<ul>

<li>バケツツールの向きが変わった</li>
<li>「なんてったってPhotoshopが最強の地位をもってるからそれに合わせないと、とか？」</li>
<li>これは旧Adobe製品とUIを合わせたらしい</li>
<li>ツールバーが1列にできるようになってるけど、これも微妙かも？2列にできるから問題ないか。。</li>

</ul>

<ul>
<li>Illustratorとの連携はかなり強い</li>
<li>Flashでは扱えないような色数のグラデーションも、かなり忠実に再現</li>
<li>実際はFlashで扱える程度の色数のグラデーションの短形の重ね合わせに</li>
</ul>

<ul>
<li>アニメーションからAS3への書き出し機能は、かなり微妙</li>
<li>実際は大量のXMLでアニメーションを表現している</li>
<li>「...で、このXMLは何だよ？？」ってことに絶対なりそう</li>
<li>一昔前のMS-Wordが書き出すHTMLもヒドかった。あんな感覚</li>
</ul>

<ul>
<li>AS3になっても、FlashPlayerの描画エンジンは特に変わっていない</li>
<li>「画像の回転」とかは、あまり変化がないかも</li>
<li>フーリエ変換とか複雑な計算をすると、顕著に変化が現れるはず</li>
</ul>
</p>

<h3>簡単な感想</h3>
<p>思ったよりもデザイナ視点の話が多くて、AS3のゴリゴリした話を期待していた自分にとっては、やや消化不良は否めない内容でした。が、「Flash CS3がどんな製品なのか？」と、いうことについては、かなりその概観が分かったと思います。普段Flashは、備え付けのコンポーネントでほぼ事足りている人間なので、イラレとの連携がものすごく嬉しい、、わけではないのですが、それでも製品選択のいい指標になりそうです。また、Flash界でよく拝見する方を生で見れたのも良かった点です。特に野中さんのプレゼンは、たとえもその話し方も非情に理解しやすく、Flash以外の点でも参考になることが多かったです。</p>

<p>そんなわけで、またこんなイベント/セミナーがあれば、特にASに特化したようなものには、どんどん参加していきたいと思います。</p>
