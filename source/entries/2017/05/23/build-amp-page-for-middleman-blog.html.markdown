---
title: middleman-blogをAMP対応させる
date: 2017/05/23 00:00:00
tags: web, middleman
published: true

---

前回[このブログをHTTP2対応させた話](/2017/05/http2.html)をしましたが、その際にMovableTypeからmiddleman-blogに移行しています。
移行そのものの話も書きたいのですが、今回はmiddleman-blogのエントリを[AMP](https://www.ampproject.org/)対応させたのでその話を書きます。

AMP対応の細かなフローは[公式サイトのチュートリアル](https://www.ampproject.org/docs/tutorials/create)を見れば理解できると思います。要は、

- AMP用のJavaScriptを読み込む
- 自前のJavaScriptはロード、実行できない
- 外部スタイルシートはロードできない
- 自作スタイルシートはhead要素内に差し込む
- imgタグはamp-imgタグなど独自のタグに置き換える

あたりがポイントになります。この対応をmiddleman-blogのエントリに対して適用させます。

AMP対応が完了するとValidationが通り、このような結果になります。

- [https://validator.ampproject.org/#url=https%3A%2F%2Fblog.katsuma.tv%2F2017%2F05%2Fhttp2.html.amp](https://validator.ampproject.org/#url=https%3A%2F%2Fblog.katsuma.tv%2F2017%2F05%2Fhttp2.html.amp)

## 全体設計

カテゴリやアーカイブページなど、AMP対応はやろうと思えばいくらでもできますが、今回は固有の記事エントリのみをAMP対応させることにしました。
本ブログは、固有記事エントリのパーマリンクは

- yyyy/mm/name.html

の形式ですが、AMP対応のページは

- yyyy/mm/name.html.amp

と、拡張子をampにさせています。
実際は、この命名はなんでもよくて、 `/amp/` のようにディレクトリをURLの中で切る方法もあると思いますが、今回は「amp形式のリソース」と見なして拡張子に付けることにしています。

あとは、この固有記事とAMP対応ページをlink要素で相互に関連付けます。

### 固有ページ
```
<link href='https://blog.katsuma.tv/2017/05/http2.html.amp' rel='amphtml'>
```


### AMP対応ページ

```
<link href='https://blog.katsuma.tv/2017/05/http2.html' rel='canonical'>
```

## config.rb

AMP対応ページを作るということは、構造としてはmiddleman-blogのpermalinkと似たものを別にもう１つ作ることになります。
最初はmiddleman-blogそのものに手をいれることや、Middlemanの拡張を作ることも考えましたが、今回は `config.rb` のみを操作して次の戦略で実現しました。

1. `ready` ブロックでpermalink URLを持つリソースを抽出
2. `proxy` を利用して同一リソースで別templateを利用するページを作成
3. `after_build` ブロックで2.のページをビルド

1, 2 では例えばこのような形で実現できます。

```

amp_paths = []

ready do
  sitemap.resources.select { |resource|
    resource.path.end_with?(".html") && resource.is_a?(Middleman::Blog::BlogArticle)
  }.each do |article|
    proxy_path = "#{article.date.year}/#{article.date.month.to_s.rjust(2, '0')}/#{article.destination_path.split("/").last}.amp"
    proxy proxy_path, "layout_amp.html", locals: { article: article }

    amp_paths << proxy_path
  end
end
```
`amp_paths` はビルド対象なパスを保存しておき、`build`フェーズ(3)で再利用します。


```

after_build do
  amp_paths.each do |path|
    modify_html_as_amp_format("build/#{path}")
  end
end
```

`modify_html_as_amp_format` は

- `img`要素を`amp-img`要素に書き換え
- 外部CSSをhead内に挿入

の２つの処理を行います。

```

def modify_html_as_amp_format(path)
  html = File.read(path)

  html = use_amp_img(html)
  html = use_inline_style(html)

  File.write(path, html)
end
```

（このエントリ書いてて思ったけどデバッグ面倒くさいので、buildフェーズではなくてrender前あたりで実施してもいいかも、と思い始めた。。）

## amp-img要素への書き換え

1. `img`要素のsrc属性値からFastImageを利用して画像のサイズを取得
2. `amp-img` 要素に書き換え、src属性を置換、1.で取得したサイズを利用

のような形で書き換えています。

```

IMG_LINK_REGEXP = /<img\s[^>]*?src\s*=\s*['\"]([^'\"]*?)['\"][^>]*?>/i

def use_amp_img(html)
  html.scan(IMG_LINK_REGEXP).each do |img_sources|
    src = img_sources[0]
    scanned_src = src.start_with?('/') ? 'build' + src : src
    sizes = FastImage.size(scanned_src)
    if sizes
      html.gsub!(IMG_LINK_REGEXP, "<amp-img src='#{src}' with='#{sizes[0]}' height='#{sizes[1]}' />")
    end
  end
  html
end
```

ポイントは`amp-img`要素はレンダリングの高速化のために画像サイズを事前に伝える必要があります。
（[一応回避する方法もありますが、ここでは言及しません](https://www.ampproject.org/ja/docs/reference/components/amp-img)）
そこで、今回はFastImageを利用してサイズを取得しています。
ただし、指定画像が外部ドメインに存在する場合は、buildのたびにインターネットを介した通信が走るので、キャッシュさせるなり高速化の手法は考える余地はありますね。

## CSSのインライン化

AMPページではCSSのロードが許可されないので、head内で定義しておく必要があります。
amp用のCSSを用意することも可能ですが、今回は非AMPページでも利用しているCSSを利用することにしました。

やるべきことは単純でCSSを呼び出しているlink要素を参照しているCSSの中身で差し替えます。

```

STYLE = File.read("build/stylesheets/bundle.css")
STYLESHEET_LINK_REGEXP = /<link href="\/stylesheets\/bundle\.css" rel="stylesheet" \/>/

def use_inline_style(html)
  html.gsub(STYLESHEET_LINK_REGEXP, "<style amp-custom>#{STYLE}</style>")
end
```

上の例ではCSSを1ファイルにかためている前提なので単純な書き方ですが、
複数のlink要素が存在する場合は、正規表現でCSSファイルをマッチさせ、そのたびにhead要素に実体を差し込む必要がありますね。

### CSSの容量
ちなみに、AMP対応ページではhead内に存在できるCSSは上限が`50000 bytes`です。
この上限を超えた内容を差し込むとValidationエラーになるので注意が必要です。

```
The author stylesheet specified in tag 'style amp-custom' is too long - we saw 96941 bytes whereas the limit is 50000 bytes. AUTHOR_STYLESHEET_PROBLEM
line 5, column 13
```

本ブログはCSSフレームワークとしてBulmaを利用していますが、この容量制限にひっかかったので、
[利用に必要な最小限のCSS moduleのみをロード](https://github.com/katsuma/blog.katsuma.tv/blob/master/assets/stylesheets/app.scss)させることでこの容量問題を回避させました。


## nginxの設定

このままだと本番環境(今回はnginx)にデプロイしたところで、ブラウザからアクセスすると `.amp` ファイルがダウンロードされることになります。
そこで`mime.types`に手をいれて `.amp` 拡張子をHTML扱いさせることにします。

```

types {
    text/html                             html htm shtml amp;
    ...
}
```

## まとめ
config.rbに手をいれることで、middleman-blogのpermalinkページをAMP対応させました。

実際にはこの記事を執筆化している時点ではGoogleにインデクシング化されていないので、効果が本当にあるかどうかは不明ですが、
この記事がmiddlemanユーザーにとって大まかな指針の１つになれば、と期待しています。
