---
title: Rubyでブックマークカウンタの修正スクリプト書きました
date: 2008/12/11 01:29:00
tags: ruby
published: true

---

<p>(追記 : 2009/02/12) ソースは<a href="http://github.com/katsuma/mt-delicious-bookmark-counter/tree/master">githubでホスティング</a>することにしました。<p>

<p>ここ最近、このBlogで使ってる<a href="http://www.h-fj.com/blog/archives/2007/01/02-101021.php">ソーシャルブックマークカウンタ</a>で、deliciousの数がぜんぜん動いていませんでした。どうもドメイン変わった時期の前後あたりから、APIでかえってくるJSONのパースにコケているようで、Perlのモジュールの手を出す方法がさっぱり分からなかったので途方に暮れてました。で、暮れてばっかりだとアレなのでRubyの勉強がてら修正スクリプト書いてみました。超素人コードですけど。</p>

<p><ul><li><a href="http://blog.katsuma.tv/data/delicious_counter.tar.gz">delicious_counter.tar.gz</a></li></ul></p>

<p>仕掛けは単純で、プラグインをインストールするとmt_bookmark_countってテーブルができるので、そこのbookmark_count_delicous_counter, bookmark_count_total_counterをがしがしupdateさせてるだけです。deliciousのAPIへはまとめて15個URLづつリクエスト投げてます。13, 32行目あたりのDB情報、URL情報を適当に直したら動くんじゃないかな、と思います。
</p>

<p>ただ、このBlogのMTもバージョンは超古くて3.3とかだし最近のMTのバージョンでこのプラグインが動くかどうかも定かではないです。。あくまでオレオレパッチ。もしご利用されたい方がいらしたら使ってみてください。要MySQL/Rubyですが、次のサイトに従ってインストールすると楽にできました。</p>

<ul><li><a href="http://bluestick.jp/tech/index.php/archives/61">MySQL/Rubyをさくらインターネット共有サーバにインストールするには</a></li></ul>

<p>動かし方は上のリンクの圧縮ファイルを解凍し、ruby delicious.rb で動くと思います。あとはサイトを丸ごと再構築すればdeliciousのカウンタも反映されるはずです。</p>

<p>まともにRubyでコード書いたの初めてだったですけど、個人的にはPerlよりも書きやすかったかも。割とさくさく書けて楽しかったです。さらっとツール書くのは便利ですね。</p>

<p>
<iframe src="//rcm-jp.amazon.co.jp/e/cm?t=katsumatv-22&o=9&p=8&l=as1&asins=4873113679&md=1X69VDGQCMF7Z30FM082&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" width="120" height="240" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</p>
