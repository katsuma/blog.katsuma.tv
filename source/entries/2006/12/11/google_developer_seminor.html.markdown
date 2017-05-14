---
title: Google Developer Seminor
date: 2006/12/11 22:22:25
tags: develop
published: true

---

半蔵門で開かれた<a href="http://www.voice-research.com/google/presentations.html">Google Developer Seminor</a>に行ってきました。
内容はGoogle Maps, Google Gadgets, Google Desktop Gadgetの各APIの使い方。Google Maps APIは一度使ったことがあったものの、そのGadget系のAPIは全く触ったことがなかったので、仕事の小ネタ集めのためにも参加。

以下、簡単なメモです。




[ <a href="http://www.google.com/apis/maps/">GoogleMaps</a> ]
・versionは現在2.07
・ほぼ２週間ごとにバージョンアップされている
・script includeの際にバージョンを現行のものより上げてincludeさせるとpreview版(開発版)が利用できる
・逆に古いバージョンのものをいつでも利用できる
・商用利用は基本的にダメ。Enterprise版を利用する必要がある
・地図の移動において、UIの視点から１秒以上のパンはさせないようにしている
・Firebugを利用するとタイリングされている画像１枚１枚のimg srcを取得できる
・緯度、経度は実際の値から5mくらいズレているが、日々アップデートしている

[ <a href="http://code.google.com/apis/gadgets/">Google Gadgets</a> ]
・XML, HTML, JavaScriptで実装
・既存のWebページはそのままGadgetにできる
・Google Gadgetsはblogパーツなど、任意のページに貼り付けることが可能
・秘密のGadgetを作りたいときはGoogleの公開ディレクトリに入れない、というのもOK
・Googleに公開されるGadgetはGoogle側で動作チェックしているので、XSSの危険性などは（基本的には）無い
・プリファレンス情報はGoogleが持っている
・多言語化もXMLベースで簡単に実装可能

[ <a href="http://desktop.google.com/dev/index.html">Google Desktop Gadget</a> ]
・XML, HTML, JavaScriptで実装
・実体はzipアーカイブされたものを拡張子「gg」にしたもの
・大まかな点、実装上のポイントはGoogle Gadgetとほぼ同じ


Desktop GadgetはGoogle Gadgets(ページでは<a href="http://www.google.com/apis/gadgets/index.html">Universal Gadget</a>となっていますが、セッションではGoogle Gadgetsと総称されていました)に含まれると考えていいので、MapsとGoogle Gadgetsの２つがメイン。

Mapsはバージョンが知らない間に２に上がっていました。地図のフォントが1,2ヶ月前に変更されていたのには気づいてたのですが、その頃にAPIのバージョンが上がっていたのもかもしれません。また2週間ごとのAPIバージョンアップにも驚かされます。すでに今の状態でも成熟されてる感はあるのですが、まだまだ改良の余地はあるようです。

またGadgetsがBlogなど一般Webサイトでも利用できる、というのは初めて知りました。Blogパーツを自社サービスとして公開する際は、Desktop Gadgetにも簡単に移植できることを考えるとGoogle Gadgetsの形式で公開するのはかなり有効だと感じました。

で、早速<a href="http://looc.jp/?m=pc&a=page_h_pr&c=live4">Live4</a>のガジェットをテスト版として作ってみました。
<a href="http://blog.katsuma.tv/images/live4gg.jpg"><img alt="live4gg.jpg" src="http://blog.katsuma.tv/images/live4gg-thumb.jpg" width="400" height="240" /></a>
単体モジュールをHTMLで別途作ってあげると、Gadget化するには数行のXMLの中でHTMLをインクルードするだけでOKなのでかなり簡単です。もう少し直したい点もあるので、時期を見て正式に公開したいと思います。

で、最後にお土産のGoogleストラップもらってきました。
色は背景色が白、黒、青、赤、黄、緑とあったのですが、白が圧倒的人気。
僕も流れに乗って白を頂いてきましたよ。
<a href="http://blog.katsuma.tv/images/06121102.jpg"><img alt="06121102.jpg" src="http://blog.katsuma.tv/images/06121102-thumb.jpg" width="240" height="180" /></a>
