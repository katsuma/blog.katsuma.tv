---
title: yumで入れたPHPをソースからコンパイルしたPHPと入れ替える
date: 2009/01/07 23:03:06
tags: php
published: true

---

<p>Apacheが最近segmentation faultでコケることが数回あったので、原因を探るためにdebugを有効にしたPHPに入れなおすことにしてみました。OSはLinux(Fedora9)で、Apache, mysqldはyumで入れていたものをそのまま使うことを想定しています。以下、作業メモです。</p>

<h3>既存のPHPを削除</h3>
<p>もともとyumで入っていたので、そのまま素直にyumで削除します。</p>
<p><pre>
sudo yum -y remove php\*
</pre></p>

<h3>ソースコードの入手</h3>
<p>PHPの最新のソースコードを入手します。ソースコードは<a href="http://www.php.net/downloads.php">ここ</a>から入手できます。2009.01.06時点での最新バージョンは5.2.8です。</p>

<h3>Configureの準備</h3>
<p>Configureにあたって、多くのツールをインストールしておく必要があります。僕は次のものを入れる必要がありました。（場合によってはまだほかにも必要かも？）</p>

<p><pre>
sudo yum -y install ncurses\*
sudo yum -y install gcc-c++ 
sudo yum -y install flex
sudo yum -y install libxml\*
sudo yum -y install gdbm-devel
sudo yum -y install gd gd-devel freetype freetype libpng libmng\* libtiff\* libjpeg\* libc-client\* giflib\*
sudo yum -y install httpd\*
sudo yum -y install pcre-devel
sudo yum -y install unixODBC-devel
sudo yum -y install net-snmp-devel
sudo yum -y install openssl\*
sudo yum -y install bzip2\*
sudo yum -y install curl\*
sudo yum -y install gdbm\*
sudo yum -y install db4\*
sudo yum -y install gmp\*
sudo yum -y install libc-client\*
sudo yum -y install openldap\*
sudo yum -y install libmcrypt\*
sudo yum -y install mhash\*
sudo yum -y install freetds\*
sudo yum -y install mysql\*
sudo yum -y install postgresql\*
sudo yum -y install aspell\*
sudo yum -y install readline\*
sudo yum -y install libtidy\*
sudo yum -y install libxslt\*
sudo yum -y install libtool\*
</pre></p>

<h3>configure</h3>
<p>yumで入れていたころのPHPのconfigure結果をできるだけ再現させてます。そこからサポートされていないオプションは外して、mysqlのprefixを変更、apxs2のオプションを追加させています。（yumで入れてたときのPHPはapxs2が指定されていなかったけど、なんで指定されてなかったのかよくわかんないです＞＜）</p>

<p><pre>
./configure  --build=i386-redhat-linux-gnu --host=i386-redhat-linux-gnu --target=i386-redhat-linux-gnu --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib --libexecdir=/usr/libexec --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --cache-file=../config.cache --with-libdir=lib --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --enable-debug --with-pic --disable-rpath --with-pear=/usr/share/pear --with-bz2 --with-curl --with-exec-dir=/usr/bin --with-freetype-dir=/usr --with-png-dir=/usr --enable-gd-native-ttf --without-gdbm --with-gettext --with-gmp --with-iconv --with-jpeg-dir=/usr --with-openssl --with-pcre-regex=/usr --with-zlib --with-layout=GNU --enable-exif --enable-ftp --enable-magic-quotes --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg  --enable-wddx --with-kerberos --enable-ucd-snmp-hack --with-unixODBC=shared,/usr --enable-shmop --enable-calendar --without-mime-magic --without-sqlite --with-libxml-dir=/usr --enable-force-cgi-redirect --enable-pcntl --with-imap=shared --with-imap-ssl --enable-mbstring=shared --enable-mbregex --with-ncurses=shared --with-gd=shared --enable-bcmath=shared --enable-dba=shared --with-db4=/usr --with-xmlrpc=shared --with-ldap=shared --with-ldap-sasl --with-mysql=/var/lib/mysql  --with-mysql-sock=/var/lib/mysql/mysql.sock --enable-dom=shared --with-pgsql=shared --with-snmp=shared,/usr --enable-soap=shared --with-xsl=shared,/usr --enable-xmlreader=shared --enable-xmlwriter=shared --enable-fastcgi --enable-pdo=shared --with-pdo-odbc=shared,unixODBC,/usr --with-pdo-pgsql=shared,/usr --with-pdo-sqlite=shared,/usr --enable-json=shared --enable-zip=shared --with-readline --enable-dbase=shared --with-pspell=shared --with-mcrypt=shared,/usr --with-mhash=shared,/usr --with-tidy=shared,/usr --with-mssql=shared,/usr --with-apxs2=/usr/sbin/apxs
</pre></p>

<p>その後、make, make install でPHPがインストールされます。</p>

<p>また、configure, makeあたりでmysql周りが原因でコケるときは次を実行してから、./configure からやりなおしたらうまくいくかもしれません。</p>

<p><pre>
export LDFLAGS="-L/usr/lib/mysql" 
</pre></p>

<h3>php.ini</h3>
<p>makeするとカレントディレクトリにphp.ini-recommendedができているので、これを/etcにコピーして必要な項目を修正します。</p>
<p><pre>
cp php.ini-recommended php.ini
sudo mv php.ini /etc/
(好きなように編集)
</pre></p>

<h3>php.confの作成</h3>
<p>make installするとhttod.conf(/etc/httpd/conf/httpd.conf)に次の１行が追加されています。</p>
<p><pre>
LoadModule php5_module modules/libphp5.so
</pre></p>

<p>ただ、できるだけhttpd.confは素のままにさせておいて追加項目は書きたくない主義なので、さっきの１行は削除してしまいます。かわりに/etc/httpd/conf.d/php.confを次の内容で作成します。</p>

<p><pre>
#
# PHP is an HTML-embedded scripting language which attempts to make it
# easy for developers to write dynamically generated webpages.
#

LoadModule php5_module modules/libphp5.so

#
# Cause the PHP interpreter to handle files with a .php extension.
#
AddHandler php5-script .php
AddType text/html .php

#
# Add index.php to the list of files that will be served as directory
# indexes.
#
DirectoryIndex index.php

#
# Uncomment the following line to allow PHP to pretty-print .phps
# files as PHP source code:
#
#AddType application/x-httpd-php-source .phps
</pre></p>

<p>これでhttpdを再起動すると--enable-debugなPHPで再起動します。たとえば素のCakePHPなんかはこれで動作させることができます。</p>

<h3>まとめ</h3>
<p>なかなかconfigureを通すことができなかったり、mysqlとの連携がうまくいかなかったりしたのですがなんとかビルドすることができました。ずっとyumにお世話になっているとゼロからbuildするのもすごく苦労しますね。。。まーでもいい勉強になりました。</p>


