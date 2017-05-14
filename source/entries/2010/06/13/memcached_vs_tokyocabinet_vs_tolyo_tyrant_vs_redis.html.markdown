---
title: memcached vs TokyoCabinet vs TokyoTyrant vs Redis
date: 2010/06/13 02:39:01
tags: kvs
published: true

---

<p>NoSQLの話題が周りで盛り上がっているので、有名どころのライブラリのset/getのベンチマークを取ってみることにしました。対象はmemcached, TokyoCabinet, TokyoTyrant, Redisの４種類。gemで入れたruby用のバインディングを利用して1000件のデータをset, getしています。結果はこんなかんじ。</p>

<table>
<thead>
<th>&nbsp;</th>
<th>user</th>
<th>system</th>
<th>total</th>
<th>real</th>
</tr>
</thead>

<tbody>
<tr><td>memcached:set</td><td>0.120000</td><td>0.030000</td><td>0.150000</td><td>(  0.213069)</td></tr>
<tr><td>memcached:get</td><td>0.150000</td><td>0.030000</td><td>0.180000</td><td>(  0.238989)</td></tr>
<tr><td>TokyoCabinet:set</td><td>0.000000</td><td>0.000000</td><td>0.000000</td><td>(  0.002802)</td></tr>
<tr><td>TokyoCabinet:get</td><td>0.000000</td><td>0.000000</td><td>0.000000</td><td>(  0.001759)</td></tr>
<tr><td>TokyoTyrant:set</td><td>0.010000</td><td>0.000000</td><td>0.010000</td><td>(  0.005384)</td></tr>
<tr><td>TokyoTyrant:get</td><td>0.030000</td><td>0.000000</td><td>0.030000</td><td>(  0.038285)</td></tr>
<tr><td>Redis:set</td><td>0.040000</td><td>0.030000</td><td>0.070000</td><td>(  0.147060)</td></tr>
<tr><td>Redis:get</td><td>0.040000</td><td>0.020000</td><td>0.060000</td><td>(  0.151168)</td></tr>
</tbody>
</table>

<p>当然のごとくmemcachedが最速だろう。。。と思いきや、そうでもない結果に。むしろ一番遅い結果に。なんだこれーーーと思って調べ続けていたのですが、バインディングのgemのコードを追いかけるかぎり、どうもこれはmemcache-clientの実装が原因のよう。</p>

<p>これは、memcache-clientの実装はpure-rubyで実装されているのに対して、TokyoCabinet/TokyoTyrantのバインディングの実装はnativeコードで実装されてあるのが原因のようです。事実、TokyoTyrantはmemcacheプロトコルを実装しているので、memcache-clientを利用してTokyoTyrantにアクセスすると両者はこんな結果になりました。</p>

<table>
<thead>
<th>&nbsp;</th>
<th>user</th>
<th>system</th>
<th>total</th>
<th>real</th>
</thead>
<tbody>
<tr><td>memcache:set</td><td>0.120000</td><td>0.040000</td><td>0.160000</td><td>(  0.189803)</td></tr>
<tr><td>memcache:get</td><td>0.150000</td><td>0.030000</td><td>0.180000</td><td>(  0.240141)</td></tr>
<tr><td>TokyoTyrant:set</td><td>0.130000</td><td>0.030000</td><td>0.160000</td><td>(  0.238009)</td></tr>
<tr><td>TokyoTyrant:get</td><td>0.130000</td><td>0.020000</td><td>0.150000</td><td>(  0.271598)</td></tr>
</tbody></table>

<p>TokyoTyrantのアクセス速度は一気に遅くなりました。やっぱりRuby実装に引きづられているみたいですね。。</p>

<p>ちなみに、Redisもsetに限るとmemcacheプロトコルと同じプロトコルを利用できるので、そのベンチをとってみると</p>

<table>
<thead>
<th>&nbsp;</th>
<th>user</th>
<th>system</th>
<th>total</th>
<th>real</th>
</tr>
</thead>
<tbody>
<tr><td>Redis:set</td><td>0.040000</td><td>0.010000</td><td>0.050000</td><td>(  0.091300)</td></tr></tbody></table>

<p>と、なってmemcacheクライアントを利用したときのmemcached, TokyoTyrantと比較しても圧倒的に高速だということがわかりました（おもしろい！）</p>

<h3>まとめ</h3>
<ul>
<li>オンメモリだからmemcachedが高速、とは限らない</li>
<li>memcache-clientは遅いので注意</li>
<li>各ライブラリのオリジナルのバインディングを利用した場合、高速順に並び替えるとTokyoCabinet, TokyoTyrant, Redis, memcachedになる</li>
</ul>


<p>と、いうわけで、memcachedが高速なことを確認するためにベンチマーク取ってみたのですが、実装によってはまったく異なる結果になることが分かって、なかなかおもしろかったです。なお、今回利用したコードは<a href="http://gist.github.com/436046">gist</a>に掲載しています。</p>


