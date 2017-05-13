---
title: LeapMotionとRubyでiTunesを制御できるLeapTunesを作りました
date: 2013/08/12
tags: ruby
published: true

---

[@k_katsumi](https://twitter.com/k_katsumi)経由で話題のLeap Motionを購入したので、ひとまずiTunesを操作できるものをRubyで作ってみました。

- [https://github.com/katsuma/leap_tunes](https://github.com/katsuma/leap_tunes)

デモムービーはこんなかんじです。

<iframe width="560" height="315" src="//www.youtube.com/embed/Ktx_m4iwg38" frameborder="0" allowfullscreen></iframe>

- 5本指を差し出すことでトラックの再生/一時停止
- 2本指を差し出すことで次のトラックを再生

が可能です。

## WebSocket API
Leap MotionのSDKを利用することで、指の動きの情報をAPI経由で取得できる。。はずなのですが、いくらやっても情報が取得できませんでした。おそらく設定を何かミスってるのでしょうが。。たとえばこれらのgemが動作しませんでした。

- [https://github.com/glejeune/ruby-leap-motion](https://github.com/glejeune/ruby-leap-motion)
- [https://github.com/tenderlove/leap_motion](https://github.com/tenderlove/leap_motion)

この問題はひとまず置いておくことにして、方針を変えてWebSocet APIで取ることにします。今回はこのgemを利用しました。

- [https://github.com/glejeune/ruby-leap-motion-ws](https://github.com/glejeune/ruby-leap-motion-ws)

ネタバレすると、LeapTunesの元ネタも上記gemの中のサンプルを元にして再実装したものです。

以下、実装するにあたって気づいた点です。

## 自然な動作
Leap Motionは非常におもしろいガジェットなのですが、やはりデスクからある程度の高さで円をかいたりジェスチャを行うのは若干無理があります。
（単純なマウスの代用には絶対できない）

なので、キーボードの入力を自然に補助できるような形を考えると、実は

- 指をN本差し出す
- 片手/両手で差し出す

くらいが自然なんじゃないのかなぁと思いました。

あとは「手をひねる」くらいはアリな気はしますが、スワイプは普段使いにはちょっとしんどそうな印象です。

## ジェスチャのキャンセル
APIは常時

- 指の数
- 手の数

が送信されるので、これらがゼロになったとき（= Leap Motionのセンサから何も検知されなくなったとき）にいろいろ状態をリセットするような処理を入れるのは定石になりそうですね。

言われたら当然だろうという感じですが、最初このリセット方法が思いつかずに、無限に再生と一時停止を繰り返し続けるループにはまってました。。

## CPU使用率
僕が普段使ってるiMacは24-inch Mid 2007のめちゃめちゃ古いものなのですが、WebSocketでデータを受信しつづけてるときはさすがにCPU使用率は結構上がります。

普段の操作もデータの受信にも支障は特にありませんが、それでもleapd（というデーモン）が常時50%くらい奪ってる感じなので、やはり「軽くはない」くらいの印象はあります。

## まとめ
まだまだ手探り感強いLeap Motionですが、超シンプルなジェスチャでiTunesの操作を行えるものを作ってみました。
引き続き可能性を探っていこうと思います。



