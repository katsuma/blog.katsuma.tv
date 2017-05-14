---
title: 日付ごとのアクセス数をカウントするSQL
date: 2009/03/01 01:22:56
tags: mysql
published: true

---

<p>CakePHPなんかでcreatedにdatetimeの日付フィールド入れたログ用テーブル作って、あとから日付ごとにカウントした結果を表示してExcelとかでグラフつくりたいとき、なんてケースはよくあるかと思いますが、毎回このSQL忘れて面倒なことを考えがちなのでメモっておきます。</p>

<p><pre>
SELECT date(created), count(*)  FROM access_logs group by date(created);
</pre></p>

<p>同一日かどうかの判定して、、とかつい無駄なことを連想しがち（な自分）。date関数でgroup byするのが一番楽ですよね。僕は<a href="http://dev.mysql.com/downloads/gui-tools/5.0.html">MySQL Query Browser</a>でこの結果をCSVで書き出してExcelにペースト＞グラフ作成とかよくやってます。</p>

<p>あと、グラフをFlashで自動生成なんかもできるんですけど、その話はまた別途したいと思います。</p>


