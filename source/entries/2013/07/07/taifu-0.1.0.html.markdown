---
title: taifu-0.1.0をリリースしました
date: 2013/07/07 00:52:25
tags: ruby
published: true

---

地道に少しづつ改良し続けてる[itunes-client](https://github.com/katsuma/itunes-client)ですが、一通り使いたいAPIが整ってきました。

そこで[taifu](https://github.com/katsuma/taifu)のバックエンドを、生のAppleScriptベースのコードからitunes-clientを利用したものに書き換えました。

- [Use itunes-client gem](https://github.com/katsuma/taifu/pull/3)
- [taifu-0.1.0](http://rubygems.org/gems/taifu/versions/0.1.0)

自分で書いておきながら、動作確認できてるgemに処理を任せられるのはいいですね。。このおかげでコードもだいぶ削れることができました。

と、いうわけで次は似たような処理が入ってる[musical](https://github.com/katsuma/musical)を書き換えようと思います。（実際は書き換えを行っていたのを再開しようと思います）
musicalは全くSpec書かれていなかった上に、いろいろバグが見つかっていたので、そのへんも合わせて整理しなおしですね。。


