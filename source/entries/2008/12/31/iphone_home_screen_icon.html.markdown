---
title: 自サイトに iPhone / iPod Touch 用のホームスクリーンアイコンを設定する
date: 2008/12/31 14:28:53
tags: iphone
published: true

---

<p>2008年最後は小ネタで締めたいと思います。</p>

<p>このBlogをiPhone / iPod Touchのブックマーク時にホームスクリーン用の専用アイコンを設定してみました。 次のようにホームスクリーンに専用アイコンが表示されます。</p>

<p><a href="http://www.flickr.com/photos/katsuma/3152134227/" title="add to home screen by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3119/3152134227_1c6c22db6b_m.jpg" width="160" height="240" alt="add to home screen" /></a>

<a href="http://www.flickr.com/photos/katsuma/3152972014/" title="add to home screen by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3234/3152972014_7d03869b47_m.jpg" width="160" height="240" alt="add to home screen" /></a>
</p>

<p>アイコンの作り方は次のように簡単です。</p>

<p><ol>
<li>57x57のPNG画像を用意</li>
<li>link要素に次のように指定
<p><pre>
&lt;link rel="apple-touch-icon" href="http://blog.katsuma.tv/images/apple-touch-icon.png" /&gt;
</pre></p>
</li>
</ol></p>

<p>これだけでOKです。超簡単。</p>

<p>ちなみに1.でつくるアイコンのサイズは違うサイズでもリサイズされるようです。表示サイズが57x57であって、違うサイズの場合はiPhone / iPod Touch側で勝手にリサイズされます。</p>

<p>また、2.で場所を指定する場合、サイトのルート直下に「apple-touch-icon.png」の名前で保存しておけば勝手に読み取ってくれるそうです。今回はimagesディレクトリの中に保存しておきたかったので、link要素で指定してあげています。</p>

<p>個人のBlogについてはわざわざアイコンを指定してあげる必要性は薄いかもしれませんが、独自のWebサービスを提供している場合は、おもてなしの心のもとでちゃんと設定してあげるのがいいかもしれませんね。</p>


