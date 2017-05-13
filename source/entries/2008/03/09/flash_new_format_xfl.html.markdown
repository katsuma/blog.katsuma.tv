---
title: Flashの新フォーマット「XFL」に注目
date: 2008/03/09
tags: actionscript
published: true

---

<p>ActionScript界の神である<a href="http://www.moock.org/blog/">Colin Moock</a>さんのBlogからの情報。</p>
<p>Flashの次のバージョンCS4で、今までのフォーマットの「.FLA」とは別に「XFL」なるフォーマットが用意されるようです。(via <a href="http://www.moock.org/blog/archives/000269.html">XFL: Flash's New Source Format</a> / <a href="http://www.moock.org/blog/">moockblog</a>) これ、今まで謎フォーマットであったFLAに変わる、<strong>完全オープンな仕様</strong>のSWF生成フォーマットのようで、なかなか気になる感じだったので以下ざっくりまとめ。(一部意訳)</p>

<p><ul>
<li>CS4ではXFLフォーマットでexport, importできる</li>
<li>XFLは基本的にzipフォーマットで素材(ASのコードや画像？)をアーカイブさせたもの</li>
<li>アーカイブの中のファイルやフォルダ構造は一緒に梱包したXMLで記述</li>
<li>このXMLの構造については詳細は今のところ未定。でもadobeとしては公開する予定</li>
<li>PhotoshopでXFLの中の画像を直接編集したり、プレゼンテーションのドキュメントのテキストを抽出したり、なんかが自由にできるよ！</li>
<li>XFLは最終的にはSWFを書き出すためにはCS4で読み込まなきゃいけない。XFLからswfのコンパイラの橋渡しはJSFLスクリプトで簡単にできるようになる予定</li>
<li>XFLから直接SWFを書き出すコマンドツールをadobeが出してくれたら、開発者はオレオレFlash CS4のようなオーサリングツールを作ることもできる！</li>
</ul></p>

<p>というわけで、<a href="http://opensource.adobe.com/">オープンソース化された製品専用のサイト</a>も立ち上げて、オープン化がどんどん進んでるadobeですが、XFLについてもこの流れの一環なんでしょうかね。最後の下りでColin Moockさんも言ってますが、XFL2SWFがadobeから提供されるかどうかがポイントになりそうです。これ提供されたらAIR開発者はヨダレものなんだろうなぁ。あと、XFLについては、アニメーション作成のタイムライン派のユーザもなんとかできるものになるのかも気になるところ。このあたり含めてCS4についてはウォッチしていきたいと思います。</p>


