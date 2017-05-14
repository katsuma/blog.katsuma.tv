---
title: zshのプロンプトを見やすい配色にする
date: 2007/09/21 16:45:14
tags: develop
published: true

---

<p>最近、開発環境をcoLinux+Fedora7+zshな感じに移しました。経緯は<a href="http://www.amazon.co.jp/gp/product/477413192X?ie=UTF8&tag=katsumatv-22&linkCode=as2&camp=247&creative=1211&creativeASIN=477413192X">WEB+DB PRESS Vol.40</a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&l=as2&o=9&a=477413192X" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />の「Linux定番開発環境」のコーナーではてなの伊藤直也さんが紹介していたことから。特にzshは前から気になっていたのでこのタイミングで導入をば。</p>

<p>感想としては<strong>「これは慣れたらそうとう便利そう！」</strong></p>

<p>かゆいところに手が届くという話は聞いていましたが、</p>
<ul>
<li>「ディレクトリ名の入力だけでcdできる」（プログラマブルな補完機能）</li>
<li>「ディレクトリスタックを保存」</li>
<li>「コマンドのスペルチェック」</li>
</ul>
<p>なんかはかなりイィ感じ。これはもっともっと使いこなしたいと思います。</p>

<p>で、唯一「うーん」と思ったのがプロンプトの表示項目+配色について。なんかあまりにも味気ない感じです。。プロンプトに改行も入っていないし、見づらい感じにあるなすし。</p>

<p><img alt="zsh" src="http://blog.katsuma.tv/images/070922_01-thumb.gif" width="430" height="20" /></p>

<p>と、いうわけで伊藤直也さんの<a href="http://bloghackers.net/~naoya/webdb40/files/dot.zshrc">公開されている.zshrc</a>にそれっぽい配色を加えたものを作ってみました。（作ってみました、というほどでも無いですが。。）</p>

<p>上記ファイルの先頭の方に次の行を追加。</p>

<p>
<pre>
local GREEN=$'%{\e[1;32m%}'
local YELLOW=$'%{\e[1;33m%}'
local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
PROMPT=$'\n'$GREEN'${USER}@${HOSTNAME} '$YELLOW'%~ '$'\n'$DEFAULT'%(!.#.$) '
</pre>
</p>

<p>これでプロンプトが</p>

<p>
<img alt="zsh" src="http://blog.katsuma.tv/images/070922_02.gif" width="430" height="46" />
</p>

<p>と、なり（僕としては）プロンプトが見やすくなりました！万歳！</p>

<p>ちなみに、今回の改良について次の記事を参考にさせていただきました。色を変えてみたい方や、改行箇所などを調整されたい方はご参考ください。</p>

<p><ul>
<li><a href="http://www.machu.jp/b/zsh.html">zsh</a></li>
<li><a href="http://www.machu.jp/diary/20040329.html">まちゅダイアリー - zsh</a></li>
</ul></p>
