---
title: iTunesの操作をラップするgem、itunes-clientをリリースしました
date: 2013/06/09 23:03:57
tags: ruby
published: true

---

### itunes-client って何？

- [rubygems.org](http://rubygems.org/gems/itunes-client)
- [katsuma/itunes-client](https://github.com/katsuma/itunes-client)

itunes-clientはローカルのiTunesの操作を簡単に扱う高レベルなAPIを提供するgemです。たとえばトラックの操作はこんな感じで行えます。

<script src="https://gist.github.com/katsuma/5743503.js"></script>


### 背景

似たようなことを実現するものとして、AppleEventをラップして高レベルのAPIを提供する[rb-appscript](https://rubygems.org/gems/rb-appscript)や、それを利用したiTunes専用のライブラリ[rb-itunes](https://github.com/jkap/rb-itunes) などがあります。ところが、[iTunes10.6からSandboxが加わることで、これ系のライブラリは全部動作しなくなりました](http://blog.katsuma.tv/2012/06/rb-appscript_not_work_on_itunes10_6_3.html)。

で、対応方法としてAppleScriptを介すことで回避はできるのですが、[taifu](https://github.com/katsuma/taifu)や[musical](https://github.com/katsuma/musical)を書き直してる中で、何度も同じようなコードを書き続けているので、分離して管理したほうが実装しやすいなと思い、今回分離してgem化することにしました。

### 現状

まだまだやりたいことは全然実装できてません。
Trackの`find`もAR的なAPIは実装していますが、<del>本来なら配列を返すべきものを1情報しか返していないし</del>(この後v0.0.2で実装しました)、情報の更新もまだできません。プレイリストは何も実装できていません。

とはいえ、AppleScriptを介す限りは、OSXやiTunesの仕様に沿って安定して稼働するものを提供できそうですし、時間さえかければAppleScript用のAPIは全部実装できそうです。

### というわけで
これを読んでる方の[pull-request](https://github.com/katsuma/itunes-client/pulls)待ってます！


