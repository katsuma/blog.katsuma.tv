---
title: PoundでReverse Proxy環境を構築してHTTPとRTMPTを共存
date: 2009/03/04 01:22:36
tags: develop
published: true

---

<p>(2009/03/04 22:55追記) typesterさんから</p>
<p><blockquote><a href="http://delicious.com/url/e5990530792fbf6c594c0e04af91617b#typester">mod_proxyでできるんじゃないのかな</a></blockquote></p> 
<p>なコメントをいただきましたが、ご指摘とおり、mod_proxyだけでも共存は可能だと思います。今回は試験的な意味もこめてPoundを使って環境構築をしましたが、おいおいmod_proxyも試してみたいと思っています。(ここまで追記)</p>

<p>Wowza Media ServerなんかのRTMPサーバは、標準の1935番ポートへの接続ができないクライアントのために、HTTPでカプセル化した通信(RTMPT)を受け付けるために、80番ポートでの待ち受けが可能です。（さらにSSL化した443番ポートでの通信RTMPSなんかもあります）</p>

<p>ただ、1台のマシンでWebサーバと共存させる場合、80番ポートが競合するのでこのままではうまく共存できません。そこで、Reverse Proxyを利用してHTTP, RTMPTそれぞれのアクセスを別ドメインへのアクセスとして、自身のHTTP, RTMPT待ち受けポートを80番以外のものにしてあげると共存が可能になります。たとえば、ポート番号をReverse Proxy=80, HTTP=81, RTMPT=82なんかにして、Reverse ProxyがHTTP, RTMPTをそれぞれのサービスに振り分けてあげればいいわけですね。</p>

<p>さて、こんな環境を構築しようと思って「Reverse Proxy何にしよう？Squidとか使えば言いわけ？？」と思って<a href="http://d.kawataso.net/">@kawataso</a>に相談したところ、「それ<a href="http://www.apsis.ch/pound/">Pound</a>でできるよ」とアドバイスをもらいました。Poundは初めて使ったのですが、単純なReverse Proxy環境を構築するにはものすごく簡単に実現できました。と、いうわけで今回はその構築メモを残しておきたいと思います。環境はFedora9です。</p>

<h3>Poundのインストール</h3>
<p>まず、Poundのビルドに必要な次のものをインストールします。</p>
<p><pre>
$sudo yum -y install openssl-devel
$sudo yum -y install pcre-devel
$sudo yum -y install google-perftools-devel
$sudo yum -y install rpmbuild
</pre></p>

<p>Poundはソースのrpmが公式サイトにあります。</p>
<p><ul>
<li><a href="http://www.invoca.ch/pub/packages/pound/pound-2.4.4-1.src.rpm">pound-2.4.4-1.src.rpm</a></li>
</ul></p>

<p>これをDL後、ビルド、インストールします。</p>

<p><pre>
$ sudo /usr/bin/rpmbuild --rebuild pound-2.4.4-1.src.rpm
$ cd /usr/src/redhat/RPMS/i386
$ sudo rpm -ivh pound-2.4.4-1.i386.rpm 
</pre></p>

<p>インストールしたら、サービスにも登録しておきましょう。</p>

<p><pre>$ sudo /sbin/chkconfig pound on</pre></p>

<h3>mod_rpafの導入</h3>
<p>いきなりPoundの話でもいいのですが、その話はもう少し後にしましょう。</p>

<p>Reverse Proxyを導入すると、Apacheのログがクライアントからのアクセスではなく、全部Reverse Proxyからのアクセスになってしまってしまいます。これは、ログとしては好ましくないので、まずはこれを回避します。方法は簡単で、<a href="http://stderr.net/apache/rpaf/">mod_rpaf</a>を導入すればOKです。</p>

<p>Apacheのモジュールのインストールは、apxsが必要になりますが、これはhttpd-develがインストールされてある必要があります。</p>

<p><pre>
$ sudo yum -y install httpd-devel
</pre></p>

<p>その上で、<a href="http://stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz">ソースを公式サイトからDL</a>しておきます。</p>
<p><pre>
$ wget http://stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz
$ tar zxf mod_rpaf-0.6.tar.gz
$ cd mod_rpaf-0.6
</pre></p>

<p>その後、Makefileを修正します。Apacheは2.x系が入っていることとします。先頭のAPXS2の実際の場所を指定してあげます。</p>

<p><pre>
APXS2=/usr/sbin/apxs
</pre></p>

<p>その後、Apache2.x系用のmake, make installを行います。</p>

<p><pre>
make rpaf-2.0
sudo make-install-2.0
</pre></p>

<p>ここで、mod_rpafを有効にするため、/etc/httpd/conf.d/ にrpaf.confの名前で次の内容のconfファイルを作成しておきます。ここでは、Reverse Proxyの場所を指定していますが、Reverse Proxyは同一マシン上に存在している前提で、127.0.0.1の自分自身を指定しておきます。</p>

<p><pre>
LoadModule rpaf_module modules/mod_rpaf-2.0.so
RPAFenable On
RPAFsethostname On
RPAFproxy_ips 127.0.0.1
</pre></p>

<h3>Poundのログの場所を修正</h3>
<p>Poundのログは標準では/var/log/messagesに出力されるので、messages がどんどん肥大化してしまいます。そこで、/var/log/pound に出力されるように変更します。</p>

