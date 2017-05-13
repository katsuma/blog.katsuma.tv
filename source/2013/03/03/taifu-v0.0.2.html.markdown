---
title: taifu-0.0.2.gemをリリースしました
date: 2013/03/03
tags: ruby
published: true

---

[taifu](http://rubygems.org/gems/taifu) v0.0.2をリリースしました。

- [RubyGems.org](http://rubygems.org/gems/taifu)
- [Github](https://github.com/katsuma/taifu)

変更点は次の通りです。

- Ruby 2.0.0 サポート
- rb-appscriptの依存を排除
- specを追加し、[Travis CI](https://travis-ci.org/katsuma/taifu)で運用

### Travis CI
Travis CIは初めて触りましたが、簡単に導入できるので非常に良いですね。

1. githubアカウントでTravis CIにログインし、AccountページからTokenを取得
2. githubのプロジェクトのページのService HooksのTravisの設定を開く
3. 1.で取得したTokenを設定

これだけでOKです。

以降は、githubにpushするたびにCIが走ります。
CIの結果は画像でも取得できるので、プロジェクトページの[Readme](https://github.com/katsuma/taifu)に掲載もできます。

あと、サポートするRubyのバージョンを2.0.0とあわせて1.9.3もサポートしたかったので、.travis.ymlを以下のように設定しておくと自動的に両バージョンでテストしてくれます。便利！

<pre>
language: ruby
rvm:
  - 2.0.0
  - 1.9.3
</pre>

## 使い方
過去ログになりますが、こちらを参考ください。

- [YouTubeの音声をiTunesに転送するgem - taifu](http://blog.katsuma.tv/2012/09/gem-taifu.html)


