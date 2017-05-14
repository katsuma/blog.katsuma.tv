---
title: FLVPlaybackで「.flv」以外のファイルを有効にする
date: 2007/07/08 00:48:54
tags: actionscript
published: true

---

<p>FLVファイルの再生を行うためのFLVPlayerを作るにはFlash8 Proに用意されてある<a href="http://livedocs.adobe.com/flash/8_jp/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00003476.html">FLVPlayback</a>コンポーネントを利用すると簡単です。スキンもあらかじめいろいろな種類のものが用意されてあるし、カスタマイズもできるので、なかなか使い勝手がよいです。</p>

<p>ところがこのFLVPlayback、かなりクセがあって、再生対象となるファイルを指定するときに<strong>「.flv」で終わる拡張子のファイルパス</strong>でないと受け付けてくれません。たとえば動的なURLで、実際はFLVファイルを返すようなパスであっても、内部でreturn falseとなり、再生を行うことができません。この問題は結構知られてあって、対処方法としては旧式のコンポーネントである<a href="http://livedocs.adobe.com/flash/8_jp/main/wwhelp/wwhimpl/common/html/wwhelp.htm?context=LiveDocs_Parts&file=00003770.html">MediaDisplay、またはMediaPlaybackコンポーネント</a>を利用する方法が知られています。</p>

<p>実際、このMediaDisplay、ないしMediaPlaybackを利用することで上記の問題は解決できるのですが、MediaPlaybackのコントローラのUIは（個人的に）やや微妙で、少し扱いづらい印象です。また、FLVPlaybackの方が、名前にFLVがついている通り、FLVファイルの再生に関してはかなり便利なメソッドやイベント検出などが多く用意されてあり、なんとかFLVPlaybackを利用したいかぎりです。</p>

<p>と、いうわけでFLVPlaybackの拡張子縛りは何とかならないのかな、、と思ってかなり調べている中でなんとか対応できました。以下、その手順メモです。</p>

<p><a href="http://www.echo-graphics.net/blog/archives/2006/11/flvplaybackflv.html">「BicRe : FLVPlaybackが「.flv」以外を使えない理由」</a>によると、まず、根本の原因はFLVPlaybackが内部でロードしているmx.video.NCManagerクラスの中のコードで、対象ファイルパスの検証で、ガチガチに「.flv」で終わっているかどうかのチェックを行っていることが原因です。これはWindowsであれば</p>

<p>
<pre>
C:\Program Files\Macromedia\Flash 8\ja\First Run\Classes\mx\video\
</pre>
</p>

<p>Macであれば</p>

<p>
<pre>
Macintosh HD:Applications:Macromedia Flash 8:First Run:Classes:mx:video:
</pre>
</p>

<p>の階層にある、NCManager.asを開くと確認できます。262行目あたりを見ると</p>

<p>
<pre>
if (parseResults.streamName.slice(-4).toLowerCase() == ".flv") {
  var canReuse:Boolean = canReuseOldConnection(parseResults);
  _isRTMP = false;
  _streamName = parseResults.streamName;
  return (canReuse || connectHTTP());
} else {
  _smilMgr = new SMILManager(this);
  return _smilMgr.connectXML(parseResults.streamName);
}
</pre>
</p>

<p>と、あるので、これを書き換えることにします。上記ページでもありますが、実際はこのコードを上書きしてしまうのではなく、自分が作ろうとしているhoge.flaの同一ディレクトリに「mx/video/」のディレクトリを作成し、その中に元のmx/video/*.asを全部コピーし、そこでNCManagerを書き換えると後々何らかの不具合があったときに安心だと思います。</p>

<p>コピーが終わると、NCManagerを次のように書き換えます。</p>

<p>
<pre>
var canReuse:Boolean = canReuseOldConnection(parseResults);
_isRTMP = false;
_streamName = parseResults.streamName;
return (canReuse || connectHTTP());
</pre>
</p>

<p>これで、asoファイルを削除してから再パブリッシュすると、.flv以外のファイルパスも受け付ける万能なFLVPlayerが作れます。</p>

<p>このNCManagerに関する情報は割りとすぐに見つかったのですが、実際にどこの階層で作業したらいいのか？という情報がなかなか見つからずに苦労しました。。。とは言え、解決できてよかったです。やれやれ。。</p>
