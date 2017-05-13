---
title: Gmailのビデオチャットで利用しているCodecはH.264（っぽい）
date: 2008/11/13
tags: develop
published: true

---

<p>Gmail上で本日付でビデオチャット機能が追加されました。これ自体はGoogleだったらいつかはやるだろうな、と思っていたので特に驚かなかったのですが、そんなことよりも利用しているCodecが何なのか？の方が個人的に気になりました。</p>

<p>映像はブラウザ上で再生されるのですが、どうやらFlashPlayer上で再生されている模様。（右クリックでポップアップされるメニューがいつものアレ）ただ、画質がすごく綺麗。Flashでライブストリーミングをやったことがある人だったら分かる人もいるかもしれませんが、ほんとありえない綺麗な画質。念のため補足しておくと、Flashで利用できる映像ストリーミングのCodecは次の種類があります。</p>

<p>
<table border="1">
<thead>
<tr>
<th>Codec</td>
<th>導入されたFlashPlayer</td>
</tr>
</thead>

<tbody>
<tr>
<td>Sorenson Spark </td>
<td>6</td>
</tr>

<tr>
<td>On2 TrueMotion VP6-E</td>
<td>8</td>
</tr>

<tr>
<td>On2 TrueMotion VP6-S</td>
<td>9.0.115.0</td>
</tr>

<tr>
<td>H.264</td>
<td>9.0.115.0</td>
</tr>
</tbody>
</table>
</p>

<p>この中のSorensonのCodecがFlashPlayerでカメラデバイスから映像を拾ってストリーミングするときに利用できるCodec。これは特に軽さを重視したCodecで、お世辞にも綺麗な映像とは言えないものの、マシンに大きな負荷をかけずにストリーミングを行うことが可能。<a href="http://ustream.tv/">Ustream</a>や<a href="http://www.stickam.jp/">Stickam</a>、<a href="http://live.utagoe.com/">Utagoe Live100</a>なんかでライブを行うときもこのCodecを利用することになります。</p>

<p>ただこれだとプロユースというか、まともな高画質のストリーミングを行うことは無理なので、負荷が大きくなっても品質のいい配信をしたい！なんてときはVP6やH.264のCodecを利用してストリーミングを行うことになります。この場合はブラウザからのストリーミングは無理で、Adobeの<a href="http://www.adobe.com/jp/products/flashmediaserver/flashmediaencoder/">Flash Media Live Encoder</a>などの専用ソフトを利用したストリーミングとなります。<p>

<p>で、やっと本題なのですが、今回のGmailでのビデオチャットはFlashを利用しているのでSorensonのCodecを利用すればインストールレスでチャット可能なはずなのに、わざわざプラグインのインストールを必要としています。つまりこれ専用のEncode処理をクライアント側のプラグインで行っている、ということ。かつ、FlashPlayerで再生可能、ということでVP6かH.264のどちらか。。。とは言ってもさすがにH.264のDecode処理はまだ重いしな。。。なんかを考えてオフィシャルGmail Blogを読んでいると次のような記述がしれっと書かれていました。</p>

<blockquote>
<p>
And in the spirit of open communications, we designed this feature using Internet standards such as XMPP, RTP, and H.264, which means that third-party applications and networks can choose to interoperate with Gmail voice and video chat.</p>

<p>
via <a href="http://gmailblog.blogspot.com/2008/11/say-hello-to-gmail-voice-and-video-chat.html">Say hello to Gmail voice and video chat</a></p>
</blockquote>

<p>おおお、というわけでこのCodecはどうもH.264っぽい。やけに綺麗と思った理由はこれだったのですね。あとinternet standardという理由からVP6は却下になったんでしょうか。</p>

<p>あと、気になった点としてこのチャットの利用帯域。今日<a href="http://twitter.com/ishida">@ishida</a>と遠隔地でテストしていたのですが、その利用帯域をメモってくれていました。</p>

<blockquote>
<p>gmail videochat up:800~1000kbps/down:600~800kbps</p>

<p>via <a href="http://twitter.com/ishida/status/1001748154">Twitter</a></p>
</blockquote>

<p>普段、Sorensonでのストリーミングばかり見慣れている自分としては、「Flashのストリーミングは映像での利用帯域は代替250kbps前後」という感覚が強かったのでこの利用帯域はちょっとびっくり。でも映像のクオリティを考えるとこのレートでも低い値なのかもしれません。</p>

<p>また、<a href="http://japan.cnet.com/news/media/story/0,2000056023,20383475,00.htm">CnetでCPUリソース食い過ぎてる！という話が出ていました</a>が、これもH.264のソフトウェアエンコードをしていることを考えると、納得できそうな話です。</p>

<h3>まとめ</h3>
<p>Flash Playerの前提条件や実験結果からの推測などを総合して考えても今回のビデオチャットの利用CodecはH.264と言えそうです。また、僕が知る限り、ブラウザ起動でできるH.264ストリーミングは多分今回が初事例。と、いうわけでしれっと始まったGoogleのビデオチャットはいろいろと面白い話が潜んでいるようです。</p>


