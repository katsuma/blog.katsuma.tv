---
title: i-nameを取得しました
date: 2008/03/02
tags: openid
published: true

---

<p><a href="http://d.hatena.ne.jp/ZIGOROu/20080203/1202063035">id:ZIGOROuさんに影響されて</a>i-nameを「=katsuma」で取得してみました。ZIGOROuさんは<a href="http://linksafe.name/">LinkSafe</a>で取得されたそうですが、僕は何度やってもトランザクションエラーが出てうまくいかなかったので<a href="http://2idi.com/welcome">2idi</a>で取得しました。年$12。ドメインと考えたら特に高くない買い物でしょうかね。</p>

<p>OpenIDについては、まだ上っ面が分かったような分かってないような、な理解度なのですが、</p>

<p><ul>
<li>OpenID1.1対応のRP(=Relying Party)なら <strong>http://katsuma.tv</strong> でログイン可能</li>
<li>OpenID2.0対応のRPなら<strong>xri://=katsuma</strong> でログイン可能</li>
</ul></p>

<p>って認識でいいのかな？？要するに</p>
<p>
<ul>
<li>2.0対応のRPはhttp:// or https:// で表されるURIのIdentifier 以外に、xri://形式のIdentifierでも利用可能</li>
<li>http://, https:// なIdentifierは無料で取得できるものがほとんどだけど、xri:// なIdentifierは、基本的に有料で取得するもの(が多い)</li>
</ul></p>
<p>なんだと思います。</p>

<h3>疑問はいろいろ</h3>
<p>あとi-nameについては自分のプロフィールを完全包括するもの、って考えでいいんでしょうかね？たとえばi-name providerは、いろんなWebサービスについてForwardingサービスを提供してくれるみたいですが、僕はこんな風にForwardさせてます。</p>

<p>
<ul>
<li><a href="http://xri.net/=katsuma/(+blog)">http://xri.net/=katsuma/(+blog)</a> ( -> blog.katsuma.tv )</li>
<li><a href="http://xri.net/=katsuma/(+home)">http://xri.net/=katsuma/(+home)</a> ( -> katsuma.tv )</li>
<li><a href="http://xri.net/=katsuma/(+photos)">http://xri.net/=katsuma/(+photos)</a> ( -> Flickr )</li>
<li><a href="http://xri.net/=katsuma/(+links)">http://xri.net/=katsuma/(+links)</a> ( -> del.icio.us)</li>
</ul>
</p>

<p>このへん<a href="http://iddy.jp/">iddy</a>とか<a href="http://plnet.jp/">plnet</a>をもっとオープンな仕様にしたものって考えでいいのかな？オープンなMNPのWebサービス版？的な？？</p>

<h3>とりあえず</h3>
<p>OpenID はまだまだこれから、なものの勉強するには今はいいネタだと思うので追っかけていきたいと思います。<a href="http://www.atmarkit.co.jp/fsecurity/rensai/openid01/openid01.html">@ITの連載</a>は情報がいい感じにまとまっているので、勉強のとっかかりとしては手を出すのによさそうです。</p>


