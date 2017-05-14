---
title: MT5でmarkdownで記事を書いたときにおけるRSS, Atomの対応
date: 2013/03/04 22:38:11
tags: ''
published: true

---

<ul>
<li><a href="http://blog.katsuma.tv/2012/11/mt3.3_to_mt5.2.html">MT3.3からMT5.2にアップデートしました</a></li>
</ul>

でMTのバージョンを上げてから、記事を書くときはmarkdownで書くようにしていたのですが、それ以降RSSとAtomでmarkdownのまま配信されていました。
うすうすこの現象に気づいていたのですが、対応方法がわかったのでメモ。

RSS, Atomのテンプレートをそれぞれ次のように変更します。

<pre>
- <description><$MTEntryBody encode_xml="1" convert_breaks="0"$></description>
+ <description><$MTEntryBody encode_xml="1" convert_breaks="1"$></description>
</pre>

<pre>
- <$MTEntryBody encode_xml="1" convert_breaks="0"$>
- <$MTEntryMore encode_xml="1" convert_breaks="0"$>
+ <$MTEntryBody encode_xml="1" convert_breaks="1"$>
+ <$MTEntryMore encode_xml="1" convert_breaks="1"$>
</pre>

convert_breaksは改行表示だけっぽい名前をしながら、実際はHTMLのrenderの制御をしているようですね。


