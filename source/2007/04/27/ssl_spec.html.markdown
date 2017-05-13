---
title: SSL証明書発行会社比較
date: 2007/04/27
tags: develop
published: true

---

<p>
SSL証明書について調査してみました。今更ながら初めて知ることも結構あったり。EV SSLとか正直知らなかったよ。久方ぶりの調査内容は、せっかくなのでまとめなおしてみたいと思います。全部Webをクロールすれば分かることなのですが、なかなかこういう情報ってまとまってないものですし。
以下、個人的なメモ含の備忘録です。
</p>

<p>(*) 主観的な情報はほぼ排除してWebから分かる客観的な事実のみをまとめています。「で、結局どうよ？」な話はまた別で。。</p>

<p>
  memo
</p>
<ul>
  <li>
    SGC(Server Gated Cryptography)
  </li>
  <ul>
    <li>
      古いブラウザでアクセスしたとき（40bit暗号しか対応していないとき）強制的に128bit暗号にする技術
    </li>
    <li>
      VeriSign、またはVeriSign傘下の会社のみが発行できる(?)
    </li>
    <li>
      下の調査会社の中ではVeriSign、thawteが対応
    </li>
  </ul>
  <li>
    <p>
      EV SSL
    </p>
  </li>
  <ul>
    <li>
      企業の実在性をより確実に認証する証明書
    </li>
    <li>
      ブラウザによっては緑色のアドレスバーによって、サイトを訪れたユーザにウェブサイトのセキュリティを示す。
    </li>
    <ul>
      <li>
        IE7は対応
      </li>
      <li>
        Firefoxは3.0から対応予定
      </li>
      <li>
        Operaは認証局や運営組織については表示される。アドレスバーの色表示などは検討中
      </li>
    </ul>
  </ul>
  <li>
    証明書インストール方法
  </li>
  <ul>
    <li>
      http://www.securestage.com/jp/advanced/installation.php
    </li>
  </ul>
  <li>
    シングルルートSSL
  </li>
  <ul>
    <li>
      中間証明書が不要なもの
    </li>
  </ul>
</ul>

<ul>
  <li>
    ルート証明書じゃないところからのサーバ証明書を入れたときの弊害
  </li>
  <ul>
    <li>
      http://www.nanashinonozomi.com/tdiary/20060503.html
    </li>
    <li>
      http://www.geotrust.co.jp/ssl/ssl_select.html
    </li>
    <li>
      要するに中途半端な機関から証明書を入手すると、かえってメンテ面倒。メンテコストがかかる
    </li>
  </ul>
  <li>
    携帯のSSL対応は？
  </li>
  <ul>
    <li>
      各キャリアのSSL対応について
    </li>
    <ul>
      <li>
        NTT DoCoMo　<a target="_blank" href="http://www.nttdocomo.co.jp/service/imode/make/content/ssl/spec/">http://www.nttdocomo.co.jp/service/imode/make/content/ssl/spec/</a>
        </li>
      <li>
        au by KDDI
        <a target="_blank" href="http://www.au.kddi.com/ezfactory/tec/spec/ssl.html">http://www.au.kddi.com/ezfactory/tec/spec/ssl.html</a>
      </li>
      <li>
        SoftBank
        <a target="_blank" href="http://developers.softbankmobile.co.jp/dp/tech_svc/web/ssl.php">http://developers.softbankmobile.co.jp/dp/tech_svc/web/ssl.php</a>
      </li>
    </ul>
  </ul>
</ul>
<p>
  調査会社
</p>
<ul>
  <li>
    w3lab
  </li>
  <li>
    thawte
  </li>
  <li>
    GeoTrust
  </li>
  <li>
    VeriSign
  </li>
</ul>
<h3>
  w3lab
