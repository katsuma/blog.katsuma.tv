---
title: Hive QL(HQL)でORDER BYするときの注意点
date: 2009/10/14 23:57:37
tags: hadoop
published: true

---

<p>HiveでのSQLことHQLの小ネタ。HQLでは基本的にSQLはほぼ完璧に利用できますが、たまにハマりポイントもあります。その１つが並び替えのORDER BY。</p>

<h3>ORDER BYとSORT BY</h3>
<p>HQLの文法的にORDER BYは有効ですが、実際は並び替えは行われません。（無視されているような感じ）Hiveでは代わりに<strong>「SORT BY [column]」</strong>を利用することになります。</p>

<p>ただし、ここでも罠があって、SORT BYは結果がreducerの数に依存します。(各reducerがsort処理をしたものがマージされるものになるので、全体としてはおかしな結果を得ることになります) 通常、reducerは複数走っているはずなので、結局SORT BYを利用してもORDER BYと同等の結果を得ることができません。</p>

<p>では、どうするか？と言うと明示的にreducerの数を1に指定してからSORT BYを実行すればOKです。</p>

<p><pre>
set mapred.reduce.tasks=1;
SELECT key, value FROM table_name SORT BY key;
</pre></p>

<p>また、Hiveシェルを使わない場合は1ライナーで。</p>

<p><pre>
hive -e 'set mapred.reduce.tasks=1;SELECT key, value FROM table_name SORT BY key;'
</pre></p>

<h3>HQL最適化</h3>
<p>ただ、これだとreducerの数がボトルネックになって、SORT BYと条件文などが組合わさると途端に処理が遅くなることがあります。</p>

<p>なので、このような条件文付きSORT BYを実行するときは、</p>

<p><ol>
<li>複数のreducerが条件文つきHQLでデータを整形し、中間テーブルAを作成</li>
<li>1つのreducerが、中間テーブルAを対象にSORT BYし、条件文は付けない</li>
</ol></p>

<p>な、方針でHQLを分割して実行すると、高速に動作できるかと思います。</p>

<p>ちなみに、このテーブルを分ける（カラムを厳選した中間テーブルを作成する）のはHQLの最適化でかなり有効で、SORT BY以外でもかなり有効なケースが多くあります。このあたりの最適化の話は、また別途まとめたいと思います。</p>


