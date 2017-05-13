---
title: PHPでffmpegの出力を格納する
date: 2007/07/18
tags: php
published: true

---

<p>Webアプリケーションにおいてffmpegを利用してメディアファイルをゴニョゴニョ操作する、なんて場面がここ最近増えてきていると思います。そんな中、ハマるポイントとして、ログの扱いがあると思います。</p>

<p>たとえば、あるファイルfooを違うフォーマットのファイルbarに変換するとき</p>

<p><pre>ffmpeg -i foo bar</pre></p>

<p>これで変換できます。（Codecの指定なんかはここでは割愛します。）なので、これをPHPから実行する場合はこんな形になります。外部プログラムを実行するのでexec関数を利用します。</p>

<p><pre>
&lt;?php
$in = 'foo';
$out = 'bar';
exec('ffmpeg -i ' . $in . ' ' . $out);
?&gt;
</pre></p>

<p>では、ここで実行時のログを保存したい、とします。execは第二引数に標準出力の結果を配列で受け取ることができるので、普通に考えると次のようになります。</p>

<p><pre>
&lt;?php
$in = 'foo';
$out = 'bar';
$log = '';
exec('ffmpeg -i ' . $in . ' ' . $out, $log);
// output log
var_dump($log);
?&gt;
</pre></p>

<p>さて、どうでしょうか？実は<strong>これでは正しい結果は出力されません。</strong>試してみると分かるのですが、実は上記のコードを実行すると、結果の冒頭２行分しか$logには格納されていません。おそらく次のような文字列が出力されたと思います。</p>

<p><pre>
ffmpeg version 0.4.9-pre1, build 4718, Copyright (c) 2000-2004 Fabrice Bellard
  built on Jul 12 2007 12:03:11, gcc: 3.2.3 20030502 (Red Hat Linux 3.2.3-56.fc5)
</pre></p>
</p>

<p>これはffmpegを利用した際に必ず出力されるログです。「いや、本当に俺が必要なのはその次からのコードなんだよ！！」と叫びたくなるのですが、なぜか微妙なところで出力は終わってしまいます。何とか全部の結果を格納できないのでしょうか？</p>

<p>結果から言うと、これは<strong>可能</strong>です。実はffmpegの3行目以降の出力は、標準出力ではなく、<strong>標準エラー出力</strong>によって出力されています。なので、exec関数で標準出力だけをキャッチしても、冒頭の２行だけしか格納できなかったのです。
</p>

<p>・・・とは言え、PHPのexec系関数では標準エラー出力をキャッチする仕組みはありません。そこでどうすればいいかと言うと、標準エラー出力を標準出力につないでやります。つまり</p>

<p><pre>
exec('ffmpeg -i ' . $in . ' ' . $out . '<strong> 2>&1</strong>', $log);
</pre></p>

<p>と、やります。（shやbashの場合です）</p>

<p>すると、全てのffmpegの結果を変数$logに格納することができます。var_dumpなり、Stringにまとめるなりすると</p>

<p><pre>
ffmpeg version 0.4.9-pre1, build 4718, Copyright (c) 2000-2004 Fabrice Bellard
  built on Jul 12 2007 12:03:11, gcc: 3.2.3 20030502 (Red Hat Linux 3.2.3-56.fc5)
Input #0 ... , from 'foo':
  Duration: 00:00:09.8, bitrate: 80 kb/s
  Stream #0.0: Video: ...
  Stream #0.1: Audio: ...
Output #0, wav, to 'bar':
  Stream #0.0: ...
</pre></p>

<p>などと続き、全ての情報を確認することができます。</p>

<p>しかし、3行目以降が標準エラー出力で出力されるのは、個人的にはどうも気持ち悪いです。。純粋なログの情報ですし、「標準出力でいいのでは？」と思うのは僕だけでしょうか？？</p>
