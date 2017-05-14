---
title: KeynoteをRubyから操作するkeynote-clientを作りました
date: 2015/08/10 00:57:42
tags: ruby
published: true

---

唐突の約１年ぶりのエントリーになりますが、[itunes-client](https://github.com/katsuma/itunes-client)の親戚みたいなかんじの[keynote-client](https://github.com/katsuma/keynote-client)を作ってみました。

- [Github](https://github.com/katsuma/keynote-client)
- [RubyGem](https://rubygems.org/gems/keynote-client)

## これは何？

`itunes-client`と同様、高レベル（のはず）なAPIでKeynoteを操作できます。たとえばこんなかんじ。

<pre>
require 'keynote-client'

# インストール済のテーマ一覧を取得
themes = Keynote::Theme.find_by(:all)

# 特定の名前のテーマを取得
theme = Keynote::Theme.find_by(name: 'cookpad').first

# テーマを指定して新しいドキュメントを作成
doc = Keynote::Document.new(theme: theme, file_path: '/path/to/slide_name.key')

# 現状のスライド一覧
doc.slides

# 利用可能なマスタースライド一覧
doc.master_slides

# マスタースライドを指定して、新規スライドを追加
doc.append_slide("タイトル & 箇条書き")

# 保存
doc.save
</pre>

スライドを追加するあたりのAPIがかなり微妙なんですけど、Keynoteのマスタースライドを一意に指定する方法が名前しか無く、これも言語環境によって名前が同じドキュメントでも変わってしまうという、かなり辛い仕様なので対応方法が結構難しい感じです。頑張ればどうにかできそうか。。本当はシンボルを指定したい。

あとスライドはappendするとき、またはappendした後にタイトルや本文を更新できるようにすれば、シンプルなスライドであればひと通りの自動生成できそうかな。

## 背景
[@k0kubun](https://github.com/k0kubun)がLTのスライド作らずに[スライドを作るツールを夜な夜な作って](http://k0kubun.hatenablog.com/entry/2015/08/08/192309)るのを見てゲラゲラ笑ってたのですが、[AppleScriptで疲弊してそうな印象が強かった](https://github.com/k0kubun/md2key/tree/master/scripts)ので、itunes-clientの知見をどうにか活かせないかなーと思ったのと、[JXA](https://developer.apple.com/library/mac/releasenotes/InterapplicationCommunication/RN-JavaScriptForAutomation/#//apple_ref/doc/uid/TP40014508-CH109-SW12)を一度使ってみたいなーと思ってたので、その練習がてらがっと書いてみました。

JXA、謎仕様が依然多いですが、少なくともAppleScriptよりだいぶ書きやすいので、感覚つかむまでの速度はだいぶ速くいけました。md2keyもJXAに切り替えちゃってもいい気もしますね。。

## 今後
スライドのタイトル、本文くらはいじれるようになると実用段階になると思うので、そうしたらmd2keyの下地をいい感じにしてあげられないかなーと企んでます。まだまだ実装雑なので、PRもお待ちしています！



