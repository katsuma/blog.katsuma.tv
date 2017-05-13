---
title: SiriProxyのプラグインとしてSiriで家電を操作するSiriProxy-iRemocon
date: 2013/01/05
tags: ruby
published: true

---

### SiriProxy-iRemoconって何？

- [SiriProxy-iRemocon](https://github.com/katsuma/SiriProxy-iRemocon)

SiriProxyのプラグインの形で、Siriで家電を操作できるものを作りました。<del>今のところ電気のON/OFFだけですが、</del>こんな感じで

- ライトを付けて
- ライトを消して

とSiriに言う事で、部屋の電気を操作できます。

<iframe width="560" height="315" src="http://www.youtube.com/embed/K_0VNat-m8Q" frameborder="0" allowfullscreen></iframe>

(2013.01.14追記)　エアコンのON/OFFの様子も追加しました。
<iframe width="560" height="315" src="http://www.youtube.com/embed/9zpSUcJMcqg" frameborder="0" allowfullscreen></iframe>

### 部屋の電気の操作ってどうやってるの？？
このブログでは定番になってきましたが、やはり[iRemocon](http://www.amazon.co.jp/gp/product/B0053BXBVG/ref=as_li_ss_il?ie=UTF8&tag=katsumatv-22&linkCode=as2&camp=247&creative=7399&creativeASIN=B0053BXBVG)を利用しています。詳しくはこちらをどうぞ。

- [ネット上で話題になっている番組に自動的にTVのチャンネルを変えるpop-zap](http://blog.katsuma.tv/2012/06/pop-zap.html)


### SiriProxyって何？
[SiriProxy](https://github.com/plamoni/SiriProxy)はその名のごとくSiriのProxyサーバで、プラグイン形式で質問文に対して独自の処理を追加することができるものです。Readmeがしっかり書かれているとは言え、日本語のまともな導入事例の記事が無い+公式のReadmeが手順が間違ってる箇所があったのですこし手まどりましが、こんな感じで導入できます。

#### Ruby1.9.3の導入
RVMでインストール可能です。bundlerもあわせて導入。
<pre>
rvm install 1.9.3
gem install bundler
</pre>

#### DNSの設定 / dnsmasq
iOSデバイスからSiriへの通信は全て`guzzoni.apple.com`宛に送信されるのですが、この通信を全てSiriProxyが動作するサーバへ転送させる必要があります。

そこで、SiriProxyを起動するマシンで内部DNSを立てて、iOSデバイスのWiFiネットワークのDNSをこの内部DNSを向けさせてあげることで、iOSデバイスのSiriの通信はすべてSiriProxyを向くことになります。
公式ではdnsmasqの導入で実現を行っています。全体を通してここが一番厄介ですが、Homebrewを利用することで次のように導入可能です。

<pre>
brew install dnsmasq
# confファイルを雛形から作成
cp /usr/local/opt/dnsmasq/dnsmasq.conf.example /usr/local/etc/dnsmasq.conf
</pre>

ここで、dnsmasq.confには次のようにaddress情報を追記します。
<pre>
# Add domains which you want to force to an IP address here.
# The example below send any host in double-click.net to a local
# web-server.
#address=/double-click.net/127.0.0.1
# 192.168.0.6はSiriProxyが可動するマシンのアドレス
address=/guzzoni.apple.com/192.168.0.6
</pre>

保存後、

<pre>
sudo /usr/local/sbin/dnsmasq
</pre>

で、稼働します。

稼働後、iOSのネットワークの設定で、DNSのアドレスを先ほどdnsmasqを設置したマシンのアドレスに上書きします。

<a href="http://www.flickr.com/photos/katsuma/8347244546/" title="DNS setting by katsuma, on Flickr"><img src="http://farm9.staticflickr.com/8189/8347244546_4eda101542_n.jpg" width="180" height="320" alt="DNS setting"></a>

元々のDNSはアドレスは192.168.0.1でしたが、192.168.0.6で更新しています。

#### SiriProxyのセットアップ
ここまでくると後はそんなに詰まることが無いと思います。必要なライブラリや証明書を作成します。
<pre>
git clone https://github.com/plamoni/SiriProxy.git
cd SiriProxy
mkdir ~/.siriproxy
cp ./config.example.yml ~/.siriproxy/config.yml
rake install
siriproxy gencerts
</pre>

最後のgemcertsで`~/.siriproxy/ca.pem`な証明書が作成されているので、この証明書をメールで添付してiOSデバイス宛に送信します。iOSのメールアプリでメールを開くと、証明書のインストールが可能になります。

#### siriproxy.gemspecの編集
2013.1.5時点のgemspecにはバグがあって、最新のCFPropertyListを問答無用で利用しようとしてiOS6によるSiriの音声パケットの解析でコケる問題を持っています。[Issueで散々盛り上がりながら、](https://github.com/plamoni/SiriProxy/issues/389)まだコードにマージされていないようなので、とりあえず手元で

<pre>
s.add_runtime_dependency "CFPropertyList"
</pre>

と、あるのを

<pre>
s.add_runtime_dependency "CFPropertyList", '2.1.2'
</pre>

と、修正します。

#### config.ymlの編集
このままSiriProxyを起動してもサンプルのプラグインは稼働しますが、SiriProxy-iRemoconのようにプラグインを追加するとなると、config.ymlを書き換える必要があります。~/.siriproxy/config.ymlのpluginsを次のような内容を追記します。この内容はSiriProxy-iRemoconの中のconfig-info.ymlと同一のものです。

<pre>
- name: 'Iremocon'
  git: 'git@github.com:katsuma/SiriProxy-iRemocon.git'
  host: '192.168.0.9'
</pre>

hostはiRemoconに割り当てられているIPアドレスになります。（これ書いてる途中で電気のON/OFFの赤外線IDが自宅の内容固定のまま公開してることに気づいた。。あとで外部から設定できるように変更します。。→ [変更しました](https://github.com/katsuma/SiriProxy-iRemocon/commit/394adb07f8dfbd09549530ab422aba65ea276742)）

#### SiriProxyの起動
ここまでくるとようやくビルド＋起動ができる状態になって、

<pre>
bundle install
siriproxy update .
rvmsudo siriproxy server
</pre>

で、SiriProxyが起動します。あとは冒頭の動画のようにSiriの内容を解析して動作するはずです。


### SiriProxyのプラグインってどうなの？
びっくりするくらい簡単に書けます。基本的には

- 期待する文章を正規表現でマッチさせる
- そのブロック内で行いたい処理を書く

だけ。今回のプラグインも[こんな感じのコード](https://github.com/katsuma/SiriProxy-iRemocon/blob/master/lib/siriproxy-iremocon.rb)になっています。（以下、抜粋）

<pre>
class SiriProxy::Plugin::Iremocon < SiriProxy::Plugin
  listen_for /ライト?を?(つけて|付けて)/i do
    say 'ライトをつけます'
    signal_to_iremocon(1000)
    request_completed
  end
end
</pre>

listen\_forメソッドの引数の正規表現が期待する文章です。ちなみに「ライト?」となってるのは、僕の滑舌が悪くて何度やっても「ライ」にしか聞き取ってくれなかったのでその補正です。。ひー。

あとは別途定義したsignal\_to\_iremoconで家電操作を行う信号を発信させるだけですね。また、最後のrequest\_completedの呼び出しは、SiriProxyの作法的なものらしく、かならずブロックの最後で呼び出す必要があるそうです。


### まとめ
こんな簡単にSiriに追加処理が書けるなんてSiriProxyかなり革命的です。。[前回のエントリ](http://blog.katsuma.tv/2013/01/ruby2.0_rails4.html)でRails4で家電操作サーバ作ろうとしてましたが、Siriの操作の方が楽しそうなのでこっちにシフトしようと思いますよ。
しかし、これは21世紀の「開けゴマ！」状態ですね。。家電の操作にとどまらず、何でもSiriに仕事を任せることができそうで夢広がりまくりです。うお〜

#### 2013.01.14更新
- [エアコンの操作の様子の動画を追加しました](http://www.youtube.com/watch?v=9zpSUcJMcqg)

#### 2013.01.06更新
- [エアコンの操作を追加しました](https://github.com/katsuma/SiriProxy-iRemocon/commit/c51ac422c05633c294873729c676b87589f4be2a)


#### 2013.01.05更新
- [iRemoconへの信号情報をymlに分離しました](https://github.com/katsuma/SiriProxy-iRemocon/commit/394adb07f8dfbd09549530ab422aba65ea276742)
