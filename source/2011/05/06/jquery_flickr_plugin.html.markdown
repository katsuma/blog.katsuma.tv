---
title: "$.deferredを利用したflickrのjqueryプラグイン"
date: 2011/05/06
tags: javascript
published: true

---

<p>jQuery1.5から追加されたjquery.deferred。どんなものなのかはなんとなく理解していたのですが、全く触ったことがなかったので練習がてら、このblogのトップページにあるFlickrの最新画像サムネイル表示ライブラリを、jquery.deferredを利用したjquery.pluginとして書きなおしてみました。</p>

<p>
  <ul>
	<li><a href="https://github.com/katsuma/jquery-flickr-plugin">jquery.flickr.js</a></li>
  </ul>
</p>

<h3>利用方法</h3>
<p>jquery(1.5)以上と、当jsをロードしておいた状態で、</p>

<p><pre>
$('#foo').flickr({ user_name: 'katsuma'});
</pre></p>

<p>こんなかんじで最新画像のサムネイルがロードされます(デフォルトでは6枚)。Topページもこのシンプルな方法でロードさせています。</p>

<p>枚数を変更したいときは</p>
<p><pre>
$('#foo').flickr({ user_name: 'katsuma', view_num: 3 });
</pre></p>
<p>こんなかんじ。</p>

<p>サイズを変更したいときは</p>
<p><pre>
$('#foo').flickr({ user_name: 'katsuma', view_num: 3, size: 'small'});
</pre></p>

<p>こんなかんじ。詳しくは実際に試せるデモがあるのでこちらをご覧ください。</p>
<p>
  <ul>
	<li><a href="http://katsuma.github.com/jquery-flickr-plugin/">jquery.flickr.js demo</a></li>
  </ul>
</p>



<h3>jquery.deferred</h3>
<p>で、肝心のdeferredですが、今回は非同期のjsonpを連続して実行しつづけているのですが、普通に書くとcallbackが激しく入れ子構造になってしまうところ、それらの非同期処理を「割と同期処理っぽく綺麗に書ける」のがいいのかな、、という理解です。
たとえば、今回はユーザIDの逆引き→最新画像情報の取得→実画像のパスを取得のフローになりますが、この流れを次のように書くことができます。(実際のコードを簡略化しています)
</p>

<p><pre>
<strong>$.when</strong>(methods.findByUsername(setting.user_name)).<strong>then</strong>(function(){
  <strong>$.when</strong>(methods.getPublicPhotos()).<strong>then</strong>(function(){
    <strong>$.when</strong>(methods.loadPhoto(setting.photos));
  });
});
</pre></p>

<p>こんなかんじで、$.when~thenでchain構造でつなげていけるので、非同期処理ながらも「この処理はこの後で実行」を指示できるのがウリです。よくありがちなのはこんな書き方じゃないでしょうか。</p>

<p><pre>
var methods = {
  findByUsername : function(name){
    $.ajax({
      ...
      callback : function(data){
        ...
        methods.getPublicPhotos(); // callback内から次に実行する関数を呼び出し
      }
    });
  },

  getPublicPhotos : function(){
    ...
  }
};

// 最初に呼び出す関数
methods.findByUsername(setting.user_name);
</pre></p>

<p>こんな感じでも書けますが、呼び出し元がコード内で散らばるので、可読性が著しく落ちることになります。jquery.deferredを利用すれば、when~thenのchainでまとめられるので、「どういう順番でどの関数が呼び出されているか」を追いかけやすくなります。
まだまだ他にもメリットはあるかと思いますが、ざっと書いてみたところとりあえずこの点が一番のメリットかな、と感じました。</p>

<h3>勘違い</h3>
<p>最初は結構勘違いしていて、非同期処理を完全に同期処理として書けるものなのかと思ってました。なので、こんなふうに書けちゃうのかな、と。</p>

<p><pre>
// findByusernameはjsonpで実行...だけどreturnでidが取れるはず！
var user_id = methods.findByUsername(setting.user_name); 

 // 上記結果を元にして再びjsonpでgetPublicPhotosを呼び出せる！
var photos = methods.getPublicPhotos(user_id);
</pre></p>

<p>当然こんなかんじには動きません。非同期処理はあくまでも非同期なので、returnで同期処理っぽく値を取れることはありません。このあたりはやっぱコード書かないとわからないですね。</p>



