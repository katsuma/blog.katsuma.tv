---
title: さくらインターネットでrvm+Ruby1.9.3環境下でSinatraをCGIで動かす
date: 2012/02/26
tags: ruby
published: true

---

    <p>
      このご時世、<a href="http://vps.sakura.ad.jp/">VPS</a>でも<a href="http://cloud.sakura.ad.jp/">クラウド</a>でもなく、さくらインターネットの<a href="http://www.sakura.ne.jp/">レンタルサーバ</a>でCGIを動かす必要があったので、その備忘録。KENT-WEBみたいなかんじのPerlでもよかったのですが、せっかくなのでモダンな環境を用意してSinatraで動かしてみました。</p>

    <h2>rvm+Ruby1.9.3のインストール</h2>
    <p>
      さくらでRubyをインストールするときは、googleで調べるかぎりソースからコンパイルして導入しているケースが多いのですが、面倒くさいだけなのでrvmを利用します。特に変わった設定は不要で、いつも通りの感じでインストールできます。
    </p>
    <p>
      <pre>
bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)</pre>
    </p>
    <p>で、rvmのインストール完了。パスの設定なんかが書かれた$HOME/.profileが作成されているので、</p>
    <p>
      <pre>
source ~/.profile</pre>
    </p>
    <p>しておきます。</p>
    <p>また、rubyは1.9.3の最新版をインストールしました。</p>
    <p>
      <pre>
rvm install ruby-1.9.3
# default設定
rvm alias create default ruby-1.9.3</pre>
    </p>

    <p>rvm listの結果がこんなかんじになっていたらインストール成功です。</p>

    <p>
      <pre>
$ rvm list

rvm rubies

=* ruby-1.9.3-p125 [ i386 ]

# => - current
# =* - current && default
#  * - default</pre>
                 </p>

    <h2>sinatraの導入</h2>
    <p>特に何も気にせず最新版を導入します。</p>
    <p>
      <pre>
gem install sinatra </pre>
    </p>
<p>ちなみにインストールしたgemのバージョンはこんな感じです。</p>
<p><pre>
$ gem list

*** LOCAL GEMS ***

bundler (1.0.22)
rack (1.4.1)
rack-protection (1.2.0)
rake (0.9.2)
sinatra (1.3.2)
tilt (1.3.3)
</pre></p>

    <p>さて、さくらインターネットの設定で、CGIを動かすファイルの拡張子は.cgiである必要があるので、sinatraのスクリプトも*.cgiの名前で作成します。rubyのパスはrvmでインストールされたrubyのパスを設定する必要があるので、以下のような内容になります。</p>
    <p><pre>
#!/home/katsumatv/.rvm/rubies/ruby-1.9.3-p125/bin/ruby
ENV['GEM_HOME'] = '/home/katsumatv/.rvm/gems/ruby-1.9.3-p125'
require 'rubygems'
require 'sinatra'

get '/' do
  'Hello, World!!'
end

get '/foo' do
  'foo!'
end

set :run => false
Rack::Handler::CGI.run Sinatra::Application
</pre></p>

    <p>ポイントは2つ。1つめは、GEM_HOMEのパスを明示的に指定してあげることです。これ、外から指定する方法がよくわからなかった上に、指定しないと動作しなかったので、シンプルにできる方法わかる方は教えていただきたいです。2つ目のポイントは最後の2行で、CGIで動作させる場合の設定として必要なことです。このへんの情報、Sinatraのドキュメント見てもよくわからなかったので、結構ハマりました。。</p>

    <h2>.htaccessの設置</h2>

    <p>さて、この状態で、start.cgiのパーミッションを755にすると、http://foo.com/start.cgiにアクセスすると「Hello, World!!」が表示されます。一方で、/fooにアクセスするためには「/start.cgi/foo」なURLでアクセスする必要があります。これはちょっとダサいので、mod_rewriteでいじることにします。httpd.confは編集できないので、.htaccessで次のような設定を記述します。</p>

    <p><pre>
DirectoryIndex start.cgi

RewriteEngine    on
RewriteBase      /
RewriteCond      %{REQUEST_FILENAME} !-d
RewriteCond      %{REQUEST_FILENAME} !-f
RewriteRule      ^(.*)$ start.cgi/$1 [QSA,L]
</pre></p>

    <p>これで、/fooにアクセスすると「foo!」と表示され、いつものSinatraな動作が可能になります。</p>

    <h2>まとめ</h2>
    <p>rvmを使うことで最新のRuby+Sinatra環境でcgiを動作させることができました。次はこの環境で、もう一歩踏み込んだ遊びをしてみたいと思います。</p>


