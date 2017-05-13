---
title: DVDデータをチャプタ毎にリッピング/wav変換するLionに対応したgem 'musical'
date: 2011/11/06
tags: ruby
published: true

---

	<p><strong>musical</strong>というgemを作りました。</p>
	<ul>
	  <li><a href="https://rubygems.org/gems/musical">musical</a></li>
	  <li><a href="https://github.com/katsuma/musical">github</a></li>
	</ul>

	<h3>これは何?</h3>
	<p>「<a href="http://blog.katsuma.tv/2009/01/dvd_to_mp3.html">Mac OSXでライブDVDをmp3ファイルに変換</a>」にも書いたのですが、僕はアーティストのライブDVDを買って思う存分鑑賞した後は、mp3/AACに変換してiTunes/iPhoneで聴くという楽しみ方をよくしています。
ところが、この変換の際に肝である<a href="http://www.macupdate.com/app/mac/9830/osex">0SEx</a>というソフトがMac OSX 10.7(Lion)になってから動かなくなりました。理由は明確で、0SExはPPC用にビルドされたバイナリなのでRosetta上では動作していたのですが、LionになってRosettaが取り除かれてしまったことで動作しなくなりました。Rosettaの代用品も存在せず、途方に暮れていたのですが、既存のソフトウェアの組み合わせでなんとかできることがわかったので、自分が使いやすい形にmusicalというgemの形でまとめてみました。</p>

	<p>musicalができることが単純で、</p>

	<p>
	  <ol>
		<li>チャプタごとのリッピング</li>
		<li>チャプタごとのwavファイルの変換</li>
		<li>(オプションとして)タイトル/チャプタ情報の出力</li>
	  </ol>
	</p>

	<p>だけです。個人的には2.のwavの変換を行ったあとに、iTunesにD&DでAACに変換を行っているので、ここまでの処理を行おうか迷ったのですが、利用する音声フォーマットは個々人に任せたほうがいいと思ったので、wav変換までで止めています。</p>

      <p>(2011.11.27 追記) <a href="http://blog.katsuma.tv/2011/11/itunes_by_rb_appscript.html">0.0.2でiTunesの設定に従ってエンコード、ライブラリ追加まで行えるようにしました</a></p>

	<h3>インストール</h3>
	<h4>必要ソフトウェアのインストール</h4>
	<p>musicalはバックエンドでdvdbackup, ffmpegを利用しているので、これらをインストールしておきます。homebrewでインストールできます(後述しますが、ちょっと罠があります)。</p>
	<p>
	  <pre>
brew install dvdbackup
brew install ffmpeg</pre>
	</p>

	<h4>gemのインストール</h4>
	<p>毎度おなじみの</p>
	<p>
	  <pre>
gem install musical</pre>
	</p>
	<p>で、OKです。</p>

	<h3>利用方法</h3>
	<p>一番シンプルなのは、DVDドライブにDVDを入れた状態で</p>
	<p>
	  <pre>
musical</pre>
	</p>
	<p>だけで、カレントディレクトリにチャプタ毎にwavファイルができあがります。</p>

	<h4>wavはいらない！リッピングだけでいいんだけど</h4>
	<p>
	  <pre>
musical --ignore-convert-sound</pre>
	</p>
	<p>で、リッピングだけ行い、wavへの変換は行いません。</p>

	<h4>保存する場所を変更したいんだけど</h4>
	<p>
	  <pre>
musical --output=save/to/path --title=DVD_title</pre>
	</p>
	<p>--output, --titleオプションを利用できます。オプションについては--helpでご確認ください。</p>
	
	<h4>musical --infoが何も表示されないんだけど</h4>
	<p>DVDにプロテクトがかかっているので、<a href="http://www.metakine.com/products/fairmount/">Fairmount</a>などを使って、ディスクイメージとしてマウントすれば大丈夫です。</p>

	<h3>ライブラリのインストール時の注意</h3>
	<h4>dvdbackup</h4>
	<p>brew installで簡単にいく。。と思いきや、依存パッケージのlibdvdreadのインストールでコケました。これは単純にURLが変更になっていたので、</p>
	<p>
	  <pre>
brew edit libdvdread</pre>
	</p>
	<p>して、</p>
	<p>
	  <pre>
@@ -3,7 +3,7 @@ require 'formula'
 class Libdvdread < Formula
   homepage 'http://www.dtek.chalmers.se/groups/dvd/'
   # Official site is down; use a mirror.
-  url 'http://www.mplayerhq.hu/MPlayer/releases/dvdnav/libdvdread-4.1.3.tar.bz2'
+  url 'http://www.mplayerhq.hu/MPlayer/releases/dvdnav-old/libdvdread-4.1.3.tar.bz2'
   md5 '6dc068d442c85a3cdd5ad3da75f6c6e8'
   depends_on 'libdvdcss' => :optional</pre>
	</p>
	<p>こんなかんじで編集した後、brew install libdvdreadしなおしたら大丈夫です。</p>
	<p>ちなみに<a href="https://github.com/katsuma/homebrew/commit/09a0b8ca14239109c4aedf23d0a1e95aabdc7835">この内容</a>は(人生初の)<a href="https://github.com/mxcl/homebrew/pull/8468">pull request</a>を送ってみたので、もしかしたら今後は取り込まれるかもしれませんね。</p>

<p>(2011.11.11追記) pull requestは取り込まれたので、brew updateしたらformulaを編集しなくてもインストールできると思います。</p>

	<h4>ffmpeg</h4>
	<p>これもbrew installで簡単にいく。。と思いきや、最新のXcodeでgccが無くなった + pod2manの実行権限がなぜか無くなっていたことでかなりハマりました。あらかじめgccをインストールしなおした上で、こんなかんじでインストール可能です。</p>
	<ul>
	  <li>
		<p><a href="https://github.com/kennethreitz/osx-gcc-installer">osx-gcc-installer</a></p>
	  </li>
	</ul>

	<p>
	  <pre>
# 関連するものを含めて、一度アンインストール
brew uninstall --force `brew deps ffmpeg`

# なぜか実行権限無くなっていたので再設定
sudo chmod +x /usr/bin/pod2man

# gccの利用を指定
brew install --use-gcc ffmpeg</pre>
	</p>

	<p>基本的にこれでいけるはずなんですけど、依存関係上一緒にインストールされるlibxvid, libmp3lameあたりでコケた場合(実際、別のLionのマシンで試したらコケた)は、最悪これらのインストールをスキップしても大丈夫です。brew edit ffmpegで</p>

	<p><pre>
depends_on 'yasm' => :build
...
#depends_on 'lame' => :optional
...
#depends_on 'xvid' => :optional

...
#args << "--enable-libmp3lame" if Formula.factory('lame').installed?
...
#args << "--enable-libxvid" if Formula.factory('xvid').installed?</pre></p>

	<p>こんなかんじでコメントアウトたらビルドも通り、動作が確認できました。</p>

	<h3>最後に</h3>
	<p>当然ながら、本gemは著作権違反の手助けをするためのものではありません。自身の責任の元、ご利用ください。</p>