</h3>
<ul>
  <li>
    <p>
      http://w3lab.org/
    </p>
  </li>
  <li>
    要点
  </li>
  <ul>
    <li>
      NetworkSolution傘下
    </li>
    <li>
      GwoTrustの証明書も扱っている
    </li>
    <li>
      NetworkSolutionの中間証明書が必要
    </li>
    <ul>
      <li>
        http://w3lab.org/cert/question.html#52
      </li>
    </ul>
  </ul>
  <li>
    対応ブラウザ
  </li>
  <ul>
    <li>
      99%以上（らしい）
    </li>
    <li>
      http://w3lab.org/cert/question.html#09
    </li>
    <ul>
      <li>
        Internet Explorer 5.00 以上
      </li>
      <li>
        Netscape 4x 以上
      </li>
      <li>
        AOL 5 and 以上
      </li>
      <li>
        Opera 5 以上
      </li>
      <li>
        Firefox 1.1 以上
      </li>
      <li>
        Safari (Mac OS 8.5 以上)
      </li>
    </ul>
  </ul>
  <li>
    対応携帯
  </li>
  <ul>
    <li>
      見つからなかったので不明
    </li>
  </ul>
  <li>
    主要プラン
  </li>
  <ul>
    <li>
      Secure Link SSL BASIC
    </li>
    <ul>
      <li>
        http://w3lab.org/cert/content.php?ssl=01
      </li>
    </ul>
    <ul>
      <li>
        鍵長128bit
      </li>
      <li>
        1年:17,600円
      </li>
      <li>
        2年:28,000円
      </li>
      <li>
        実在証明あり
      </li>
      <li>
        セキュアなオンライン取引（量・金額）が少なめなウェブサイト
      </li>
      <li>
        総額 5万ドル（1件当たり千ドル）までの補償
      </li>
    </ul>
    <li>
      Secure Link SSL PRO
    </li>
    <ul>
      <li>
        http://w3lab.org/cert/content.php?ssl=11
      </li>
      <li>
        鍵長:128bit
      </li>
      <li>
        1年:24,800円
      </li>
      <li>
        2年:38,400円
      </li>
      <li>
        実在証明あり
      </li>
      <li>
        セキュアなオンライン取引（量・金額）が中～高程度のウェブサイト、イントラネット、エクストラネットを対象
      </li>
      <li>
        総額 100万ドル（1件当たり千ドル）までの補償
      </li>
    </ul>
  </ul>
</ul>
<h3>
  thawte
</h3>
<ul>
  <li>
    http://www.jp.thawte.com/
  </li>
</ul>
<ul>
  <li>
    要点
  </li>
  <ul>
    <li>
      中間証明書のインストールが必要
    </li>
  </ul>
  <li>
    対応ブラウザ（最上位プランのみ）
  </li>
  <ul>
    <li>
      http://www.thawte.com/ssl-digital-certificates/technical-support/browsers.html
    </li>
    <li>
      WinXP, WinNT4.0, 2000, 2003(IE6, 5)
    </li>
    <li>
      全OSのFirefox0.8 1.x(2.0がないのは大丈夫？)
    </li>
    <li>
      Win, MacのOpera3.x, 5.x, 6.x, 7.x
    </li>
  </ul>
  <li>
    対応携帯
  </li>
  <ul>
    <li>
      http://www.jp.thawte.com/faq/60004.html
    </li>
    <li>
      詳細は結構不明
    </li>
    <li>
      最上位プランのSGC SuperCertsだとほぼ問題ない模様
    </li>
    <ul>
      <li>
        http://www.jp.thawte.com/faq/10015.html
      </li>
    </ul>
  </ul>
  <li>
    主要プラン
  </li>
  <ul>
    <li>
      SGC Super Certs
    </li>
    <ul>
      <li>
        http://www.jp.thawte.com/sgc/index.html
      </li>
    </ul>
    <ul>
      <li>
        鍵長:<font size="2">128bit </font>
      </li>
      <li>
        2年：$849
      </li>
      <li>
        1年：$449
      </li>
    </ul>
    <li>
      SSL Certs (団体名が証明書に入る。実在確認される)
    </li>
    <ul>
      <li>
        http://www.jp.thawte.com/ssl/index.html
      </li>
    </ul>
    <ul>
      <li>
        <font size="2">鍵長:40bit以上, 128bit</font>
      </li>
      <li>
        2年：$349
      </li>
      <li>
        1年：$199
      </li>
    </ul>
    <li>
      SSL 123 Certs(団体名が証明書に入らない)
    </li>
    <ul>
      <li>
        http://www.jp.thawte.com/123/index.html
      </li>
    </ul>
    <ul>
      <li>
        <font size="2">鍵長:40bit以上, 128bit
        </font>
      </li>
      <li>
        2年：$259
      </li>
      <li>
        1年：$149
      </li>
    </ul>
  </ul>
