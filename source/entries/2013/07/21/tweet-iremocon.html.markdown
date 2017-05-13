---
title: tweetで家電を操作する
date: 2013/07/21
tags: ruby
published: true

---

- [SiriProxyのプラグインとしてSiriで家電を操作するSiriProxy-iRemocon](http://blog.katsuma.tv/2013/01/siriproxy-iremocon.html)

で、Siriの入力を赤外線に変換して家電を操作することを試みましたが、小ネタとしてTweetを入力にすることも試してみました。「エアコンをつけて」「エアコンを消して」のTweetで僕の部屋のエアコンを操作できます。

- [twitter-iremocon](https://github.com/katsuma/twitter-iremocon)

TwitterのStreamAPIってなんだかんだで実際に使ったことが無かったのでその使い方の勉強も兼ねて。

[TweetStream](https://github.com/tweetstream/tweetstream)はめちゃめちゃ便利ですが、[Ruby2.0でうまく動かないIssue](https://github.com/tweetstream/tweetstream/issues/117)に気づくまでかなり時間を無駄にしました。。

コードはめちゃめちゃシンプルに書いたので、現状は僕がFollowしている人が誰でもウチのエアコンを操作できちゃうんですけど、まー面白いからヨシとしてます。Timelineに出てきた文字列に「エアコン」でマッチさせて<a href="http://www.amazon.co.jp/gp/product/B0053BXBVG/ref=as_li_ss_tl?ie=UTF8&camp=247&creative=7399&creativeASIN=B0053BXBVG&linkCode=as2&tag=katsumatv-22">iRemocon</a><img src="http://ir-jp.amazon-adsystem.com/e/ir?t=katsumatv-22&l=as2&o=9&a=B0053BXBVG" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />の信号を出してるだけですね。

と、いうわけで家電操作系は一通り遊んだ感あるので、また[itunes-client](https://github.com/katsuma/itunes-client)関連の開発に戻りたいと思います。


