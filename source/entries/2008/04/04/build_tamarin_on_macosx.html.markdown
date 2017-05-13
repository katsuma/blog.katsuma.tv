---
title: MacOSXでTamarinをビルド
date: 2008/04/04
tags: javascript
published: true

---

<p>なんとなく思いつきでTamarinをビルドしたくなったので挑戦してみると思いのほかすんなりできたのでそのメモです。ちなみにMacOSX(Leopard)でビルドしました。基本的には<a href="http://developer.mozilla.org/ja/docs/Tamarin_Build_Documentation">MDCのドキュメント</a>の通りなのですが、途中で少し迷った点もあったので、そのあたりも含めて備忘録として残しておきます。</p>

<h3>そもそもの環境</h3>
<p><a href="http://www.macports.org/">MacPorts</a>をインストールしておく必要があります。<a href="https://connect.apple.com/cgi-bin/WebObjects/MemberSite.woa/wa/getSoftware?bundleID=19897">XCode3.0</a>が入っていれば、pkgからすんなりインストールできるかと思います。</p>

<p>MacPortsが入ったらlibIDLをインストールしておきます。</p>
<p><pre>
sudo port sync
sudo port install libidl
</pre></p>

<p>また、autoconf213をインストールします。</p>
<p><pre>
sudo port install autoconf213
</pre></p>



<h3>ソースの入手</h3>
<p>ソースを入手するためにはhgというコマンドが必要なのですが、これはMercurialがインストールされてある必要があります。ちなみにMercurialとはクロスプラットフォームの分散型バージョン管理システムだそうです。ここで初めて知りました。ほほぅ。</p>

<p>Mercurialは<a href="http://mercurial.berkwood.com/">バイナリが用意されてある</a>ので、そこからインストールするのが簡単です。ここからOSX用の<a href="http://mercurial.berkwood.com/binaries/Mercurial-1.0-py2.5-macosx10.5.zip">Mercurial 1.0</a>をDL、解凍して、インストーラを実行します。インストールが終わると、ターミナルで「hg」というコマンドが実行できるようになり、ソースコードを入手することができます。
</p>

<p>ソースは次のコマンドで入手することができます。</p>

<p><pre>
hg clone http://hg.mozilla.org/tamarin-central
</pre></p>

<p>そうすると、ソースコードがカレントディレクトリにDLされます。</p>

<h3>ビルド</h3>
<p>次のコマンドでビルドできます。</p>
<p><pre>
cd tamarin-central
xcodebuild -project platform/mac/shell/shell.xcodeproj
</pre></p>

<p>しばらく待つと、tamarin-central/platform/mac/shell/build/Releaseに「shell」の名前でビルドできています。</p>

<p><pre>
./shell
avmplus shell 1.0 build cyclone

usage: avmplus
          [-Dinterp]    do not generate machine code, interpret instead
          [-Dforcemir]  use MIR always, never interp
          [-Dnodce]     disable DCE optimization 
          [-Dnocse]     disable CSE optimization 
          [-Dnosse]     use FPU stack instead of SSE2 instructions
          [-Dtimeout]   enforce maximum 15 seconds execution
          [-error]      crash opens debug dialog, instead of dumping
          [-log]
          [-- args]     args passed to AS3 program
          [-jargs ... ;] args passed to Java runtime
          filename.abc ...
          [--] application args
</pre></p>

<p>static linkされてるっぽいので、適当な名前にコピーしてどこかに移動してあげると良いでしょう。僕は/opt/local/sbin/avmplus とかに置きました。</p>

<p>で、とりあえずビルド確認したとことまで。こいつでECMAScriptやGCについてちょこちょこ勉強できそうです。</p>