</ul>
<p>
  GeoTrust
</p>
<ul>
  <li>
    http://www.geotrust.co.jp/
  </li>
  <li>
    要点
  </li>
  <ul>
    <li>
      全プラン、中間証明書のインストールは不要
    </li>
  </ul>
  <li>
    対応プラットフォーム
  </li>
  <ul>
    <li>
      http://www.securestage.com/jp/information/details.php
    </li>
    <ul>
      <li>
        Apache + ApacheSSL
      </li>
      <li>
        Apache + MODSSL
      </li>
      <li>
        Apache + OpenSSL
      </li>
      <li>
        Apache + Raven
      </li>
      <li>
        Apache + SSLeay
      </li>
      <li>
        Apache 2.x
      </li>
      <li>
        それ以外も結構ある
      </li>
    </ul>
  </ul>
  <li>
    対応ブラウザ
  </li>
  <ul>
    <li>
      Microsoft Internet Explorer 5.01+
    </li>
    <li>
      Microsoft Internet Explorer 6.x
    </li>
    <li>
      Netscape Navigator 4.51x
    </li>
    <li>
      Netscape Navigator 6.x
    </li>
    <li>
      Apple Safari
    </li>
    <li>
      Sun JVM 1.4.2_02以降
    </li>
    <li>
      AOL Browser 6.x
    </li>
    <li>
      AOL Browser 7.x
    </li>
    <li>
      AOL Browser 8.x
    </li>
    <li>
      Opera 7
    </li>
    <li>
      Pocket PC 2003
    </li>
  </ul>
  <li>
    対応携帯
  </li>
  <ul>
    <li>
      DoCoMo i-Mode について
    </li>
    <ul>
      <li>
        FOMA 901i/700i以降
      </li>
    </ul>
    <li>
      au EZweb について
    </li>
    <ul>
      <li>
        W31T以降(PENCK,W31CA,W32Kを除く)、A5509T以降 (Sweetsを除く)
      </li>
    </ul>
    <li>
      SoftBank Mobile について
    </li>
    <ul>
      <li>
        905SH以降(904T,804N,803Tを除く)のSoftBankブランドの3Gモデル
      </li>
    </ul>
    <li>
      WILLCOM について
    </li>
    <ul>
      <li>
        WX310SA,WX310J,WS009KE,WS003SH,WS004SH,WS007SH
      </li>
    </ul>
    <li>
      その他のモバイルブラウザNetfront 3.0 以上
    </li>
    <ul>
      <li>
        Opera 7.0 以上
      </li>
      <li>
        Palm / Handspring Blazer 2.0 以上
      </li>
      <li>
        Microsoft Windows CE 2003
      </li>
      <li>
        Microsoft Internet Explorer Pocket PC 2003
      </li>
      <li>
        Microsoft Internet Explorer Smartphone 2003
      </li>
      <li>
        Blackberry 4.0 以上
      </li>
      <li>
        AT&T
      </li>
      <li>
        Sony Playstation Portable
      </li>
      <li>
        Sony Netjuke audio
      </li>
      <li>
        Brew
      </li>
      <li>
        Openwave
      </li>
    </ul>
  </ul>
  <li>
    主要プラン
  </li>
  <ul>
    <li>
      トゥルービジネスID（企業実在証明付き）
    </li>
    <ul>
      <li>
        http://www.geotrust.co.jp/ssl_products/index.html
      </li>
      <li>
        鍵長:128, 256bit
      </li>
    </ul>
    <ul>
      <li>
        2年:125,580円
      </li>
      <li>
        1年:62,790円
      </li>
    </ul>
    <li>
      クイックSSLプレミアム(企業実在証明書なし)
    </li>
    <ul>
      <li>
        http://www.geotrust.co.jp/ssl_products/q_ssl.html
      </li>
      <li>
        鍵長:128, 256bit
      </li>
    </ul>
    <ul>
      <li>
        2年:73,080円
      </li>
      <li>
        1年:36,540円
      </li>
    </ul>
  </ul>
