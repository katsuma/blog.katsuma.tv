---
title: RubyMotion2.11がリリースされてspecの中でcontextが利用できるようになりました
date: 2013/10/16 22:26:24
tags: ruby
published: true

---

相変わらずの週末RubyMotion野郎な日々です。

[前回](http://blog.katsuma.tv/2013/09/start_ruby_motion.html)の記事の中で[MacBacon](https://github.com/alloy/MacBacon)にPull Request送った話を書きましたが、本家の[RubyMotion](https://github.com/HipByte/RubyMotion)自体とは実装が分かれていることに気づいたので、改めてPull Requstを送ることにしました。（実質同じ内容）

- [Add `context` method as `describe` alias](https://github.com/HipByte/RubyMotion/pull/134)

実はこのPRなかなかマージされるどころか一切反応がないまま数週間放置されていました。つついていいのかどうなのか温度感もわからないままムーと唸っていたのですが、なんとなく唐突にtwitter経由で確認してもらうようにお願いしてみました。突然のPR確認依頼。

<blockquote class="twitter-tweet"><p>Hi <a href="https://twitter.com/RubyMotion">@RubyMotion</a> could you check my pull request? <a href="http://t.co/WNVGuA1q4z">http://t.co/WNVGuA1q4z</a></p>&mdash; ryo katsuma (@ryo_katsuma) <a href="https://twitter.com/ryo_katsuma/statuses/388300454892810240">October 10, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

さて、どうなるかな、、と思ってたら３分後mentionが。

<blockquote class="twitter-tweet"><p><a href="https://twitter.com/ryo_katsuma">@ryo_katsuma</a> Done &amp; merged! Thanks for your contribution!</p>&mdash; RubyMotion (@RubyMotion) <a href="https://twitter.com/RubyMotion/statuses/388301186811842560">October 10, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


まじでー！ってくらい速攻でマージされました。驚愕。。

RubyMotionのメンテナにCocoaPodsメンテナの<a href="https://github.com/alloy">Alloy</a>さんが<a href="http://blog.rubymotion.com/post/62652618638/eloy-duran-joins-the-rubymotion-team">Joinしてくれて</a>（前回のMacBaconのPRを見ていただけていた）理解が早かったのかな、、と思いつつ、なかなか動きがないPRは個別でtwitterなり何なりでつついてみるのはアリなようですね。うーむ。


<h3>2.11リリース</h3>

そうこうしていたら、RubyMotionの2.11が昨日リリースされました。リリースノート見ていたら、確かに僕のPRも入っていましたね！これでSpecの中でcontext使い放題です!!

<blockquote>
<pre>
= RubyMotion 2.11 =

  * Added the `rake clean:all' task which deletes all build object files
    (ex. those in ~/Library/RubyMotion/build). We recommend using that task
    before building an App Store submission.
  * Added support for Xcode asset catalogs. This can be used to manage all your
    image assets in a visual way, including your application's icons. You can
    create and edit a new catalog like so:
    $ mkdir resources/Images.xcassets && open -a Xcode resources/Image.xcassets
  * Fixed a long standing limitation in the compiler where overriding in Ruby
    an Objective-C method that accepts a C-level block was not possible.
  * Fixed a regression where `return' from a block would terminate the app.
  * Improve the build system to always copy embedded.mobileprovision. Thanks to
    Jan Brauer for the patch (pull request #121).
  * Fixed a bug where a boxed struct would incorrectly be interpreted as a
    object type, leading to the dispatcher not recognizing a signature.
  * Fixed a bug where compiled object files of a vendored project were not
    actually being cleaned when running `rake clean`.
  * Fixed a bug where defining a singleton method on an object inside a method
    with named parameters (Objective-C-style selector) would result in that
    method being defined in the runtime with a wrong selector.
  * Fixed a bug where Range objects created with non-literal begin/end points
    would never be released, and therefore leaking memory.
  <strong style="color: yellow">* Added `context` method as `describe` alias in spec.  Thanks to Ryo Katsuma
    for the patch (pull request #134).</strong>
  * Fixed a small internal memory leak in the dispatcher when sending the
    #method_missing message.
  * Fixed a bug in the compiler where providing nil as the value of a C-level
    block argument would not actually pass NULL but an empty Block structure
    instead. Thanks to Ruben Fonseca for the detective work.
  * [iOS] Fixed a bug where device log is wrong filtered with `rake device' 
    when performed day is 1-9.
  * [iOS] Added support to launch the app as 64-bit in simulator.
  * [iOS] Fixed where non-retina iPad simulator does not launch as default.
    Thanks to Fabio Kuhn for the patch (pull request #133).
  * [iOS] Fixed a regression where certain GameKit class properties could not
    be used (ex. GKMatchRequest#minPlayers).
  * [iOS] Fixed a link error where "ld: framework not found IOKit" is caused
    with iOS 7 SDK when it will run `rake device'.
  * [OSX] Fixed the wrong default settings of short cut key in menu. Thanks to
    Kazuhiro NISHIYAMA for the detective work.
</pre>
</blockquote>

変更はほんの数行だけど、自分のちょこっとした貢献で世の中のソフトウェアがちょこっと良くなるのは嬉しいですね。