<p>Fedora9では標準でrsyslogが起動しているかと思いますので、/etc/rsyslog.confを編集します。</p>

<p><pre>
# *.info;mail.none;authpriv.none;cron.none; /var/log/messages を
*.info;mail.none;authpriv.none;cron.none;local1.none /var/log/messages # に変更

# 以下の行も追加
local1.*                                  /var/log/pound
</pre></p>

<p>その後、rsyslogを再起動しておきます。</p>
<p><pre>
$ sudo /etc/init.d/rsyslog restart
</pre></p>

<h3>Apacheの待ち受けポートの変更</h3>
<p>/etc/httpd/conf/httpd.conf　で、次のように待ち受けポートを変更しておきます。今回は81番ポートに変更します。</p>
<p><pre>
#Listen 80 これを次のように変更
Listen 81
</pre></p>

<h3>RTMPTサーバの待ち受けポートの変更</h3>
<p>Wowza Media Server では、/usr/local/WowzaMediaServer/conf/VHost.xmlを編集します。</p>

<p><pre>
 &lt;HostPort&gt;
         &lt;ProcessorCount&gt;4&lt;/ProcessorCount&gt;
         &lt;IpAddress&gt;*&lt;/IpAddress&gt;
         &lt;Port&gt;80&lt;/Port&gt;
         &lt;SocketConfiguration&gt;
                 &lt;ReuseAddress&gt;true&lt;/ReuseAddress&gt;
                 &lt;ReceiveBufferSize&gt;24000&lt;/ReceiveBufferSize&gt;
                 &lt;SendBufferSize&gt;65000&lt;/SendBufferSize&gt;
                 &lt;KeepAlive&gt;true&lt;/KeepAlive&gt;
         &lt;/SocketConfiguration&gt;
         &lt;HTTPProvider&gt;
                 &lt;BaseClass&gt;com.wowza.wms.http.HTTPServerVersion&lt;/BaseClass&gt;
                 &lt;Properties&gt;
                 &lt;/Properties&gt;
         &lt;/HTTPProvider&gt;
 &lt;/HostPort&gt;
</pre></p>

<p>の箇所をコメントアウトを外し、ポート番号を80 → 82に設定しておきます。</p>


<h3>Poundの設定</h3>
<p>やっとこさ、Poundの設定です。今回は、HTTPの通信はwww.katsuma.tv, RTMPTの通信はrtmpt.katsuma.tvとしてアクセスを受け付けることとします。実際のApacheは81番, RTMPサーバは82番ポートでの待ち受けを行っていることを想定しています。（DNSの設定は別途行っておく必要はあります）</p>

<p>ここでは、/etc/pound/pound.confを次のように書き直します。（pound.confは念のためバックアップしておくことをおすすめします）</p>

<p><pre>
User "nobody"
Group "nobody"
RootJail "/usr/share/pound"
Control "/var/run/pound/ctl_socket"

LogLevel    3
Alive       60
Daemon      1
LogFacility local1

# Main listening ports
ListenHTTP
    Address 0.0.0.0
    Port    80
    xHTTP   1
End


# Catch-all server(s)

# Apache
Service
    HeadRequire "Host: .*www.katsuma.tv.*"
    BackEnd
       Address 127.0.0.1
       Port 81
    End
End

# RTMPT
Service
    HeadRequire "Host: .*rtmpt.katsuma.tv.*"
   BackEnd
       Address 127.0.0.1
       Port 82
    End
End

Service
    BackEnd
        Address 127.0.0.1
        Port    81
    End
    Session
        Type    BASIC
        TTL     300
    End
End
</pre></p>

<p>上から読むと、そのまま理解できるかと思います。ListenHTTPのディレクティブでProxyとしては80番ポート待ち受け、Serviceディレクティブで内部サーバ（ここでは自分自身ですがもちろん他のサーバを指定することは可能です）のリクエスト先のホスト情報、サーバアドレス、サーバポートを指定します。</p>

<p>先頭のLogLevelは次のとおりです。</p>

<p>
<ul>
<li>0 - no logging</li>
<li>1 - normal log</li>
<li>2 - full log</li>
<li>3 - Apache combined log format</li>
<li>4 - Apache combined log format without virtual host</li>
</ul>
</p>

<p>LogFacilityについては、先に書いたrsyslogとの兼ね合いですね。その他の情報についてはman poundを見られるのが一番よいかと思われます。</p>

<h3>サービスの再起動</h3>
<p>これで全部準備は揃ったので、全サービスを再起動します。</p>

<p><pre>
$ sudo /etc/init.d/httpd restart
$ sudo /etc/init.d/WowzaMediaServer restart
$ sudo /etc/init.d/pound start
</pre></p>

<p>これで、HTTPとRTMPTを1台のマシンでハンドリングさせることが可能になりました。</p>

<h3>まとめ</h3>
<p>今回は実質Pound以外の設定のほうが面倒なことが多かったかと思いますが、Pound自身の設定は簡単だったと思います。HTTPサーバとRTMPTサーバの共存、という形で設定を行いましたが、もちろんHTTPサーバの負荷分散という形での利用もOKです。（むしろそっちの利用方法のほうが今どきっぽく正しいはず）</p>


<p></p>
<h3>参考</h3>
<p><a href="http://tech.bayashi.jp/archives/entry/server/2007/001945.html">手軽なロードバランサ Pound を導入してみました</a></p>


