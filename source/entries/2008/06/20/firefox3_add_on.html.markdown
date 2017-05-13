---
title: Firefox3にしてプラグインが動かなくなった！と嘆いている人たちへ
date: 2008/06/20
tags: diary
published: true

---

<p><a href="http://ido.nu/kuma/2008/02/21/make-working-extensions-incompatible-with-firefox3/">kuさん</a>とかいろんな人言ってるけど、バージョンチェックを無効にしたら大抵のものは動きます。</p>

<p>一番簡単なのは<a href="http://www.oxymoronical.com/web/firefox/nightly">Nightly Tester Tools</a>のプラグインを入れればOK。ただし、最新のプラグイン（2008/06/20時点でv2.0.2）はどうもFirefox3正式版ではうまく動かないみたい。なので古いバージョンを入れてみればOKです。僕が試したのはv1.3を試しました。</p>

<p><ul><li><a href="https://addons.mozilla.org/ja/firefox/addons/versions/6543">Firefox Add-ons: Nightly Tester Tools</a></li></ul></p>


<p>これを入れた後で「ツール」→「アドオン」→「Nightly Tester Tools」→「設定」→「Add-ons」タブ？を開いて、「Disable add-on cinpatibility checking」にチェック。再起動後、今まで使っていたアドオンの大半は動かすことができます。</p>

<p>最新版ではうまく動かない、といったのは「設定」のAdd-onsタブがなぜか表示されない不具合が僕の環境ではありました。アドオンとしての更新通知もでてくるけど、何かおこりそうな気がするので僕は無視しています。</p>

<h3>Tab Mix Plus</h3>
<p>人気があるアドオンでTab Mix Plusがあると思いますが、これについてはNightly Tester Tools じゃ対応できなくて、かわりにアルファ版を入れると動きます。</p>

<p><ul><li><a href="http://tmp.garyr.net/dev-builds/">Index of /dev-builds</a></li></ul></p>

<h3>Firebug</h3>
<p>Firebugについては、英語ページから最新のv1.2をインストールするとOKです。日本語ページだとなぜかリンクが無いので注意です。</p>

<p><ul><li><a href="http://getfirebug.com/releases/">Firebug Releases</a></li></ul></p>

<p>「このアドオンは動かないぞ！」なものも正直まだあるかと思いますが、それらの対処方法もうまくシェアできるといいですね。どこかWikiとかまとまってないんでしょうかね？</p>


