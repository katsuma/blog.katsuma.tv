---
title: MT3.3からMT5.2にアップデートしました
date: 2012/11/24 12:30:25
tags: ''
published: true

---

2006年頃にこのBlogを作ってからずっとMT3.3のまま放置し続けていたのですが、初めてバージョンアップを行いMT5.2に上げました。一気に本番環境で作業するとヤバそうな気がしていたので

- バージョンアップ前のDBとファイル全体のスナップショットを保存
- 作業用ディレクトリとドメインを別に切って作業

と、慎重に作業したつもりでしたが、それでも罠も多くて

- /indexが標準で直近N日のエントリしか表示されないので、真っ白になる
- MT3.3時代のURLが変更される（「_」が「-」にデフォルトで変換されてる）
- DNSの切り替えミスって管理画面にアクセスできなくなる

などにハまりましたが、なんとか動くようになりました。

今更MTかよ！な声もありそうですが、MT5.2になるとmarkdownで記事を書けるし、いざとなれば最新環境になったのでMT以外のツールへのexportもやりやすくなるでしょう（と、言い聞かせてる）。

あと副次的な効果として、これを機会にJavaScriptライブラリを一新したり、ウィジェット系を全部取っ払うことでページのレンダリングも速くなったのは良いことですね。


