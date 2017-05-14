---
title: 各エントリーにソーシャルブックマーク数を表示
date: 2007/07/09 00:00:57
tags: web20
published: true

---

<p>エントリーごとのソーシャルブックマーク数の表示は、はてなブックマークだけまともに動いていて、delicio.us、Livedoor Clipについては、エントリー追加のリンクだけの表示になっていたのですが、このたび全ブックマーク数の表示を行うように改良しました。</p>

<p>利用したプラグインは<a href="http://www.h-fj.com/blog/archives/2007/01/02-101021.php">「はてなブックマーク／del.icio.us／Livedoor clipの被ブックマーク数を表示するプラグイン（Movable Type 3.3用」</a>です。</p>

<p>利用したタグはこちら。</p>

<p>
<ul>
<li>&lt;$MTEntryHatenaBookmarkCount$&gt;　エントリーに対するはてなブックマーク数</li>
<li>&lt;$MTEntryDeliciousBookmarkCount$&gt;　エントリーに対するdel.icio.usブックマーク数</li>
<li>&lt;$MTEntryLivedoorBookmarkCount$&gt;　エントリーに対するLivedoorClipブックマーク数</li>
<li>&lt;$MTEntryHatenaBookmarkInfoLink$&gt;　エントリーに対するはてなブックマークページへのリンクURL</li>
<li>&lt;$MTEntryHatenaBookmarkLink$&gt;　エントリーに対するはてなブックマーク追加へのリンクURL</li>
<li>&lt;$MTEntryDeliciousBookmarkInfoLink$&gt;　エントリーに対するdel.icio.usブックマークページへのリンクURL</li>
<li>&lt;$MTEntryDeliciousBookmarkLink$&gt;　エントリーに対するdel.icio.usブックマーク追加へのリンクURL</li>
<li>&lt;$MTEntryLivedoorBookmarkInfoLink$&gt;　エントリーに対するLivedoorClipブックマークページへのリンクURL</li>
<li>&lt;$MTEntryLivedoorBookmarkLink$&gt;　エントリーに対するLivedoorClipブックマーク追加へのリンクURL</li>
<li>&lt;$MTBlogHatenaBookmarkCount$&gt;　Blog全体に対するはてなブックマーク数</li>
<li>&lt;$MTBlogDeliciousBookmarkCount$&gt;　Blog全体に対するdel.icio.usブックマーク数</li>
<li>&lt;$MTBlogLivedoorBookmarkCount$&gt;　Blog全体に対するLivedoorClipブックマーク数</li>
</ul>
</p>

<p>今のところ静的に取得するもののみ試してます。これだと定期的に再構築してやんないと被ブックマーク数は更新されないのですが、動的に取得する方法も用意されているようで。と、いうかリアルタイムに再構築することができるなんて、このプラグインで初めて知りました。いやーこれは素晴らしい。。。いろいろ勉強ネタが転がってます、ほんと。</p>
