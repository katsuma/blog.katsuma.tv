---
title: TravisCIの結果を光で通知するtravis-blink1を作りました
date: 2014/09/03
tags: ruby
published: true

---

- [travis-blink1](https://github.com/katsuma/travis-blink1)

## これは何？
[blink(1)](http://blink1.thingm.com/)という、USB接続で発光するガジェットを[hmsk](https://twitter.com/hmsk)さんからいただいたので、遊びでつくってみたgemです。

指定したgithubのプロジェクトについて、TravisCIの結果を発光して通知してくれるものです。CIが実行中のときは黄色で点滅、テストに失敗したときは赤色で点滅、テストが通ったときは緑で発光します。
動作の様子はこんなかんじ。

### テスト失敗時
<iframe width="420" height="315" src="//www.youtube.com/embed/Uyt9pJ9-Th4" frameborder="0" allowfullscreen></iframe>

### テスト成功時
<iframe width="420" height="315" src="//www.youtube.com/embed/_XqXydvLw9w" frameborder="0" allowfullscreen></iframe>



blink(1)がおもしろいのは、プログラマブルに発光できること。色や点滅時間など、ことこまかく調整できるので、任意のイベントの通知として発光させることが可能になります。

いろんな言語からblink(1)のAPIを叩くクライアントがあるのですが、rubyだと[rb-blink1](https://github.com/ngs/rb-blink1)がひとまずよさそう。travis-blink1でも内部で利用しています。

とりあえずチカチカさせるには、これだけでOK。

<pre>require 'blink1'

Blink1.open do |blink1|
  blink1.blink(255, 255, 0, 5)
end
</pre>

## 使い方

お約束の

<pre>gem install travis-blink1
</pre>

でインストール後、手元のディレクトリがプロジェクトをforkした場所でgit remoteの設定がされている場合は

<pre>travis-blink1
</pre>


だけ実行すれば、git remoteの結果から、TravisCIの状態を監視。
また、任意のディレクトリから実行するときは

<pre>travis-blink1 katsuma/itunes-client
</pre>

なんかのように「ユーザ名/プロジェクト名」を指定すればOKです。

## 雑感

blink(1)は、できることがシンプルなので、すぐに試せるのはいいですね。いっぱい天井からぶら下げるなどして、[hue](http://www2.meethue.com/ja-JP)みたいに照明代わりにしみても楽しそうです。


