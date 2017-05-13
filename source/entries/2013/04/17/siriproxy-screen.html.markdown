---
title: Siriでスクリーンセーバー操作を行うSiriProxy-Screen
date: 2013/04/17
tags: ruby
published: true

---

### SiriProxy-Screenって何？

- [SiriProxy-Screen](https://github.com/katsuma/SiriProxy-Screen)

またまたSiriProxyのプラグインの形で、Siriでスクリーンを操作できるものを作りました。と、いってもスクリーンセーバーを起動できるだけです。

> 画面を消して

とSiriに言う事で、スクリーンセーバーを起動することができます。
これでマウスやキーボードが無いマシンでも安心してスクリーンセーバーを起動して離席することができますね。

<iframe width="420" height="315" src="http://www.youtube.com/embed/UKuWkYjmF7M" frameborder="0" allowfullscreen></iframe>

### 作った動機
社内ブログで「スクリーンをすぐロックするTips」というエントリが上がり、なぜかこのネタに限って他のエンジニアがこぞって「俺ならこうする」みたいなネタを連投する流れに。
「スクリーンをすぐロックするTips(2)」「スクリーンをすぐロックするTips(3)」... のように、次々と新しい方法のエントリが上がり、謎の祭り状態に。

<blockquote class="twitter-tweet"><p>OS X スクリーンロック Advent Calendar が始まった......</p>&mdash; Shimpei Makimoto (@makimoto) <a href="https://twitter.com/makimoto/status/323962861686763520">April 16, 2013</a></blockquote>

<blockquote class="twitter-tweet"><p>ちょっと目を話したすきにスクリーンロック祭りが...</p>&mdash; Hok.H @ Kanny (@kani_b) <a href="https://twitter.com/kani_b/status/324037509828972544">April 16, 2013</a></blockquote>


そうしている間に、スクリーンロック専用Macアプリを作る人が出てきたので、ついカっとして今回の実装にいたりました。

<blockquote class="twitter-tweet"><p>本日の社内ブログの Mac の画面ロックTipsエントリー、はじめのほう至極まともだったのに、今見たらエントリーが累計10個になっていて、 MacApp が開発されていたり Siri 経由でロックできる gem が公開されてたりして頭がおかしい感...！Mac の蓋を閉じるとは</p>&mdash; ｾコン (@hotchpotch) <a href="https://twitter.com/hotchpotch/status/324053280999215105">April 16, 2013</a></blockquote>

### とはいえ
[iRemoconのproxy](http://blog.katsuma.tv/2013/01/siriproxy-iremocon.html)のときにも書きましたが、今回も実装コードほとんど無く、ちょう簡単です。実質これだけ。

<pre>
class SiriProxy::Plugin::Screen < SiriProxy::Plugin
  listen_for /画面を?(消して|けして)/ do
    say 'スクリーンセーバーを起動します'
    `/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine`
    request_completed
  end
end
</pre>

こんな感じで簡単に祭りに参加できるSiriProxyは便利なわけですね〜。

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


