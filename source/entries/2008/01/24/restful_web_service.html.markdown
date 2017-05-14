---
title: "「RESTful Webサービス」を読み終えて"
date: 2008/01/24 00:39:01
tags: book
published: true

---

<p>
<a href="http://www.amazon.co.jp/gp/redirect.html?ie=UTF8&location=http%3A%2F%2Fwww.amazon.co.jp%2FRESTful-Web%25E3%2582%25B5%25E3%2583%25BC%25E3%2583%2593%25E3%2582%25B9-Leonard-Richardson%2Fdp%2F4873113539&tag=katsumatv-22&linkCode=ur2&camp=247&creative=1211">
<img src="http://ecx.images-amazon.com/images/I/21RXsMNvdwL.jpg" border="0" alt="RESTful Webサービス" /></a>
<img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&amp;l=ur2&amp;o=9" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
</p>

<p>正月休みに実家に戻っていたときに「RESTful Webサービス」を読んでいました。かなり遅くなりましたが、ざっと感想を書いておこうと思います。</p>


<h3>序盤はやや難しい</h3>
<p>正直、かなり理解するのに苦労しました。REST自体の仕組みは理解していたものの、日本語訳に「？」という点が多々あり、「結局何を言ってるんだ？？」と思ってしまった点が結構ありました。１文、１文は分かるのですが、全体的には理解しにくいと言うか。とは言え、第一章は導入部分で「RESTってそもそも何？」だったり、「RPCなど他の技術との違い」などが中心に話が進んで行く部分なので、別の書籍や雑誌で軽く知識を入れておくと、そこまで苦労はしないかと思います。
<a href="http://www.amazon.co.jp/gp/redirect.html?ie=UTF8&location=http%3A%2F%2Fwww.amazon.co.jp%2FWEB-DB-PRESS-Vol-42-PRESS%25E7%25B7%25A8%25E9%259B%2586%25E9%2583%25A8%2Fdp%2F4774133310%2F&tag=katsumatv-22&linkCode=ur2&camp=247&creative=1211">WEB+DB PRESS</a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&amp;l=ur2&amp;o=9" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />
ならここ最近RESTの連載もあるので、その辺り目を通しておくといいかなと思いました。</p>

<h3>中盤からが重要</h3>
<p>と、いうわけで最初は読むの難しいかなぁと思っていたのですが、第四章のROAの話あたりから「なぜRESTなのか？」と突っ込んだ話になり、（日本語も自然なものになってくるのも重なり）、読みやすくなります。また、第五章のリソース、URLの具体的な設計方法は「リソース中心に考えればいい、と分かっちゃいるけど、結局それってどうするの？」な疑問/課題に対して解決の手助けとなりそうな具体例をこれでもか、と提示してくれます。</p>

<p>「何をリソースと考えるか？」な設計方法は、実装の具体例にできるだけ触れた方が理解も深まると思うので、このあたりは何度も読み返した方がよさそうだな、という印象です。本書では地図サービスを例に、リソースの考え方を提示し、del.icio.usのようなSBMサービスをRailsを使ってRESTfulサービスで実装ように話が進んで行きます。</p>

<h3>Rails(Ruby)が分かった方が特</h3>
<p>上記の通り、実装方法についてはRailsを使ってかなり具体的なコードを交えて話が進んできます。このあたりはRails(Ruby)が使えなくてもそこそこ理解はできますが、やはり触れた方がよさそう。コントローラのコードのいじる方法のあたりとか、必見なんじゃないかな、とも思います。</p>

<h3>後半はTips&リファレンス</h3>
<p>後半はレスポンスの圧縮、キャッシュ方法、セキュリティなど運用上避けて通れないような話題が中心です。このあたりはRESTうんぬん関係なく、Webアプリケーションに携わる人だったら誰でも読んでおいて損はないはず。「<a href="http://www.amazon.co.jp/gp/redirect.html?ie=UTF8&location=http%3A%2F%2Fwww.amazon.co.jp%2F%25E3%2582%25B9%25E3%2582%25B1%25E3%2583%25BC%25E3%2583%25A9%25E3%2583%2596%25E3%2583%25ABWeb%25E3%2582%25B5%25E3%2582%25A4%25E3%2583%2588-Cal-Henderson%2Fdp%2F4873113113%3Fie%3DUTF8%26s%3Dbooks%26qid%3D1201105090%26sr%3D1-1&tag=katsumatv-22&linkCode=ur2&camp=247&creative=1211">スケーラブルWebサイト</a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&amp;l=ur2&amp;o=9" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />」と似たような感じです。</p>

<p>巻末にはHTTPのステータスコード一覧。「RESTful Webサービス的な観点」で重要度が記されてあるのは少し面白いです。このあたりちゃんと間違えずに理解して<a href="http://mala.nowa.jp/entry/24af50df17">Web屋のネタ帳みたいなことを書かれないように</a>しないと。。。</p>

<h3>結局</h3>
<p>序盤で理解するのに苦労すると結構後半も足引っ張りそう。ただ、コードを含めて具体例もかなり掲載されてあるので、普段は雑誌やWebなんかのREST特集に定期的に目を通し、暇があったらこの本も読み返してみるか、なスタンスでもいいと思います。スケーラブルWebサイトも最初は原本読んでたときに読み進めるのに苦労しましたが、暇をみつけて読み返すうちに「あーこれ後で使えそう」な点も多かったので、そんな感じで良いのではないでしょうかね。</p>

<p>何はともあれ、RESTだけの話題でここまでてんこもりな本もなかなか無いので、買っておいて損はしないものだと思いました。☆４つくらいでしょうかね。</p>

<p>
<iframe src="http://rcm-jp.amazon.co.jp/e/cm?t=katsumatv-22&o=9&p=8&l=as1&asins=4873113539&fc1=000000&IS2=1&lt1=_blank&lc1=0000FF&bc1=000000&bg1=FFFFFF&f=ifr" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</p>
