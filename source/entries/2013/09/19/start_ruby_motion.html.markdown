---
title: RubyMotionはじめました
date: 2013/09/19 01:08:18
tags: ruby
published: true

---

身の回りのiTunes関連で書きたいコードは[taifu](https://github.com/katsuma/taifu), [musical](https://github.com/katsuma/musical), [itunes-client](https://github.com/katsuma/itunes-client)あたりが落ち着いて一段落しました。
そろそろここらでiOSアプリを書けるようになりたいなぁ、でもObjective-Cをゼロから学ぶのもなかなか時間かかりそうだなぁ、、ともやもやしていたところ巷で噂の[RubyMotion](http://www.rubymotion.com/)の存在を思い出したので、週末軽く手を出してみました。

RubyMotionについて細かな説明は省きますが、要するにRubyでネイティブのiOSアプリを作れるコンパイラ、テストスイートなどのツール群です。
Xcodeを（インストールはされていないとダメですが）起動しなくても、ターミナル＋好きなエディタでサクサクとTDDでiOSアプリを書けるのが非常に良さそうです。ひとまずこの記事がいい感じにまとまってて良さそうです。

- [MacRubyがiOSに来た！RubyでiOSのネイティブアプリ開発ができる「RubyMotion」登場](http://el.jibun.atmarkit.co.jp/rails/2012/05/macrubyiosrubym-7bc3.html)

### 最初の一歩
ひとまず僕はこんな環境で始めてみました。

- エディタ：Emacs24 + [motion-mode](https://github.com/ainame/motion-mode)
- APIリファレンス：[Dash](http://kapeli.com/dash)

motion-modeはさくっとDash連携ができて、「このAPIどういう意味なんだ。。」とか疑問に思ってもすぐ調べられるのがとてもいいですね。補完は「ものすごく賢い！」とまでは正直思わなかったのですが、まぁまぁいいかな、な感じ。ここはさすがにXcodeの方が賢そうではあります。

### チュートリアル
一番驚いたのは日本語情報が結構多いこと。
とくに[RubyMotion.jp](http://rubymotion.jp/)は、とんでもないほどの量の翻訳ドキュメントが揃っています。チュートリアルも文句ないレベルで翻訳されているので、ひとまずこれをなぞれば良さそう。僕もUITabBarController付けただけのありがちなサンプルアプリを作ってムフムフしていました。XcodeのDeveloperPreview版を利用したら、ちゃんとiOS7用でビルドできましたよ。

- [RubyMotion Tutorial](http://tutorial.rubymotion.jp/)


### テスト
RubyMotionに興味をもったきっかけの１つがRSpecぽい形でテストが書けること。マジで？？と最初はびっくりしたけど、確かにこんな感じで書けた。
これは、タップして状態が変わってるかどうかのテスト。

<pre>
describe "button controller" do
  tests ButtonController

  it "changes instance variable when button is tapped" do
    tap 'Test me!'
    controller.instance_variable_get("@was_tapped").should == true
  end
end
</pre>

よく見たらRSpecぽいけど、実はちょっと違う。

というのも中身は[Bacon](https://github.com/chneukirchen/bacon)というミニマムRSpecクローンをforkしてObjective-C用に拡張してできた[MacBacon](https://github.com/alloy/MacBacon)というものが利用されています。
ミニマムなクローンなので、当然のごとく本家RSpecには無いものも多くあって、subjectもletもcontextすら無い、、とRSpecに普段慣れている人にとってはむずむずしそうな内容。まぁテストをRubyで書けるだけでもかなりいいのですが。

ひとまずcontextはdescribeにalias張るだけで簡単にできるので、MacBaconにcontextを利用できるようにするPull Requestを送ってみたところ、早速取り込んでもらえました。

- [Add `context` method as alias of `describe`](https://github.com/alloy/MacBacon/pull/2)

ただ、この変更がRubyMotion本家にどうやって反映されるのかは正直よくわかっていないので、もうちょっと掘りたいところ。MacBaconはまだまだ手が出せそうな雰囲気があるので、ここはいろいろ貢献していきたいと思っています。

### まとめ
ひとまず身近な開発環境でiOSアプリを作ることができるようになりました。

iOSのAPIは正直まだまだ全く理解できていないので、作りたいものを作れるレベルには全く達していないのですが、少しづつ手を動かして学びながら怪しいアプリを作っていこうと思います。


