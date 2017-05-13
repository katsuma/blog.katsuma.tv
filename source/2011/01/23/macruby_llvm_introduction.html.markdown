---
title: MacRubyとLLVMを導入してRubyでネイティブGUIアプリを作る
date: 2011/01/23
tags: ruby
published: true

---

<p>(2011/1/23 23:00追記) macrubycはLLVMから入れなくてもmacrubyをインストールするだけで一緒にインストールされます。下記内容は誤りを含んでいますのでご注意ください。ご指摘いただいた<a href="http://twitter.com/#!/watson1978">watson1978</a>さん、ありがとうございました。
</p>

 <p>最近Macアプリケーションが気になっていて、Cocoa周りの話を調べています。その一環でRubyでMacアプリを作る方法についての話です。</p>

<h3>MacRuby</h3>
 <p>Mac上でRubyでアプリケーションを作る場合、最初からインストールされてあるRubyCocoaと、最近盛り上がっているMacRubyの２通りの手段があります。
どちらもCocoaを含むいろんなフレームワークをRubyから直接叩けるのですが、RubyCocoaはプロキシオブジェクトを介してCocoaフレームワークを叩くのに対して、MacRubyはプロキシを必要とせずに直接Objective-Cのメソッドにアクセスできるのが大きな特徴です。
実装方法として、MacRubyはRubyランタイムからObjective-Cのランタイム関数を直接呼び出すことで実現しているようです。
感覚的に考えてもRubyCocoaと比べて、MacRubyの方がパフォーマンスが大きく改善されていることが期待できるので、MacRubyで遊んでみたいと思います。</p>

<h3>rvmの利用</h3>
<p><a href="http://www.macruby.org/">MacRuby</a>の本家サイトにはインストーラのpackageファイルがあるのですが、もっと手軽に試してみるにはrvmの利用がおすすめです。rvmは複数のRubyを共存させるツールで、いろんなバージョンのRubyを切り替えて使いたいときは必須ツールです。
同僚の<a href="http://twitter.com/#!/mirakui">mirakui</a>さんが詳しい記事を書いているので、rvm自身のインストールなど詳細な情報はそちらを参照ください。</p>


<p><ul>
<li><a href="http://d.hatena.ne.jp/mirakui/20100502/1272849327">rvm: 複数のRubyを共存させる最新のやり方</a></li>
</il></ul></p>

<p>ではMacRubyをrvmでインストールしてみます。MacRubyの最新バージョンは2011年1月22日現在で0.8なのですが、rvmのバージョンを最新にしないとバージョン指定でインストールできないようです。</p>

<p><pre>
$ rvm update --head
$ rvm reload
$ rvm install macruby-0.8
$ rvm use macruby-0.8
</pre></p>

<p>バージョンを確認してみて、次のような出力が得られるとインストール成功です。</p>

<p><pre>
$ ruby -v
MacRuby 0.8 (ruby 1.9.2) [universal-darwin10.0, x86_64]
</pre></p>

<p>あとGUI系のライブラリを利用するためにHotCocoaのgemもインストールしておきます。</p>
<p><pre>
$ gem install hotcocoa
</pre></p>

<h3>Hello World!</h3>
<p>まずは簡単なHello Worldアプリをつくってみます。「ruby hello_world.rb で」ウィンドウ上にボタンを表示し、ボタンクリックでHello Worldをputsさせます。</p>

<p>
<a href="http://www.flickr.com/photos/katsuma/5380359654/" title="1st MacRuby App by katsuma, on Flickr"><img src="http://farm6.static.flickr.com/5284/5380359654_a1072a4d9e_o.png" width="206" height="227" alt="1st MacRuby App" /></a>
</p>
<p>
<script src="https://gist.github.com/791905.js?file=hello_world.rb"></script>
</p>

<p>MacRubyはKernelモジュールにframeworkメソッドを追加しているので、このメソッドでCocoa機能を呼び出します。
あとのコードも大体読めばわかる程度のレベルだとおもいます。Objective-Cだと抵抗あるRubyエンジニアもこれだとMacアプリも怖くないですね！</p>

<h3>MacRubyコンパイラを利用してネイティブアプリ化する</h3>
<p>このままだとただのRubyスクリプトなので、これをネイティブアプリ化します。
(2011/1/23 23:00追記、macrubycはmacrubyに梱包されているので、LLVMからインストールする必要はありません。一応、備忘録のために導入方法だけ残しておきます。)<del>
ネイティブアプリ化を行うためには、LLVMが提供するツールのmacrubycを利用します。macrubycはMacRubyをインストールするだけだと使えないので、LLVMのビルド、インストールが必要です。</del></p>

<p>LLVMはバージョンに依存するようで、僕の場合は<a href="http://rvm.beginrescueend.com/interpreters/macruby/">rvmのサイトの内容</a>を参考にして、次の手順で導入できました。</p>

<p><pre>
$ svn co -r 106781 https://llvm.org/svn/llvm-project/llvm/trunk llvm-trunk
$ cd llvm-trunk
$ env UNIVERSAL=1 UNIVERSAL_ARCH="i386 x86_64" CC=/usr/bin/gcc CXX=/usr/bin/g++ ./configure --enable-bindings=none --enable-optimized --with-llvmgccdir=/tmp
$ env UNIVERSAL=1 UNIVERSAL_ARCH="i386 x86_64" CC=/usr/bin/gcc CXX=/usr/bin/g++ make -j2
$ sudo env UNIVERSAL=1 UNIVERSAL_ARCH="i386 x86_64" CC=/usr/bin/gcc CXX=/usr/bin/g++ make install
</pre></p>

<p>makeのときに追加しているj2オプションの「2」の値はビルドを行うCPUのコア数に合わせて最適化を行ってみてください。なお、このビルドは1時間近くかかるので、時間があるときに試すのをおすすめします。</p>

<p><pre>
$ which macrubyc
/usr/local/bin/macrubyc
</pre></p>

<p>のようにエラーがなく結果が返ってくればインストール成功です。</p>


<p>では、早速先ほどつくったhello_world.rbをコンパイルしてみましょう。コンパイルは簡単で次のコマンドでコンパイルできます。</p>

<p><pre>
$ macrubyc hello_world.rb -o hello_world
</pre></p>

<p>これでhello_worldという名前の実行可能ファイルができるので、</p>

<p><pre>
$ ./hello_world
</pre></p>

<p>で、実行できます。無事、ウィンドウが表示されましたね！</p>

<h3>まとめ</h3>
<p>rvmでMacRubyは簡単に導入することができるので、Objective-Cを諦めていて人もRubyで手軽にMacアプリの作成を試すことが確認できました。
また、LLVMを導入することでネイティブアプリも作成することができるので、RubyでのMacアプリケーション開発の可能性の大きさも伺えますね！</p>



