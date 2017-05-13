---
title: iTunesのプレイリストのトラック情報を整形してクリップボードに保存する
date: 2014/11/01
tags: applescript
published: true

---

たまに社内のイベントなんかでBGM担当になることがあって、後日「こういう曲をかけたよ」を伝えるのに毎回丁寧にエディタで書いてたのですが、さすがに２時間分のプレイリストなんかを作ると写経が面倒くさくなったのでAutomatorで整形データを作れるようにしてみました。サービス化したので、iTunesから実行できる。どうでもいいけど、Automatorいじったの初めて。

- [playlist_tracks](https://github.com/katsuma/playlist_tracks)

iTunesでプレイリスト選択して、iTunesのメニューから「サービス」> 「Copy tracks from playlist」を選択すれば、「トラック名 / アーティスト名」のフォーマットでクリップボードに追加してくれます。あとは、エディタなり何なりにペーストしてよしなにやればOK。

![](https://raw.githubusercontent.com/katsuma/playlist_tracks/master/screenshot.png)

本当は、iTunesのコンテキストメニューに追加して、「プレイリスト選択」 > 「右クリック」> 「Copy tracks from playlist」でいけるようにしたかったけど、Automatorで実現する方法がよくわからなかった。。多分、無理そう。
というか、Finder以外のアプリってコンテキストメニュー操作できるのかな？？


