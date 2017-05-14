---
title: Ruby2.0 + Rails4 なアプリを作成する
date: 2013/01/01 02:33:41
tags: ruby
published: true

---

明けましておめでとうございます。
年も明けたことだし、意識高めにRuby2.0+Rails4な（スケルトンの）アプリを作成しました。

- [roomkeepr](https://github.com/katsuma/roomkeepr)

我が家は[iRemoconを使って家電を管理している](http://blog.katsuma.tv/2012/06/pop-zap.html)のですが、テンプレートを変更するのがあまりに面倒なので全部Webベースにしちゃえばいいや、と思ってせっかくなので最新のエッジな環境で作ってみよう！とおもった次第です。実際、Sinatraで十分なんだけど。。

微妙にハマる個所もありましたが、rspecでテストが動くところまで確認できました。
以下、そこまでのメモです。

### Ruby2.0
RVMでpreview2版がインストールできます。
まずは、ビルドツールを最新にしておきます。Homebrewを利用している場合はこんなかんじ。
<pre>
brew update
brew tap homebrew/dupes
brew install autoconf automake apple-gcc42
</pre>

その後、RVMの情報を最新にしてopensslをRVMのパッケージでインストールしておきます。
また、Ruby2.0のインストール時にはARCHFLAGSをセットしておかないとmakeで失敗しました（すごいハマった）

<pre>
rvm get head
rvm reload
rvm pkg install openssl
env ARCHFLAGS="-arch x86_64" rvm install ruby-2.0.0-preview2 
rvm use ruby-2.0.0-preview2 --default
</pre>

すると、
<pre>
$ ruby -v
ruby 2.0.0dev (2012-12-01 trunk 38126) [x86_64-darwin11.4.2]
</pre>
と、なってRuby2.0が利用できていることが確認できます。

また、すぐに必要になるのでbundlerだけでもインストールしておきます。
<pre>
gem install bundler
</pre>

### Rails4
Rails4はgem化されていないので、ひとまずコード一式を手元に持ってきます。
<pre>
git clone git@github.com:rails/rails.git
</pre>
落としてきたコードを元にアプリを作成します。
<pre>
rails/railties/bin/rails new roomkeepr --skip-index-html
</pre>

Gemfileを書き換えてbundle installします。最低限こんなセットでいけるかと。
<pre>
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.beta', github: 'rails/rails'

gem 'activeresource', git: 'git://github.com/rails/activeresource', require: 'active_resource'
gem 'activerecord-deprecated_finders', git: 'git://github.com/rails/activerecord-deprecated_finders.git'
gem 'journey',   :git => 'git://github.com/rails/journey.git'
gem 'arel',      :git => 'git://github.com/rails/arel.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sprockets-rails', '~> 2.0.0.rc1', github: 'rails/sprockets-rails'
  gem 'sass-rails',   '~> 4.0.0.beta', github: 'rails/sass-rails'
  gem 'coffee-rails', '~> 4.0.0.beta', github: 'rails/coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'sqlite3'
gem 'jquery-rails'
gem 'haml-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'response_code_matchers'
end

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
</pre>

もしかすると、ここで依存関係の問題でbundle installに失敗するかもしれません。そのときは次のものを事前にインストールしておくと良さそうです。（この辺り試行錯誤しててメモが怪しい。。）
<pre>
gem install thread_safe
gem install i18n
gem install thor
</pre>

### うまくいかなかった点
rspecの導入と合わせて、GuardとSporkも導入しようとしたのですが動作しませんでした。
具体的にはrb-fseventがファイル保存時にエラーをはいてうまくいかず。このへんはRuby2.0固有の深そうな話に思えたので、途中で断念。このあたりは後で掘ってみようと思います。

### 雑感
実際はRuby2.0固有のコードも無いし、Rails4っぽいこともbefore\_filterじゃなくてbefore\_actionを利用したくらいではありますが、思ったよりサクサク軽量に動いてる感じもあり、個人の開発は（Guard動かない問題が解決してないけど）もうこのエッジな環境でもさほど問題は無さそうです。

少なくともRails4はgem化されていないので導入こそ若干面倒なものの面白機能も増えいてるので、エッジなRailsを触ってみたい人は2013年スタートダッシュをキめて使い始めてみるといいと思います。

ちなみにRails3からのアップグレードを含めたoverviewを勉強するには[Upgrading to Rails4](http://www.upgradingtorails4.com/)のドキュメントが良かったです。$15の有料ではありますが、コンパクトにまとまってる、かつめちゃめちゃ実用的な内容なので、エッジ野郎にはオススメのドキュメントです。


