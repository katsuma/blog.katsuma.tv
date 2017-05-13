---
title: iTunes10.6.3からrb-appscriptが利用できない
date: 2012/06/20
tags: ruby
published: true

---

<p>最近更新されたiTunes10.6.3からMountain Lion対応としてsandboxのコードが入っている様子。結果、なんとなく動いていたrb-appscriptを利用してrubyからiTunesを動かすことができなくなっています。（参考：<a href="http://stackoverflow.com/questions/11089123/itunes-10-6-3-changes-applescript-interface">iTunes 10.6.3 changes AppleScript interface?</a>）</p>

<p>結果、<a href="https://github.com/katsuma/musical">musical</a>も<a href="https://gist.github.com/1515069">taifu</a>も動かなくなってすごい不便。。。そもそもrb-appscriptはもう<a href="http://appscript.sourceforge.net/status.html">開発を停止した</a>ようだし、似たことをやるなら素のAppleScriptを書くか、Objective-Cで書きなおすかをしないとダメっぽいです。うーむ、残念。。というかなんとかせねば。</p>


