---
title: del.icio.usのh-index値を出力
date: 2007/07/21
tags: javascript
published: true

---

<p>懲りずに<a href="http://lab.katsuma.tv/del.icio.us_report/">del.icio.us Report</a>の改良しています。今回の機能追加は次の２つです。</p>

<h3>IE, OperaなどFirefox2以外に対応</h3>
<p>Thread.sleepまがいのことをするためにyield使ってましたが、Firefox2しか対応していなかったので、PeriodicalExecuter使うことで他のブラウザにも対応しました。手元の環境だとIE6, Opera9で動作しています。と同時にますます汚いコードになった。。。JSONP使ったときに名前空間を綺麗に処理できないなー。グローバル領域を汚しまくりの突貫コード。</p>

<h3>h-index値に対応</h3>
<p><a href="http://b.hatena.ne.jp/t/h-index">はてブで最近h-index値が注目されている</a>ようなので、del.icio.usにも対応してみました。作るの簡単なので。</p>


<p>でも簡単な割にはなかなか面白い指標で、これかなり有用な値だと思います。（はてブのユーザを考えると）SBM毎にユーザ層にかなり偏りがある、という欠点もあるものの、コンテンツ内容を重視＋他ユーザへの貢献度を考えるとページランクよりも意味深いかもしれません。</p>

<p>ただ、h-index値が今後注目されていくとすると、悪徳SEOのようにブックマークスパムがますます増えるのも容易に想像できますし、上手い補正方法を考える必要があるかもしれませんね。</p>

<h3>とは言えはてなダイアリー未対応</h3>
<p>最近気づいたんですけども、「site:」検索でYahooはディレクトリを含むURLは対応してないんですね。。orz Googleはディレクトリ含んでてもOKなので、「site:d.hatena.ne.jp/xxxx」なクエリでもOKなんですけどYahooはダメみたい。むーー。なので、今のところはドメイン持ってるユーザの方か、サブドメインが与えられるBlogサービス（昔のamebloとか。今もサブドメイン与えられるのかな？）とかのみの対応なんですね。URL抽出は結構大きい問題です。。</p>


<p>と、いうわけでいろいろ難もありますが、もしよければヒマなときに是非試していただければと思います。→ <a href="http://lab.katsuma.tv/del.icio.us_report/">del.icio.us Report</a></p>
