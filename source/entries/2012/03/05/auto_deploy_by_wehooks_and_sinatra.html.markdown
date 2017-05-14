---
title: githubにPushしたらwebhooksとSinatraを利用してサイトを自動的に更新する
date: 2012/03/05 02:28:18
tags: ruby
published: true

---

    <p>
      githubにはwebhooks機能があり、これを利用することで、git pushすると同時に様々な処理を実行することができます。たとえば、サイトをgithubで丸ごと管理している場合、pushと同時にサイトを更新することも可能です。</p>

<p>僕は趣味のとんかつサイト<a href="http://ton.katsuma.tv/">TON.KATSUma.tv</a>を遊びで作っていますが、このサイトは今はgithubで管理して、手元でgit pushするとサイトが更新される仕組みにしています。id:viverさんが<a href="http://d.hatena.ne.jp/viver/20110402/p1">素晴らしい記事</a>を書いて下さっていますが、今回はその復習的備忘録です。
    </p>

    <h2>Post-Receive URLs</h2>
    <p>webhooks機能を利用するためには、githubから送信されるHTTP POST命令の処理するWebサーバが必要になります。
      僕は<a href="http://blog.katsuma.tv/2012/02/sinatra_on_sakura.html">前回</a>紹介したようなSinatraでwebhooksのPOST命令だけを受け付けるCGIを動かす<a href="http://hook.katsuma.tv/">hook.katsuma.tv</a>の環境をさくらインターネット上に用意して、こいつで更新作業を行なっています。</p>

<p>セキュリティ無視して必要部分だけ抜粋すると、こんなかんじのスクリプトをSinatraで動かして更新しています。指定されたアプリケーションをgit pullしてrsyncさせてるだけ。もろもろ必要な情報は変数payloadにデータが載ってくるので、それを処理するようにしておきます。</p>

    <p><pre>
#!/home/katsumatv/.rvm/rubies/ruby-1.9.3-p125/bin/ruby
ENV['GEM_HOME'] = '/home/katsumatv/.rvm/gems/ruby-1.9.3-p125'
ENV['PATH'] = "#{ENV['PATH']}:/home/katsumatv/.rvm/gems/ruby-1.9.3-p125/bin:/home/katsumatv/bin"

require 'rubygems'
require 'sinatra'
require 'json'

post '/deploy' do
  user = 'user_name'
  server = 'host_name'
  workspace = "/path/to/cache"
  target_dir = "/path/to/www/"

  payload = params[:payload] ? JSON.parse(params[:payload]) : nil
  status 403 && return if payload.nil?

  app = payload["repository"]["name"]

  `cd #{workspace}/#{app} && git pull origin master`
  `rsync -avz #{workspace}/#{app}/public/ #{user}@#{server}:#{target_dir}`
  "done"
end

set :run => false
Rack::Handler::CGI.run Sinatra::Application
      </pre></p>

    <p>これで、http://hook.katsuma.tv/deploy で、POST命令を受け付ける準備ができたので、githubのPost-Receive URLsの設定を行います。</p>

<p>
      「アプリケーションのレポジトリ」＞「Admin」＞「Service Hooks」＞「Post-Receive URLs」を辿るとURL設定フォームが表示されるので、上記URLを指定しておきます。</p>
<p>      ちなみに、ここで「Tesh Hook」ボタンを押すと、実際にgit pushしたときと同じ情報がPost-Receive URLに発行されるので、開発時はこのボタンを利用すれば便利です。（最初これに気づかずに何度も空Pushしまくってました...）</p>

    <p>今回はrsyncするだけの簡単な更新処理でしたが、Capistranoを利用してもう少し細かなデプロイ作業をしたり、デプロイだけじゃなくてCIの実行、メール送信、tweet。。など、
      Hookから遊べそうなことは多いので、これを機にいろいろ試してみてはいかがでしょうか。</p>

    <h3>参考</h3>
    <p>
      <ul>
        <li>
          <a href="http://d.hatena.ne.jp/viver/20110402/p1">Webサイトをgithubで管理してpush時に自動的に同期する方法</a>
        </li>
      </ul>
    </p>


