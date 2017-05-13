---
title: "「FlashのCamera・Microphoneクラスを使うときの注意点」の注意点"
date: 2008/11/08
tags: actionscript
published: true

---

<p><a href="http://www.flickr.com/photos/katsuma/3011897140/" title="Camera/Microphone security panel by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3044/3011897140_3bb3703be3_m.jpg" width="214" height="134" alt="Camera/Microphone security panel" /></a></p>

<p><a href="http://www.trick7.com/blog">trick7さん</a>で「<a href="http://www.trick7.com/blog/2008/11/08-004042.php">FlashのCamera・Microphoneクラスを使うときの注意点</a>」というエントリがあがっていました。FlashでCamera, Microphoneを使うときに次の注意点が必要、とあります。</p>


<blockquote>
FlashでWebカメラやマイクを使う時の落とし穴。おなじみの上のパネルはFlashのステージサイズが横214px、縦156px以上ないと、どれだけスクリプトが正しくっても表示されない。Webカメラを使った横幅160pxのブログパーツを作るぞと意気込んで4時間もハマってしまったので、これは共有しておくべきだと思いました。ブログパーツを作ろうとしてる人は気を付けてくだせい。</blockquote>

<p>ただ、これって8割ほど正解なのですが、ものすごく細かく言うと何が何でもカメラ、マイクを利用するときに214x156以上のステージサイズが要求されるかというと、そうでも無いのです。</p>

<p>上記のパネルが表示されるときはプライバシー保護のためなので、カメラやマイクで取得した映像、音声がFlashPlayerを通して表示、通信されようとするとき、つまり以下のattach系のメソッドを実行しようとしたときに表示されます。（もしかするとSound系でまだあったかも。。？把握しているのはこのあたりのメソッド）</p>

<p><ul>
<li>Video#attachCamera</li>
<li>NetStream#attachCamera</li>
<li>NetStream#attachAudio</li>
</ul></p>

<p>要するに実際に映像と音声を扱おうとしたときのみにセキュリティパネルが表示されるわけです。</p>

<p>では、それ以外の場合なんてありえるの？という話になるわけですが、たとえばCameraクラスには利用できるデバイスのリストを取得するCamera.namesというstaticなプロパティがありますが、このgetterではセキュリティパネルは表示されません。</p>

<p><pre>
var devices:Array = Camera.names;
</pre></p>

<p>たとえばカメラやマイクを扱うFlashアプリケーションで、ユーザの環境チェックを行いたいときに簡易的なセルフチェックページを作るなんかに、1x1のswfを作っておいてExternalInterface経由でJavaScriptからデバイス数を取得、なんてのも可能です。</p>

<p>とは言っても、こういうケースは実際には少なくほとんどのケースではCamera/Microphoneは何かしろのオブジェクトにattachするケースばかりでしょう。なので、やっぱりtrick7さんのおっしゃる通りにステージサイズには注意をしておいたほうがベターだと思います。</p>


