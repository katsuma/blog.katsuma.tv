---
title: CakePHPのアソシエーションでInner Joinを利用してレスポンス速度を向上
date: 2008/12/15 23:56:54
tags: php
published: true

---

<p>レコードサイズが大きくなってくるとhasOneやbelongsToのアソシエーションでかなり時間を食うときがあります。特に大きな処理をしなくても、ページアクセス時にControllerでdescribe &lt;Table&gt;して、結合した結果を舐めて時間が食われます。</p>

<p>いくらなんでも時間かかりすぎだろ、、と思ってよく調べてみたらCakeでのテーブル間JoinてLeft Joinになってるんですね。クエリ凝視するまで気づかなかった。これ、特に問題なければ内部結合（Inner Join)にするだけでレスポンス速度は大きく変わります。方法はModelでアソシエーション対象Model名のtypeを"INNER"にするだけ。</p>

<p><pre>
&lt;?php
class User extends AppModel {
        var $name = 'User';
        
        var $hasOne = array(
                'Profile' =&gt; array(
                        'className' =&gt; 'Profile',
                        'foreignKey' =&gt; 'user_id',
                        'conditions' =&gt; '',
                        'type' =&gt; ' INNER'
                )
        );
}
?&gt;
</pre></p>

<p>こういうテクはもちろんケースバイケースですけど、意外に盲点なチューニング方法かもしれません。</p>


