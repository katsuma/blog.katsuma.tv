---
title: WEB+DB PRESS Tech Meetingに行ってきました
date: 2007/12/21 02:59:39
tags: develop
published: true

---

<p>
<a href="http://www.flickr.com/photos/katsuma/2125372556/" title="WEB+DB PRESS Tech Meeting by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2014/2125372556_9299ebca1c_m.jpg" width="240" height="180" alt="WEB+DB PRESS Tech Meeting" /></a>
</p>

<p>WEB+DB PRESS主催の<a href="http://gihyo.jp/event/2007/tech-meeting">WEB+DB PRSESS Tech Meeting</a>に行ってきました。ついでにその流れで懇親会にも。以下、ざっとメモです。</p>

<h3>JavaScript Tips & Technique 天野さん</h3>
<ul>
<li>JSでできること、できないこと、将来できるようになること</li>
<li>ASとの比較を主に</li>
<li>video要素, audio要素, xhr level2なんかの実装状況について</li>
<li>videoはFx3.x, Opera10, audioはOpera10, xhr level2はFx3.xで実装予定</li>
<li>xhr level2はcrossdomain.xmlみたいにアクセス制御ができるようになるらしい</li>
<li>JSDeferredについて</li>
<li>重い処理を非同期化させるモデル。その独自ライブラリ(でいいのかな)</li>
<li>あらかじめ幾つか言及されてるBlog読んで前提知識あったから割と理解できたけどざっと聞いただけじゃ難しいんじゃないかな。ちなみにkuさんの<a href="http://ido.nu/kuma/2007/11/29/coding-synchronized-asynchronous-processing-intuitively-with-mochikit-async-deferred/">このエントリ</a>がすごくよかったですよ。DeferredのオリジナルはMochiKitなんかな</li>
<li>JSONP複数リクエストのレスポンスをまとめてどうこう、みたいな時に便利（な、はず）</li>
</ul>

<h3>SIビジネスに未来はあるか！？ 羽生さん</h3>
<p><a href="http://www.flickr.com/photos/katsuma/2124599237/" title="WEB+DB PRESS Tech Meeting by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2238/2124599237_e2db8acd19_m.jpg" width="240" height="180" alt="WEB+DB PRESS Tech Meeting" /></a></p>

<ul>
<li>ある意味で一番印象強かったセッション。久々に学校の先生の話を聞く気分に。</li>
<li>羽生さんはWEB+DB PRESS 1-34号まで皆勤賞だったそうな</li>
<li>昔はFlashやJavaScriptの記事を書くとDISられて叩かれたらしい。時代だなぁ。</li>
<li>納品したものを自分自身で使いたくなるようなサービス、システムを作っているかどうか</li>
<li>人の64倍の仕事を！普通の人の8時間でできるのを1時間でやる</li>
<li>このあたりがすごく印象的だった。自戒の意味も込めて</li>
</ul>

<h3>うちではこんな感じです 〜 Linuxロードバランサの活用事例 ひろせさん</h3>
<ul>
<li>LVSを使うようになってから（精神的）睡眠時間が長くなったよ、な話</li>
<li>最初は商用のバランサを使っていたらしいけど、そのドキュメントはかなり勉強になったそうな、これは納得</li>
<li>XMPPのサーバ（Jabber等IMのプロトコル）のバランサもLVSでOKみたい。バランシングできないものは何も無いのかな</li>
<li>LVSにはkeepalivedを利用</li>
<li>keepalived.confは自動生成されるようなツールを自分たちで作っている。httpd.confもしかり</li>
<li>MySQLのslaveの管理もLVSで。アプリケーション層でSlaveの管理をする必要がなくなるので、。結局アプリケーション層から見ると大きなSlaveが１台だけ見えるような形になるそうな。これはいい！</li>
<li>とりあえず手元のVMなんかで小さな構成から始めてみればおｋ、とのこと</li>
</ul>

