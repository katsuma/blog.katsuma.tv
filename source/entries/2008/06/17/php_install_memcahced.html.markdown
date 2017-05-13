---
title: PHPでmemcachedを利用する
date: 2008/06/17
tags: php
published: true

---

<p>(2008.06.18 追記)タイトルのスペルが間違っていたので訂正しました。パーマリンク名も間違ってる。。けどこれは仕方なくこのままにしておきます。orz</p>

<p>最近memcachedを使うことがあったので、使えるようになるまでの個人的メモです。基本的にyum, peclコマンドだけでインストールは可能です。対象OSはFedora8です。</p>

<p>
<pre>
sudo yum -y install memcached
sudo yum -y install php-devel #phpizeコマンドを利用するために必要
sudo yum -y install php-pecl\*
sudo yum -y install zlib
sudo pecl install memcahce
</pre></p>

<p>こんな感じでインストールはOKです。あとはmemcache.soをロードするように設定します。php.iniを直接編集してもいいのですが、extension系は/etc/php.d/に別途iniファイルを用意しておいた方が管理しやすいかもです。</p>

<p><pre>
sudo vi /etc/php.d/memcache.ini
</pre></p>

<p>で、</p>

<p><pre>
extension=memcache.so
</pre></p>

<p>の１行だけ書いたファイルを作成して、保存。</p>

<p><pre>
sudo /sbin/chkconfig memcached on
</pre></p>

<p>で、デーモンとして登録しておくと便利です。</p>

<h3>ラッパクラス</h3>
<p>peclの関数をそのまま利用してもいいのでしすが、ラッパ関数を作成してもいいかもです。僕はこんな感じのものを作成しました。MEMCACHED_SERVER_ADDR. MEMCACHED_SERVER_PORTは適当な値に置き換えてください。多分localhost, 11211番ポートになるはず。</p>

<p><pre>
&lt;?php
class MemcacheManager  {
        
        private static $cache = null;
        
        private function __construct(){}
        
        static function getInstance(){
                if(MemcacheManager::$cache == null){
                        MemcacheManager::$cache = new Memcache;
                        MemcacheManager::$cache -&gt; connect(MEMCACHED_SERVER_ADDR, MEMCACHED_SERVER_PORT);
                }
                return MemcacheManager::$cache;
        }
        function get($key){
                return MemcacheManager::$cache -&gt; get($key);
        }
        function set($key, $var, $flag = null, $expire = CAKE_SESSION_TIMEOUT){
                return MemcacheManager::$cache -&gt; set($key, $var, $flag, $expire);
        }
        function close(){
                return MemcacheManager::$cache -&gt; close();
        }        
}
?&gt;
</pre></p>

<p>そうした後で、こんな感じで使います。</p>

<p><pre>
$cache = MemcacheManager::getInstance();
$cache -&gt; set('name', 'jkondo');
echo $cache -&gt; get('name'); // 'jkondo'
</pre></p>

<p>このMemcacheManagerみたいなクラスを用意しておくと、memcachedが公式にはサポートされていないCakePHP1.1なんかでもvendorsディレクトリあたりに入れておくと、そのまま使えてしまうので結構便利。ご参考ください。（1.2になるとCacheクラスに統合されているようですね）</p>


