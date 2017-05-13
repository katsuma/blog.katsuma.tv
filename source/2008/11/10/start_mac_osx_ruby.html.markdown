---
title: Mac OSXで初めてのRubyを始めてみました
date: 2008/11/10
tags: ruby
published: true

---

<p>Rubyの勉強を始めてみたくなったので、O'REILLYの「<a href="http://www.amazon.co.jp/gp/product/4873113679?ie=UTF8&tag=katsumatv-22&linkCode=as2&camp=247&creative=7399&creativeASIN=4873113679">初めてのRuby</a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&l=as2&o=9&a=4873113679" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />」
を購入してみました。MacPortsで最新版のRubyを導入しつつ、１章から読み進めているのですが、早速ハマったところがあるのでそのメモを残しておきたいと思います。</p>

<h3>Ruby1.9の導入</h3>
<p>MacPortsでruby19の名前でインストールできます。</p>
<p><pre>
sudo port -d install ruby19
</pre></p>

<p>/usr/bin/ruby には、元からインストールされているrubyが入っているので、これをMacPortsでインストールしたものと入れ替えます。（シンボリックリンク張り替えちゃったけどこれでいいのかな？ruby_selectみたいのないのかな）</p>

<p><pre>
cd /usr/bin
sudo mv ruby ruby.org
sudo ln -s /opt/local/bin/ruby1.9 ruby
</pre></p>

<p>
<pre>
ruby --version
</pre>
</p>

<p>と、入力して</p>

<p>
<pre>
ruby 1.9.1 (2008-10-28 revision 19983) [i386-darwin9]
</pre>
</p>

<p>こんなかんじの出力になればOKだと思います。</p>

<h3>日本語(マルチバイト)の利用</h3>
<p>1.5.4制御式のあたりについて。通常だとマルチバイト文字の利用でエラーがでちゃいます。たとえば</p>

<p><pre>
p "こんにちわ！こんにちわ！＞＜"
</pre></p>

<p>で、</p>
<p><pre>
odd.rb:8: invalid multibyte char (US-ASCII)
odd.rb:8: syntax error, unexpected $end, expecting keyword_end
</pre></p>

<p>などとエラー文が出力されてしまいます。
これは、次のように冒頭に利用するエンコード方式をコメントで書けばOK</p>

<p><pre>
#!/usr/bin/ruby
</pre></p>

<p>を</p>

<p><pre>
#!/usr/bin/ruby
# coding: UTF-8
</pre></p>

<p>に変更すればOK。</p>

<h3>tkパッケージの利用</h3>
<p>1.5.5のコールバックのあたりの話。実は冒頭のインストール方法だとtkパッケージがインストールされていないため、利用できません。(require文でコケる)　なので、tkパッケージを有効にして入れ直します。variantsオプションで有効なインストールオプションを確認します。</p>

<p><pre>
$ port variants ruby19
ruby19 has the variants:
        universal
        c_api_docs: Generate documentation for Ruby C API
        tk: Build using MacPorts Tk
        mactk: Build using MacOS X Tk Framework
</pre></p>
<p>tk, mactkと似たようなものが２つあります。これ両方有効にしてインストールするとコケちゃいます。とりあえずmactkの方を有効にしてインストールしなおし。</p>

<p>
<pre>sudo port install ruby19 +c_api_docs +mactk</pre>
</p>

<p>ところがこれだとエラーでコケます。</p>

<p>Error: The following dependencies failed to build: doxygen graphviz pango urw-fonts</p>

<p>いろいろビルドに失敗しているみたいなので全部個別にインストール。</p>

<p>
<pre>
sudo port install urw-fonts
sudo port install pango
sudo port install graphviz
sudo port install doxygen
</pre>
</p>

<p>この上で、もう一度インストールしなおし。</p>

<p><pre>sudo port install ruby19 +c_api_docs +mactk</pre></p>

<p>これで次のrequire文でコケません。</p>

<p><pre>require "tk"</pre></p>

<h3>まとめ</h3>
<p>ちょっとづつRubyもわかってきました。これから毎日１章づつくらいのペースで進めていきたいとおもいますよ！</p>

<p>
<iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=katsumatv-22&o=9&p=8&l=as1&asins=4873113679&md=1X69VDGQCMF7Z30FM082&fc1=000000&IS2=1&lt1=_blank&m=amazon&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</p>


