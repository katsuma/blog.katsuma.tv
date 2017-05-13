---
title: del.icio.us Report(α版)を作ってみました (3)
date: 2007/07/09
tags: javascript
published: true

---

<p>またまた<a href="http://lab.katsuma.tv/del.icio.us_report/">del.icio.us Report</a>のつづきです。</p>

<p><a href="http://blog.katsuma.tv/2007/07/mt_plugin_sbm.html">各エントリーのブックマーク数を表示</a>してからReportとの結果を比較して、あまりに値が異なっていたので「えぇ？？」と思ってコードを見直してみると、致命的なバグあったのを発見。de.icio.usからのレスポンス処理がヒドい箇所がありました。なんと<strong>レスポンスの配列を先頭要素しか処理してませんでした</strong>。いやーほんとひどい。。。</p>

<p>と、いうわけでこれで以前よりもリアルな値が出ていると思います。ぜひ改めて一度利用していただければと思います。残りの課題として、今どのあたりまで処理が進んでいるのかをもう少し分かりやすくしたいです。非同期にJSONPを実行しまくってるので、その状態取得を行うのがポイントですね。あと、サイト内URLの取得をもう少し正確にしたいですねぇ。。ここで全てがかかってくるわけですし。</p>

<p><strong>2007.07.09 追記</strong><br />
進捗度をグラフで表示しました。悩んだ割りには、「Callback数/POST数」の単純なロジックで実現できました。</p>

<p><a href="http://lab.katsuma.tv/del.icio.us_report/">del.icio.us Report</a></p>
