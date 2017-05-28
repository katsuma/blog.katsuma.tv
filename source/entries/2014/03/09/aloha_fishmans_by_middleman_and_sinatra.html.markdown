---
title: Middleman + SinatraでALOHA FISHMANSのサイトをリニューアルしました
date: 2014/03/09 03:32:18
tags: ruby
published: true

---

[![](/images/logo_aloha.png)](http://alohafishmans.com/)

去年の秋頃、友人経由で、Fishmansファンのためのイベント「[お彼岸ナイト](http://alohafishmans.com/events)」を開催している[ALOHA FISHMANS](http://alohafishmans.com/)の人たちを紹介してもらったのですが、何か僕で手伝えることがあれば、、というわけでサイトのフルリニューアルを手伝わせていただきました。

- [ALOHA FISHMANS](http://alohafishmans.com/)


今回利用した技術としては

### フロントエンド
- [middleman](http://middlemanapp.com/)
 - [middleman-blog](https://github.com/middleman/middleman-blog)
- [Haml](http://haml.info/)
- [Sass](http://sass-lang.com/)
 - [Foundation](http://foundation.zurb.com/)

### バックエンド
- [Sinatra](http://www.sinatrarb.com/)

### インフラ
- [さくらのVPS](http://vps.sakura.ad.jp/)
- [nginx](http://nginx.org/)
- [unicorn](http://unicorn.bogomips.org/)
 - [unicorn-worker-killer](https://github.com/kzk/unicorn-worker-killer)

### コード管理
- [github](https://github.com/)(のプライベートレポジトリ)


な、感じ。

今回、このリニューアルでいろいろハマったところや工夫できたことがあったので、もろもろまとめたいと思います。

## CSSフレームワーク
以前のサイトは、PCでの閲覧のみ意識していたような作りになっていたので、スマホ（というかタッチデバイス）への対応が一番の要件でした。

さて、じゃぁレスポンシブ対応のCSSフレームワークを選ぶか、、と思って選定に入りました。検討したのはこんな感じ。

- [Twitter Bootstrap](http://getbootstrap.com/)
- [Foundation](http://foundation.zurb.com/)
- [Skelton](http://www.getskeleton.com/)
- [HTML KickStart](http://www.99lime.com/elements/)
- [Pure](http://purecss.io/)

CSSフレームワークは似たものが乱立していてさてどうするか。。と思ったのですが、こんな基準で選びました。

1. サイズが小さい
2. スマートフォンに最適化されたUIが標準で用意
3. フレームワークに依存したマークアップを強要されない

Bootstrapは1.が引っかかってやめました。あと、デフォルトの見た目が「いかにも」な感じになるのでもうちょっとシンプルで単純なスタイルが欲しかったこともあって利用はヤメ。

Foundationは全体的にバランスがいいのですが、メニューまわりのマークアップがちょっと複雑なので保留に。最終的には利用することにしたのですが、正直いまだにメニューまわりにクセがある印象なので、そんなに強くオススメできません。。

Skeltonはシンプルでいいんだけども2の観点で見ると、自分でスタイルいじるのは最低限に抑えたかったので、全然スマホサイトっぽい感じがしなかったのでヤメ。

HTML KickStartはすごく単純なマークアップで一番最初は利用していたのですが、メニューまわりのデフォルトの見た目がまったくスマホサイトっぽくない感じだったので途中でヤメました。

Pureはフォント周りのスタイルは一番好きなのですが、マークアップに`pure-*`とフレームワーク依存のclassやdata属性を強要されるのがどうにもシックリこなかったのでヤメ。

### ベストなものは無い
これだけ乱立してるCSSフレームワークだから、さすがにグッとくるものがあるだろう。。と思い込んでたのですが、正直いまだにグッとくるものは見つかってません。。
Foundationを消去法的に利用しましたが、デフォルトのリストUIの見た目はあまりグっとこなかったので、結局いろいろベースとなるスタイルは自分で用意しました。

たとえばクックパッドで利用している[Saraフレームワーク](https://speakerdeck.com/hotchpotch/liao-li-wozhi-eruji-shu-2012?slide=107)は、このへん見た目的にもマークアップ的にも、相当使いやすくなっていると実感できたので、SaraがOSSで公開されてれば。。（チラッチラッ）と何度も思った次第です。

そう考えると、これだけCSSフレームワークが乱立するのもやはり一周回って理解できるわけで、みんな痒いところに手を届かせるために「俺の考えた最強CSSフレームワーク」を作ろうとするんでしょうね。。

## middleman

フロントエンドの基盤はmiddlemanにするのは最初から決めていました。

オリジナルのサイトはベースはPHPで実装されていて、チケット管理ページなど動的ページが一部あるものの、ユーザに見える部分はほぼ全てのページが静的な情報なため、PHPのメリットはレイアウトをDRYに書ける、というところに留まっていそうでした。

middlemanは最終的に静的なページを出力しつつ、

- haml/slimなどのテンプレート言語
- assetパイプライン
- LiveReload

などのツールがすぐ使えるので、最近のRailsで開発するような感覚で開発を進めることができるのが大きなメリットです。

実際今回触った感想としてmiddlemanは大正解でした。今後も数ページだけのサイトだったらmiddlemanを利用しない理由は無いんじゃないかな、と言えそうです。1点を除いては。。

## Sinatra

1点を除いては、と言ったのは動的なページが出てきたときの対応です。

middlemanはそもそも静的サイトジェネレータなので、動的なページなんて入れようとするほうが悪いのですが、いかんせん必要なものは必要です。今回もイベントのチケット予約に１ページだけ必要でした。

ロジックはシンプルなのでSinatraで完結できれば。。と安易に思っていたのですが、いかんせん事例がほとんどありません。milddeman公式サイトにももちろん載っていません。

で、おそらく唯一であろうヒントはmiddleman作者の[Thomasさんのコードの断片](http://forum.middlemanapp.com/t/middleman-and-sinatra-together/863)。要するにconfig.rbに特定のパスだけSinatra::Baseにリクエストを処理させる方法です。

「開発時はいいけどリリース時はproduction環境にどうやって載せるんや。。。」と悩んでたのですがnginxで特定のパスへのリクエストだけUnicorn（で動かしたSinatra）へリクエストを流すようにすればなんとかなりそうかも？と思ってトライ。このへんのインフラ全然触ったことなかったのでハマりましたが、なんとかかんとかできました。

### ディレクトリ構造
開発時はこんな感じにしてます。

- build (ビルドしてできる静的HTMLファイル)
- app (Sinatraなんかの動的な処理をまとめ)
 - config.ru (production用、開発時は使わない)
- source (静的ページの開発)
- config.rb (Sinatraの設定)

`middleman build`するとminifyやgzip化されたHTMLファイルがbuildディレクトリにできるので、リリース時はこの中身をまるっとrsync。nginxも基本このファイルを直接返します。

`app`はSinatraの実態。たとえばこんなかんじ。

#### app/ticket_reservation.rb

```

require 'sinatra'
require 'active_record'
require 'mysql2'
require_relative 'models/ticket'

config = YAML.load_file('./database.yml')
ActiveRecord::Base.establish_connection(config["db"]["development"])

class TicketReservation < Sinatra::Base
  post '/reserve' do
    ...
    redirect '/events/reserved'
  end
end
```

こいつを`config.rb`から呼び出しておく。

#### config.rb

```

require_relative 'app/ticket_reservation'

...

map '/tickets' do
  run TicketReservation
end
```

これで、`middleman server`で手元でサーバを起動すると`/tickets`のリクエストだけSinatraでハンドリングすることができます。

#### app/config.ru

開発時は利用しないのですが、productionではUnicornで利用するために必要です。プロセスの再起動はいい感じのタイミングにお願いしたいので、unicorn-worker-killerに任せてます。（設定はデフォルトのまま...）

```

require_relative 'ticket_reservation'

# Unicorn self-process killer
require 'unicorn/worker_killer'

# Max requests per worker
use Unicorn::WorkerKiller::MaxRequests, 3072, 4096

# Max memory size (RSS) per worker
use Unicorn::WorkerKiller::Oom, (192*(1024**2)), (256*(1024**2))

# Run main app
run TicketReservation
```

### production環境
こんなかんじのディレクトリツリーにしてます。

- alohafishmans.com
 - app
 - public

リリース時は

- build ⇛ public
- app ⇛ app

へrsyncして、appのコードを変更したときのみUnicornを再起動させています。

### nginx

config.rbでの設定と同じような感じで設定します。/ticketsへのリクエストだけをUnicornを利用するようにします。こんなかんじ。
#### alohafishmans.com.conf

```
upstream unicorn_alohafishmans {
  server unix:/path/to/alohafishmans.com/app/tmp/sockets/unicorn.sock
  fail_timeout=0;
}

server {
  server_name alohafishmans.com;

  location ^~ /tickets/ {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://unicorn_alohafishmans/;
  }

  location / {
    root /path/to/alohafishmans.com/public;
  }
}
```

## その他の問題
基本的な構成は以上なのですが、その他にも細かいとこにもいろいろハマりました。。一応メモがてら残しておきます。

### 濁点問題
今回ブログのコンテンツのURLを、SEOを意識してタイトルをパス名に入れたURLにしました。例えばこんな感じ。

- [3/22「お彼岸ナイトvol.8 2014春」まであと1ヶ月！！](http://alohafishmans.com/blog/2014/02/23/3-22%E3%80%8C%E3%81%8A%E5%BD%BC%E5%B2%B8%E3%83%8A%E3%82%A4%E3%83%88vol-8-2014%E6%98%A5%E3%80%8D%E3%81%BE%E3%81%A7%E3%81%82%E3%81%A81%E3%83%B6%E6%9C%88!!/)

これも実際は「3/22「お彼岸ナイトvol.8 2014春」まであと1ヶ月！！」ディレクトリと、その直下にindex.htmlを作っているだけですが、buildしてrsyncするとアクセスできず404が。
どうもディレクトリ名がバグっておかしなものになっている模様。。

日本語が悪い？？と思いきや、アクセスできるページもある。１文字づつ削って、問題の切り分けをするとどうやら「まであと1ヶ月」の「で」が悪い模様（！）

なんだこりゃ。。。。と思いきや[UTF8-Mac](http://macwiki.sourceforge.jp/wiki/index.php/UTF-8-MAC)のエンコーディングに起因する話な模様。解決策としてはrsyncを3系にバージョンアップして(brew install rsyncでOK)iconvオプションをつければ良い。

```

rsync --iconv=UTF-8-MAC,UTF-8 -avz build/ foo@bar:/path/to/alohafishmans.com/public
```

### FacebookのLikeをすると「You like 404 Not Found」問題

Likeボタンはそれなりに何度も設置しているつもりなのですが、今回はogpの設定をして、DeveloperページのDebuggerで見て情報が正確に設定されているにもかかわらず。Likeするとダイアログに「You like 404 Not Found」が出る、という謎現象に悩まされました。

類似の話として[SEM pdxの記事](http://www.sempdx.org/blog/like-404-found/)で全く同じものがあったのですが、向こうでは「IPv6を無効にしたらどうにかなったよ」と言ってる一方、僕の方では無効にしても全く変化なし。

で、やっとこさ気づいたのですが元々のボタンを

```

.fb-like{ data: { layout: 'button_count', width: '130', href: CGI.escape(page_url) }}
```

にしていたのですがdata-hrefの指定がどうも間違っていいた模様。正解は

```

.fb-like{ data: { layout: 'button_count', width: '130', href: page_url }}
```

コレ。

日本語がパスに含まれてるのを気にしてURLエンコードしていたのですが、まさかそれが足を引っ張っていたとは。。。
（[ドキュメント](https://developers.facebook.com/docs/plugins/like-button)見てもURLエンコードについて特に何も書いて無さそうなのですが。。）

## まとめ
久々にゼロの状態からインフラ、DB、アプリケーションの実装まで全部実装したのですが、いい勉強になりました。特にインフラ面は現職ではセットアップ周りを自分ですることはここ数年ほとんどなかったので、仕組みを理解するいい機会になったと実感しています。

また、middlemanは相当使いやすく便利な一方、少しでも凝ったことをしようとするとハマるポイントも割りとあるので、改めて別途エントリをまとめるなり、プラグイン系へ修正PR投げるなりして貢献したいと思います。

最後に、Fishmans好きな人は[お彼岸ナイト](http://alohafishmans.com/events)もぜひぜひ遊びにきてください :)
