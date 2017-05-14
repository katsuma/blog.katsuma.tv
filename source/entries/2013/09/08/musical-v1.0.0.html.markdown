---
title: musical 1.0.0をリリースしました
date: 2013/09/08 19:37:59
tags: ruby
published: true

---

### musical
- [rubygems](https://rubygems.org/gems/musical)
- [github](https://github.com/katsuma/musical)

2年くらい前に書いた[musical](https://rubygems.org/gems/musical)が、全く動かなくなっていたので、ゼロから書きなおしてv1.0.0としてリリースしました。
musicalの詳しい説明は[こちらのエントリー](http://blog.katsuma.tv/2011/11/gem_musical.html)をご覧ください。

### 背景
地味なツールだというのに、Pull Requestも幾つかいただいていて、僕のつくったgemの中だと実は一番DL数が多いmusicalですが、いかんせん

- classの分け方が微妙で見通しが悪い
- そもそもテストが無いから正しく動作してるのかどうか分からない
- iTunes10になってから、まともに動作しなくなっていた

などの問題がありました。

### 何度も書きなおし
前からゼロから書きなおそうとして開発を進めていたのですが、iTunes連携部分を[itunes-client](https://github.com/katsuma/itunes-client)のgemに切り出したり、周辺の開発に伴いTravisCIやCoverallとの連携のコツが掴めてきたりして、その都度ゼロから書き直し続けていました。おそらく、今回リリースするまでに3回くらい書きなおしたはず。。

ただ、その甲斐あってか、だいぶ直感的なコードで記述することができるようになりました。もちろんSpec付きでCoverage100%キープしてます。
[main](https://github.com/katsuma/musical/blob/master/bin/musical)のコードもこんなかんじになって、割とスッキリできたんじゃないでしょうか。（一部抜粋）

<pre>
DVD.load(dvd_options) do |dvd|
  chapters = dvd.rip

  chapters.each do |chapter|
    wav = chapter.to_wav
    track = Itunes::Player.add(wav.expand_path)

    converted_track = track.convert
    converted_track.update_attributes(
      name: chapter.name,
      album: dvd.title,
      artist: dvd.artist,
      track_count: chapters.size,
      track_number: chapter.chapter_number,
    )

    wav.delete!
    track.delete!
  end
end
</pre>

### 補足
当然ながら、本gemは著作権違反の手助けをするためのものではありません。
自身の責任の元、著作権を保持しているDVDでご利用ください。


