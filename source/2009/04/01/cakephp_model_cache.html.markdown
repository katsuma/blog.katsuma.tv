---
title: CakePHPでモデルキャッシュを利用する
date: 2009/04/01
tags: php
published: true

---

<p>Cakeでキャッシュ周りの調査をしていたら、モデルのメソッドの実行結果をキャッシュさせるbehaviorがあるのを見つけました。</p>

<ul><li><a href="http://www.exgear.jp/blog/2008/11/cakephp12-behavior%E3%81%A7%E3%83%A2%E3%83%87%E3%83%AB%E3%81%AE%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%82%AD%E3%83%A3%E3%83%83%E3%82%B7%E3%83%A5%E3%82%92%E8%A1%8C%E3%81%86/">CakePHP1.2 Behaviorでモデルのメソッドキャッシュを行う</a></li></ul>

<p>これが相当いい感じなので、その利点や導入方法についてまとめておきたいと思います。</p>

<h3>コントローラのスリム化</h3>
<p>
MVCモデルでキャッシュを利用しようという話になると、大抵Controllerでキャッシュヒットの有無を確認して、ヒットしない場合キャッシュをリセットする、というロジックがまず頭に浮かぶと思います。</p>

<p><pre>
if (($posts = Cache::read('posts')) === false) {
 $posts = $this->Post->find('all');
 Cache::write('posts', $posts);
}
</pre></p>

<p>ただ、コントローラで毎回このようなキャッシュヒットを確認していると同じようなコードがあちこちに散らばることになるので、保守性が悪くなります。なので、こういうキャッシュ周りの処理はできるだけモデルに振ってしまったほうがよいです。また、基本的なフロー以外の余計なロジックを考えなずにくてよいので、可読性も格段に上がると思います。</p>

<p>
<pre>
// キャッシュヒットすればキャッシュから、ヒットしない場合はDBアクセス
$posts = $this-&gt;Post-&gt;find('all');
</pre></p>

<h3>Paginationもキャッシュできる</h3>
<p>CakePHP1.2から導入されたPaginationですが、実態はfind('all')＋ページ情報をセットする処理を隠蔽したものとなっています。ポイントは、$controller->paginate()メソッドの中で、これらの処理を全部行いつつも、returnで戻ってくるのはfind('all')の結果なので、paginate()の結果だけキャッシュさせていても、ページ情報がキャッシュされずにView側でエラーになる、ということです。（このあたりのページ処理についてはcake/libs /controller/controller.phpの1056行目あたりにあります）
この理由から、controller側でpaginateの結果をキャッシュさせる作戦はうまくいかないので、Paginationは毎回遅くなります。</p>

<p>そこで、controller側ではなく、Model側でキャッシュを行わせます。paginate()内で行われるfind以外の処理、つまりページ情報の処理についてはその処理時間は高々知れているので、結局findの処理をキャッシュさせておくことでpaginate()の高速化が期待できます。
</p>

<h3>導入方法</h3>
<p>今回は、モデルキャッシュをmemcachedにキャッシュさせるようにしました。コードは上記リンクから入手できるので、app/models/behaviorにcache.phpで保存しておきます。</p>

<p>まず、app/config/core.phpのCache::configを次のようにFileエンジンの設定をコメントアウトし、Memcacheエンジンを利用します。</p>

<p><pre>
Cache::config('default', array(
    'engine' =&gt; 'Memcache', //[required]
    'duration'=&gt; 3600, //[optional]
    'probability'=&gt; 100, //[optional]
    'prefix' =&gt; Inflector::slug(APP_DIR) . '_', //[optional]  prefix every cache file with this string
    'servers' =&gt; array(
    	'127.0.0.1:11211' // localhost, default port 11211
     ), //[optional]
    'compress' =&gt; false, // [optional] compress data in Memcache (slower, but uses less memory)
));
//Cache::config('default', array('engine' =&gt; 'File'));
</pre></p>

<p>そして、キャッシュを利用したモデルにおいてactsAsで設定します。</p>

<p><pre>
var $actsAs = array('Cache');
</pre></p>

<p>
findをオーバーライドします。僕は、findの第一引数にいろんなバリエーションを持たせることをよくやるので、</p>

<p><pre>
    function find($type, $queryData = array()){
        switch ($type) {
            case 'popular' :
                return $this-&gt;find('all', Set::merge(array("conditions"=&gt;array("Model.rating"=&gt;5)), $queryData));

            case 'latest' :
                return $this-&gt;find('all', Set::merge(array("limit"=&gt;10, "order"=&gt;"Model.created"), $queryData));
               
            default:
                $args = array($type, $queryData);
                if ($this-&gt;Behaviors-&gt;attached('Cache')) {
                    if($this-&gt;cacheEnabled()) {
                        return $this-&gt;cacheMethod($cache_time, __FUNCTION__, $args);
                    }
                }
                $parent = get_parent_class($this);
                return call_user_func_array(array($parent, __FUNCTION__), $args);
        }
    }
</pre></p>

<p>こんなかんじで、第一引数のタイプをcase文で振って、return文では素のfind('all')を通らせることで必ずdefaultに処理を落とすようにさせ、そこでキャッシュをかけるようにさせます。これでシンプルでスッキリした構成にできました。
</p>

<h3>まとめ</h3>
<p>１つ思ったのは、このビヘイビアではcacheMethodメソッドにおいて第一引数ではキャッシュ時間を指定させるのですが、この時間は第三引数にしてオプション扱いにしてほしかったかなぁということ。と、いうのは単純な話で、このメソッドにおいて重要度は　__FUNCTION__ &gt; $args &gt; $cache_timeであるから。組み込みのエンジンを利用できるのだからcacheのexpireもCache::configのduration値を標準で見てくれてもいいのかな、と思います。</p>

<p>とはいえ、これでコントローラ側では普通にfindを呼び出すだけでキャッシュ付きの処理を行うことができるので、非常に有効なライブラリかと思います。ちなみにキャッシュはModelに対応したテーブルのレコードが変化するたびにクリアされる(=afterSaveをフックしている)ので、頻繁に saveが起こるようなModelでは、あまりキャッシュが有効にならない場合も多いかと思うので、その点はご注意を。</p>


