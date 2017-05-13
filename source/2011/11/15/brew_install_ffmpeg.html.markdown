---
title: 'Homebrewでffmpegインストール時の"ERROR: libmp3lame >= 3.98.3 not found"を回避'
date: 2011/11/15
tags: osx
published: true

---

	<p><a href="http://blog.katsuma.tv/2011/11/gem_musical.html">前のエントリ</a>で「libmp3lameあたりでコケる」と言ったのですが、そのときの対応方法のメモ。</p>

	<h3>ERROR: libmp3lame &gt;= 3.98.3 not found</h3>
	<p>brew install ffmpegしたときのエラーはlibmp3lameが3.98.3以上のものが見つからないというエラーでした。ところが、</p>
	<p><pre>
$ lame --version  
LAME 64bits version 3.99.1 (http://lame.sf.net)

Copyright (c) 1999-2011 by The LAME Project
Copyright (c) 1999,2000,2001 by Mark Taylor
Copyright (c) 1998 by Michael Cheng
Copyright (c) 1995,1996,1997 by Michael Hipp: mpglib

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
License as published by the Free Software Foundation; either
version 2 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Library General Public License for more details.

You should have received a copy of the GNU Library General Public
License along with this program. If not, see
&lt;http://www.gnu.org/licenses/&gt;.</pre></p>

	<p>と、なっているので、lame本体は3.99.1の最新のものがインストールされているようです。要はこいつが認識されていないよう。</p>
	<p>最初は、(他の)ライブラリのインストールが失敗していて、正しく認識されないことを疑ったのですが、どうもそうではなさそう。</p>

	<h3>そもそもどのバージョンとして認識されているのか</h3>
	<p>インストールされていないことは無さそうなので、一体どのバージョンがインストールされていると見なされているんだろう、、途方に暮れつつも共有ライブラリのバージョンの確認方法がそもそもよくわかりません。。。とりあえず、libmp3lameのインストールされている場所を確認してみます。</p>

	<p><pre>
$ locate libmp3lame
/usr/lib/libmp3lame.dylib
/usr/local/Cellar/lame/3.99.1/lib/libmp3lame.0.dylib
/usr/local/Cellar/lame/3.99.1/lib/libmp3lame.a
/usr/local/Cellar/lame/3.99.1/lib/libmp3lame.dylib
/usr/local/lib/libmp3lame.0.dylib
/usr/local/lib/libmp3lame.a
/usr/local/lib/libmp3lame.dylib</pre></p>
	
	<p>なんかいっぱい出てきました。下の/usr/local/lib以下のものは、実際はそれぞれ/usr/local/Cellar/lame/3.99.1/以下のシンボリックリンクになっているようですが、一番上のものが何やら疑わしいです。普通、バージョン情報なんかは文字列として埋め込まれている可能性が高いので、stringsで覗いてみると</p>

	<p><pre>
$ strings /usr/lib/libmp3lame.dylib | less
l3_side->main_data_begin: %i
, 3DNow!
Warning: many decoders cannot handle free format bitrates >320 kbps (see documentation)
xr^3/4
3.97
LAME3.97
http://www.mp3dev.org/
32bits
mpg123: Bogus region length (%d)
mpg123: Can't rewind stream by %d bits!
333333?
...</pre></p>
	<p>むむむ。LAME3.97とすごい怪しいバージョン番号ぽいものが見えます。。。! では、他のファイルはどうなのかと思い、/usr/local/lib以下のものを調べてみると</p>

	<p><pre>
$ strings /usr/local/libmp3lame.dylib | less
Error: can't allocate VbrFrames buffer
strange error flushing buffer ... 
Error: MAX_HEADER_BUF too small in bitstream.c 
Internal buffer inconsistency. flushbits <> ResvSize
bit reservoir error: 
...
This is a fatal error.  It has several possible causes:
90%%  LAME compiled with buggy version of gcc using advanced optimizations
 9%%  Your system is overclocked
 1%%  bug in LAME encoding library
LAME %s version %s (%s)
LAME version %s (%s)
...
INTERNAL ERROR IN VBR NEW CODE (986), please send bug report
INTERNAL ERROR IN VBR NEW CODE (1313), please send bug report
maxbits=%d usedbits=%d
3.99.1
L3.99r
http://lame.sf.net
...</pre></p>

	<p>おおお、やはりlameのバージョンである3.99.1という文字列が確認できます。やはりこの/usr/local/lib以下のものよりも優先して/usr/lib以下の低いバージョンの共有ライブラリが参照されているようです。試しに、この低い方のものを削除して、brew install ffmpegしなおしてみると</p>

	<p><pre>
$ brew install --use-gcc ffmpeg
==> Downloading http://ffmpeg.org/releases/ffmpeg-0.8.6.tar.bz2
File already downloaded in /Users/katsuma/Library/Caches/Homebrew
==> ./configure --prefix=/usr/local/Cellar/ffmpeg/0.8.6 --enable-shared --enable-gpl --enable-version3 --enable-nonfree --enable-hardcoded-tables --cc=
==> make install
/usr/local/Cellar/ffmpeg/0.8.6: 97 files, 55M, built in 5.7 minutes</pre></p>

	<p>ビンゴ！やはり低いバージョンのものが邪魔をしていたようです。。。！どういう経路でこの古いバージョンのlibmp3lameが入ってきたのか謎ですが、何かのアプリケーションをインストールしたときに一緒に入って、アプリケーションのアンインストール時に削除されないまま残ったのかもしれません(謎)</p>

	<h3>まとめ</h3>
	<p>ライブラリのバージョン依存でインストールに困ったときは、とりあえず</p>
	<p><ul>
		<li>locateで該当対象のファイルパスのリストを洗い出し</li>
		<li>stringsでバージョン確認</li>
	</ul></p>
	<p>な感じでしょうか。ただ、このstringsで確認するあたりが正当法じゃない感じがする。。のですが、もっといいバージョン確認方法があればぜひ教えていただきたいです。</p>