<h3>受託開発を楽しむ。 〜 もっと「ソーシャルに」仕事する！ 岡島さん</h3>
<ul>
<li>生産的なバグ、「Productive Bugs」 を増やす</li>
<li>野球で言うところの犠打(送りバント、犠牲フライ)も必要</li>
<li>Productive Bugsの例：単体テストで、レアパターンのバグ、結合テストで、運用に問題のあるケース、実際のデータでのみ発生する問題など</li>
<li>逆にデグレ、データオーバーフロー、入力チェック漏れなんかは「非生産的バグ」</li>
<li>リーダー像は「プラニング」「トップダウン」の軸で４パターンに分けられる</li>
<li>「よしよし」「バリバリ」「ふむふむ」「ほうほう」// この分け方ウケた</li>
<li>全体的にやや分かりづらい感じではあったものの、物事を考える切り口が非常にユニークで、その点が興味深かったです</li>
</ul>


<h3>Alpha Geekに逢いたい♥［LIVE］ 小飼さん、伊藤さん</h3>
<p><a href="http://www.flickr.com/photos/katsuma/2125373112/" title="Dan Kogai and Naoya Ito by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2032/2125373112_c207222e1f_m.jpg" width="240" height="180" alt="Dan Kogai and Naoya Ito" /></a></p>
<ul>
<li>Q:子飼さん、A:伊藤さん　の形式。以下はほぼ伊藤さんの発言</li>
<li>技術者が自由にマネージメントできるようにしていると、小粒なサービスしか生まれない場合も</li>
<li>社会的に問題があるサービスを作ってしまったときに、うまくハンドリングできない場合が（経験談？）</li>
<li>コンピュータサイエンスを専攻する学生はどんどん減っている。日本では慶応でそんな話が</li>
<li>建築系のように夢物語的な話がもっと出てきてプロジェクトXのように取り上げられることが増えた方がいい</li>
<li>プログラマが格好悪いとかは思わない</li>
<li>Hacker=神！　と思えるような人のエピソードが増えた方がいい</li>
<li>プログラムによって社会的に貢献した人は経済的にも幸せになるべき。ここがうまくいかない場合が多い</li>
<li>何でもかんでも世界を目指す！というものでもないのかも</li>
<li>日本の技術書の訳書の多さはすごい。世界に非英語圏でこんな恵まれた国はない。英語圏でなくても最新の技術情報が入る恵まれた国</li>
<li>だから英語ができた方がいい、とか単純には思わない</li>
<li>とは言ってもエンジニアとして、世界を相手にしてもまれた方がいい、とは思う</li>
<li>伊藤さんの話を聞くのは２回目。この方ほど「世界を変えられるのはコードだけ」の確固たる方向性が感じられる人ってそうそういないと思います</li>
</ul>


<p>と、そんな感じの2時間半のセッションでした。その後、打ち上げという名の懇親会。数人の方ともいろいろお話しさせていただきました。blog読んでくださってる方、同期と共通の知人である方、講演者の方、某有名エロギークな方までいろいろ。</p>

<p><a href="http://www.flickr.com/photos/katsuma/2125373486/" title="WEB+DB PRESS Tech Meeting by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2318/2125373486_0035ed5a86_m.jpg" width="240" height="180" alt="WEB+DB PRESS Tech Meeting" /></a></p>

<p>思ったのは、こういう場では会社の名刺ももちろん重要ですが、mini cardは更にめちゃめちゃ便利。TwitterのIDやBlogのURLが書かれてあった方が後から見直してFollowしたりRSS購読して、その方の印象が深まること請け合いです。後から管理するのが厄介だったりするんですけども、こういう懇親会のような場では自己PRの手段としてはそうとういいと思いました。</p>

<p><a href="http://www.flickr.com/photos/katsuma/2124600437/" title="Dave Thomas by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2284/2124600437_e43cdd3468_m.jpg" width="240" height="180" alt="Dave Thomas" /></a></p>

<p>で、ついでに？ノベルティのDave Thomasのサイン入りTシャツに天野さんにサインを書いてもらいました。</p>

<p><a href="http://www.flickr.com/photos/katsuma/2124600605/" title="amachang's sign by katsuma, on Flickr"><img src="http://farm3.static.flickr.com/2091/2124600605_9c5b33fc4a_m.jpg" width="240" height="180" alt="amachang's sign" /></a></p>

<p>「やる男でもいいですよ」と言ったらプギャー！で返されました。。ｗ</p>
