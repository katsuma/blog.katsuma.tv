---
title: rubygemからインストールできるtomdocは古い
date: 2013/06/16 00:09:30
tags: ruby
published: true

---

[itunes-client](https://github.com/katsuma/itunes-client)のドキュメントを勉強がてら[tomdoc](http://tomdoc.org/)のスタイルで書こうとしてたら、全く動かない。パースに失敗してる感じ。

<pre class="shell">
$ tomdoc lib/itunes/track.rb                                                                                                                         
--------------------------------------------------------------------------------
Itunes

coding: utf-8
</pre>

コメントが構文エラー起こしてるのかなぁ、、と思ってたら同僚の[中村氏](https://twitter.com/r7kamura)がさらっと気になる発言をしてた。

<blockquote class="twitter-tweet"><p>それは壊れてるからgithubの最新のを手元で入れて使ったほうがいい</p>&mdash; 中村氏 (@r7kamura) <a href="https://twitter.com/r7kamura/statuses/345907880928612352">June 15, 2013</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

まさか、、と思って[最新版](https://github.com/defunkt/tomdoc)をcloneしてそっちの実行ファイル経由で実行してみたら確かに通りました。

<pre class="shell">
$ git clone https://github.com/defunkt/tomdoc.git
$ cd itunes-client
$ ../tomdoc/bin/tomdoc lib/itunes/track.rb 

Itunes::Track.find_by(arg)

Public: Find some tracks by conditions.

Examples

  Track.find_by(name: 'Hello, Goodbye')
  # => #[&lt;Itunes::Track:0x007fd02213fc78 @album="1"&gt;, &lt;Itunes::Track:0x007fd02213fc79 @album="Anthology2"&gt;]

  Track.find_by(name: 'Hello, Goodbye', album: '1')
  # => #[&lt;Itunes::Track:0x007fd02213fc78 @album="1"&gt;]

Returns an array including found tracks.
--------------------------------------------------------------------------------
...
</pre>

なぜこの最新版がgem化されてないのかは謎ですが、tomdocの利用時には注意しておいたほうが良さそうです。


