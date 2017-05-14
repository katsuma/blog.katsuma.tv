---
title: YouTubeの音声をiTunesに転送する
date: 2011/12/29 21:16:12
tags: ruby
published: true

---

<p>年の瀬になんかちゃっちゃと作りたかったので、単機能musicalみたいな<a href="https://gist.github.com/1515069">taifu</a>というスクリプトを書きました。</p>

<p><script src="https://gist.github.com/1515069.js?file=taifu"></script></p>

<h3>これは何？</h3>
<p>YouTubeでかっこういい動画を見つけたときに、iTunesで音だけでも聴きたい！な時は割とあるかと思いますが、それを実現するスクリプトです。実行権限を追加して</p>

<p><pre>taifu http://www.youtube.com/watch?v=KPWfBfFFrwsx</pre></p>

<p>で、wavデータを標準のエンコーダ設定でエンコードして何事もなかったようにiTunesに追加します。（要VLC.app）</p>

<h3>タグ情報はどうなってるの？</h3>
<p>「TAIFU_NAME」「TAIFU_ARTIST」「TAIFU_ALBUM」の名前でタグ付けされているので、iTunes上から「TAIFU」で検索したら追加された曲が見つかるはずです。あとは自分の好みのタグ情報に更新ください。オプションで渡すことも考えたけど、iTunes上で編集したほうが楽だったのでやめました。</p>

<p>「あーこれいつでも聴いていたいな〜」なものを見つけたとき、ご利用ください！</p>