</ul>
<h3>
  VeriSign
</h3>
<ul>
  <li>
    http://www.verisign.co.jp/index.html
  </li>
  <li>
    要点
  </li>
  <ul>
    <li>
      EV証明書にも対応
    </li>
    <ul>
      <li>
        携帯が対応できていないところもちょくちょくあるみたい
      </li>
      <li>
        IE7だと見え方が変わってくる
      </li>
      <li>
        http://www.verisign.co.jp/server/products/ev_ssl/index.html
      </li>
    </ul>
  </ul>
  <li>
    対応ブラウザ
  </li>
  <ul>
    <li>
      Netscape Navigator 4.7 - 4.78、7.X
    </li>
    <li>
      Internet Explorer（Windows版）5.01以降
    </li>
    <li>
      Firefox1.0.6以降
    </li>
    <li>
      Safari2.0
    </li>
    <li>
      （MacIEが入ってないのは、まぁいいかなぁ。Operaが推奨ブラウザに入っていないのは気になる）
    </li>

  </ul>
  <li>
    対応携帯
  </li>
  <ul>
    <li>
      http://www.verisign.co.jp/server/about/client.html
    </li>
    <li>
      検証データが「2003年9月」って若干情報が古い気も。。
    </li>
    <ul>
      <li>
        DoCoMo
      </li>
      <ul>
        <li>
          503i 以降 (504i,505i,506i,他)
        </li>
        <li>
          210 以降 (211i,212i,251i,651i,252i,他）
        </li>
        <li>
          FOMA端末 (900i,2102v,2701,2051,他）
        </li>
      </ul>
      <li>
        KDDI(au)
      </li>
      <ul>
        <li>
          HDMLブラウザ搭載端末
        </li>
        <ul>
          <li>
            au(A1000/C1000/C400/C300/C200,他)
          </li>
          <li>
            ツーカー
          </li>
        </ul>
        <li>
          WAP2.0ブラウザ搭載端末
        </li>


<ul>
          <li>
            Wシリーズ(W01K除)/INFOBAR/A5000/C5000/A3000/C3000/A1400/A1300/A1100,他)
          </li>
</ul>
</ul>
      <li>
        Softbank
      </li>
      <ul>
        <li>
          C2，C3，C4端末
        </li>
        <ul>
          <li>
            (V401T,V303T,J-T010,J-T08,DN02,P02,SA02,SH03,T04,他)
          </li>
        </ul>
        <li>
          P4, 5型
        </li>
        <ul>
          <li>
            (J-SH51,J-K51,J-T51,J-P51,J-SA51,J-SH52,J-N51,J-SH53,他)
          </li>
        </ul>
      </ul>
    </ul>
  </ul>
  <li>
    主要プラン
  </li>
  <ul>
    <li>
      セキュアサーバID
    </li>

    <ul>
      <li>
        http://www.verisign.co.jp/server/products/sidh_1_2_a.html
      </li>
      <li>
        鍵長:128, 256bit(環境によって40,56bit)
      </li>
      <li>
        1年:85,000円
      </li>
      <li>
        2年:148,500円
      </li>
    </ul>
    <li>
      グローバル・サーバID
    </li>
    <ul>
      <li>
        http://www.verisign.co.jp/server/products/sidh_1_2_b.html
      </li>
      <li>
        鍵長:128, 256bit
      </li>
      <li>
        1年:144,900円
      </li>
      <li>
        2年:252,000円
      </li>
      <li>
        SGC対応なので確実に128bit以上の暗号を保証
      </li>
    </ul>
  </ul>
</ul>
