---
title: blog.katsuma.tvをhttp2対応をしました
date: 2017/05/17 01:00:00
tags: web
published: true

---

またもや1年ぶりの更新ですが、唐突に本ブログをHTTP2対応させました。それに伴いURLが変更になっています。といってもhttpからhttpsへの変更ですね。

- [https://blog.katsuma.tv/](https://blog.katsuma.tv/)

経緯としては、ずっとMovableTypeで運用していたこのブログを、Middlemanに移してgithubでコード管理に変更したいな、、とずっと思っていたのですが
今年のGWにようやくまとまった時間がとれたので勢いで移行することができました。
その際に、どうせ自分のサーバ（さくらのVPS）で運用させるのなら手を入れられるだけとことん入れてみたいな、、と思い調査をしはじめました。

## https対応
2017年におけるSSL証明書の相場感もよくわかっていなかったのですが、今は無料で手に入るのですね。いい時代。
今回は[Let's Encrypt](https://letsencrypt.jp/)を利用することにしました。
慣習的に `/usr/local` 以下に入れるパターンが多そうなので従ってます。

<pre>
cd /usr/local/
git clone https://github.com/certbot/certbot
cd certbot/
./certbot-auto -n</pre>

なお、証明書発行の際には、DNSを設定して発行対象のドメイン=作業環境になっている必要があります。
DNSが浸透する前に証明書発行処理を行ったことで発行に失敗し、少しハマることがありました。

発行処理は、nginxなどWebサーバプロセスが起動していない状態であれば、スタンドアローンモードで実行すれば特に何も迷わずに進めることができるかと思います。

<pre>
./certbot-auto certonly --standalone -t</pre>

実行完了すると `/etc/letsencrypt/` 以下に証明書がドメイン毎に保存されます。
今回はWebサーバとしてnginxを利用したので、以下のような設定で発行された証明書を指定できます。

<pre>
server {
    server_name  blog.katsuma.tv;
    root        /path/to/root/blog.katsuma.tv/public;

    # ここを指定
    listen      443 ssl;
    ssl_certificate     /etc/letsencrypt/live/blog.katsuma.tv/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.katsuma.tv/privkey.pem;

    access_log  /path/to/blog.katsuma.tv/logs/access.log  main;
    error_log   /path/to/blog.katsuma.tv/logs/logs/error.log   warn;
}</pre>


ついでにhttpの従来のリクエストはhttpsのプロトコルへリダイレクトさせます。


<pre>
server {
    server_name blog.katsuma.tv;
    listen 80;
    return 301 https://$host$request_uri;
}</pre>

## http2対応

これだけでもhttps対応は可能なのですが、ついでにhttp2対応も行います。
`listen`の箇所を変更するだけでOKです。

<pre>
listen 443 ssl http2;</pre>

おお、便利。。と思いきや実はこれだけではhttp2対応できません。

Chrome51からTLS上のネゴシエーションプロトコルが[ALPN](https://ja.wikipedia.org/wiki/Application-Layer_Protocol_Negotiation)に対応していないとhttp2をしゃべってくれなくなりました。こんなの初めて知ったぞ。。

ALPNは、OpenSSL1.0.2以上がインストールされていればOKです。
たしかにOKなのですが、さくらのVPSの環境ではyumで入るOpenSSLは1.0.1eが最新で、1.0.2に上げるためにはソースコードからコンパイルが必要になります。
ここで、コンパイルしてインストールしなおしを選んでもいいのですが、OpenSSLのようにいろんなソフトウェアから利用されているものをいきなりバージョン上げるのはあまり意欲がわきません。


## LibreSSLを利用したnginxのビルド

そこでOpenSSLのバージョンを上げるのはやめて、[LibreSSL](https://www.libressl.org/)を利用することにします。
LibreSSLはニュースサイトで一度見たくらいでスルーしていたのですが、安定性も特に問題なさそうとのことなのと、
OpenSSLと分離することで最悪問題がおきても被害を最小限に留められるかと考えました。

実際はnginxコンパイル時に`with-openssl`オプションでLibreSSLを指定すればOKです。
nginxのビルドはミスっても最悪yumで入れ直せばいいのでリスク的には許容できそう。

ひとまずnginxのビルドオプションはyumで入っているもの（`/path/to/nginx -V` で確認できます）に基本あわせて、
 `with-openssl` の箇所だけを変更します。ちなみに今回ビルドしなおしたnginxのバージョンは `1.13.0` です。

<pre>
cd nginx-1.30.0
./configure \
--prefix=/usr/local/nginx \
--modules-path=/usr/lib64/nginx/modules \
--conf-path=/usr/local/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx \
--group=nginx \
--with-compat \
--with-file-aio \
--with-threads \
--with-http_addition_module \
--with-http_auth_request_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_random_index_module \
--with-http_realip_module \
--with-http_secure_link_module \
--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_v2_module \
--with-mail \
--with-mail_ssl_module \
--with-stream \
--with-stream_realip_module \
--with-stream_ssl_module \
--with-stream_ssl_preread_module \
--with-openssl=../libressl-2.5.3 \
--with-ld-opt='-lrt'
make
sudo make install</pre>


これでようやくhttp2対応ができました。

## 安全性をより強化

[SSL Labs](https://www.ssllabs.com/ssltest/index.html)では特定の環境の安全性を診断してくれます。
どうせなら高得点を目指したい。以下、そのためのTips。

### HSTSの対応
`Strict-Transport-Security` ヘッダをサーバから送ることでHTTPSでの通信を強制させることができます。

<pre>
add_header Strict-Transport-Security "max-age=15768000; includeSubdomains";</pre>

### 認証方式の指定

SSLv2, v3あたりの認証方式は古いので明示的に無効にさせます。
また、強度が弱い暗号化方式を無効化させ、ForwardSecrecyに対応させるためにECDHを指定させます。

<pre>
ssl_ciphers  'ECDH !aNULL !eNULL !SSLv2 !SSLv3';</pre>


まとめるとこんなかんじです。


<pre>
server {
    server_name blog.katsuma.tv;
    listen 80;
    return 301 https://$host$request_uri;
}

server {
    server_name  blog.katsuma.tv;
    root        /path/to/root/blog.katsuma.tv/public;

    listen      443 ssl http2;
    ssl_ciphers  'ECDH !aNULL !eNULL !SSLv2 !SSLv3';
    add_header Strict-Transport-Security "max-age=15768000; includeSubdomains";

    ssl_certificate     /etc/letsencrypt/live/blog.katsuma.tv/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/blog.katsuma.tv/privkey.pem;

    access_log  /path/to/blog.katsuma.tv/logs/access.log  main;
    error_log   /path/to/blog.katsuma.tv/logs/logs/error.log   warn;
}</pre>

これで本ブログサイトもhttp2対応した上で、安全性も[A+のスコア](https://www.ssllabs.com/ssltest/analyze.html?d=blog.katsuma.tv)を取ることができました。

## まとめ
- Let's encryptを利用して証明書を無料で取得した
- LibreSSLを利用してnginxをビルドしなおした
- HSTS対応、認証方式の見直しを行った
- 結果、http2対応した上でより安全性を向上させる環境を構築することができた

今回、久々にインフラ触りました。
後半のSSL Labのスコア上げは正直惰性でしたが、http2環境構築のための作業はなかなか大変なところはあったものの、かなり勉強になって楽しかったですね。
