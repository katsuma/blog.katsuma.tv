---
title: middleman 3.2系から3.3系へupgrade時、wrap_layoutに気をつける
date: 2014/09/07
tags: ruby
published: true

---

[ALOHA FISHMANS](http://alohafishmans.com/)のサイトで使ってるmiddlemanのバージョンは、長らく3.2.0を使っていたのですが、いい加減そろそろ最新のバージョンにあげておくか。。と思ったところ、結構ハマったのでメモ。

## 空白のページがrenderされる
バージョンの変更はGemfileを書き換えてbundle updateすると、基本的にはOK。Gemfileのdiff的にはこんなかんじ。

<pre> gem "redcarpet", '~> 3.1.1'
-gem "middleman", "~> 3.2.0"
+gem "middleman", "~> 3.3.5"
 gem "middleman-blog", '~> 3.5.2'
 gem "middleman-minify-html", '~> 3.1.1'
 gem "middleman-deploy", '~> 0.2.3'
</pre>

renderされるページの内容を確認していたところ、基本的に問題ないように見えつつ、blogページだけ何も出力されません。（bodyがカラ）

何か仕様が変わったんだろうと思いつつ、[ChangeLog](https://github.com/middleman/middleman/blob/v3-stable/CHANGELOG.md)見てもよくわからないな。。。と途方に暮れて検索検索。

## wrap_layout

の、ところ気になるIssueを発見。

- [render blank pages after upgrading middleman to 3.3.2](https://github.com/middleman/middleman-blog/issues/207)

見事これでした。テンプレートエンジンにhaml/slim を使っていて、wrap_layoutでレイアウトを上書きしているとき、

<pre>- wrap_layout :layout do
  ...
</pre>

を

<pre>= wrap_layout :layout do
  ...
</pre>

にしないとダメな模様。これで手元でも正常にbodyが出力されるようになりました。

で、よくよく[ChangeLog](https://github.com/middleman/middleman/blob/v3-stable/CHANGELOG.md#330-332)見直すと

<blockquote>Update Padrino to 0.12.1. Introduces BREAKING CHANGE for Haml. Helpers which take blocks used to require - instead of = to work correctly. Now, all helpers which output content should use =.
</blockquote>

って、書いてるのが該当する話の模様。（気づかねぇ。。。）


