---
title: はてブの最近の人気エントリーのTwitter用botを作ってみました
date: 2008/01/23 20:39:05
tags: perl
published: true

---

<p>はてブのホットエントリーのエントリを定期的にポストしてくれるbotを作成してみました。</p>

<p><a href="http://twitter.com/hotentry">http://twitter.com/hotentry</a></p>

<p>ホットエントリのbotは、すでに「<a href="http://twitter.com/hatebu">hatebu</a>」というbotがいて僕もFollowしていたのですが、「一気に当該サイトに飛んでしまうんじゃなくて、はてブのコメント読みたいよね」な話を会社でしていて、「だったらコメントページに飛んでくれるbotを作ってみる？」な流れになり、Perlの勉強がてら一気に作ってみました。</p>

<p>Perlをまともに書いたのは6,7年ぶりで、CPANのモジュールをまともに使ってコード書いたのは初めてでした。簡易掲示板みたいなものをゴリゴリと書いてたのが懐かしい。。。</p>

<p>ホットエントリのRSSをcronで定期巡回して以前に取得したデータとの差分をTwitterにPostするだけ、な簡単なコードですが、いざ書いてみると詰まることが相当多かったです。以下、備忘録として詰まった点をまとめておきます。</p>

<h3>差分の取り方に悩んだ</h3>
<p>最初は宮川さんの「<a href="http://blog.bulknews.net/cookbook/blosxom/rss/rss2email.html">RSS をメールで送信する</a>」を参考にしようと思っていました。メールで送信する箇所だけをPostするのに変更するだけだから簡単だろう、、と思ってたら、はてブのRSSってDublin Core の日付属性"dc:date"が入っていないんですね。。なので、宮川さんの方式だと使えないことに。</p>

<p>便利なモジュールもありそうだと思いつつも、なかなか辿り着かなかったのでPostしたURLのリストのヒストリーデータを保持させておいて、定期的に取得する新着データと比較することで差分を取得するようにしておきました。ただ、作り終えてから<a href="http://ido.nu/kuma/2007/07/13/handling-xupdate-with-perl-xmlxupdatelibxml/">xmldiff</a>なるものを発見したので、こっちの方が便利かな、とも思います。</p>

<h3>サブルーチンに複数の配列がうまく渡らない</h3>
<p>次に差分を取得するためのサブルーチンを書こうとしたのですが、サブルーチンに複数の配列がうまく渡らない。。<a href="http://www.rfs.jp/sb/perl/02/07.html">よく調べてみると</a>リファレンスを渡すことで回避できるそうで。配列が１つにまとまって渡されるとか、普段JavaScript書いてばっかの頭だと予想だにしない仕様でした。これPerl屋さんって面倒とか思わないのでしょうか？？</p>

<h3>コメントページのURLをそのままPostするとダメ</h3>
<p>はてブのコメントページのURLは http://b.hatena.ne.jp/entry/{$url}な形式になるわけですが、このURLをそのままPostすると、Twitterの表示時にTinyURLの変換に失敗することがありました。実際はGigazineあたりでよく出ていたのですが、{$url}がクエリストリングの形のURL（http://xxx.com?a=b）の場合、「?」以降がTinyURL化されずに残ってしまい、存在しないURLが生成されてしまうことがありました。</p>

<p>TinyURLのサイトで変換すると正常に変換できるので、どうもTwitter側のURL抽出アルゴリズムにバグがある模様。なので、Twitter側からTinyURLに変換されるとマズいので、BotがPostする段階でTinyURL化させておいて、そのURLをPostすることにしました。TinyURL化は<a href="http://masahikosatoh.com/tinyurl_api/">TinyURL API</a>なるものがあるので、これをHTTP::Liteで叩いています。</p>

<h3>なんとか完成</h3>
<p>と、面倒なことをかいくぐって何とか動くものができました。叩かれるのを覚悟でソースも晒しておきます。RSS取得で差分を好きなようにPostするから基本的には使い回しが効くかとは思います。</p>

<p><a href="http://blog.katsuma.tv/misc/hotentry.txt">hotentry.pl</a></p>
