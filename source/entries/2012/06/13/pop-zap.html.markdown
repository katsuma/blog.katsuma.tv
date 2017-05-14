---
title: ネット上で話題になっている番組に自動的にTVのチャンネルを変えるpop-zap
date: 2012/06/13 02:57:09
tags: ruby
published: true

---

    <p>pop-zapというライブラリを作りました。</p>
    <p>
      <ul>
        <li><a href="https://github.com/katsuma/pop-zap">pop-zap</a></li>
      </ul>
    </p>

    <h3>これは何?</h3>
    <p>2ちゃんねるの実況板で話題になっているチャンネルに、TVのチャンネルを定期的に自動で切り替えるrubyスクリプトです。</p>
    <p>「<a href="http://tv2ch.nukos.net/">勝手に2ちゃんねる勢いグラフ</a>」さんのデータを参照させていただいて、その中から一番「勢い」がある(盛り上がっている)チャンネルを取得し、
      該当するTVのチャンネルを変更する信号を発信させています。チャンネル変更時はgrowlで再生する番組名とチャンネル名が表示され、内容がすぐに分かるようになっています。</p>
    <p>作った動機としては、iRemocon(後述)という面白ガジェットを手に入れたので、何かおもしろいものを作ってみたいなぁと思い、アレコレ遊んでいるうちに出来上がったものです。</p>

    <h3>使い方</h3>
    <p>こんなかんじで利用します。手元に落として、必要なgemをインストールして実行ですね。</p>
    <p><pre>
git clone git://github.com/katsuma/pop-zap.git
cd pop-zap
bundle install
bin/pop-zap</pre></p>

    <p>あと、こまかな設定もあるのですが、それについては最後の方で述べます。</p>

    <h3>iRecomonって何?</h3>
    <p>
      <a href="http://www.amazon.co.jp/gp/product/B0053BXBVG/ref=as_li_ss_il?ie=UTF8&tag=katsumatv-22&linkCode=as2&camp=247&creative=7399&creativeASIN=B0053BXBVG"><img border="0" src="http://ws.assoc-amazon.jp/widgets/q?_encoding=UTF8&Format=_SL160_&ASIN=B0053BXBVG&MarketPlace=JP&ID=AsinImage&WS=1&tag=katsumatv-22&ServiceVersion=20070822" ></a><img src="http://www.assoc-amazon.jp/e/ir?t=katsumatv-22&l=as2&o=9&a=B0053BXBVG" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

    </p>

    <p>さて、上でいきなりiRemoconと言っていたものは、いわゆる「学習リモコン」のIP対応版のガジェットです。<a href="http://i-remocon.com/">公式サイト</a>からの説明文を引用すると、</p>

    <p>
      <blockquote>
        <p>iRemoconはスマホから家のリモコン家電をコントロールできるようにするネットワーク接続型学習リモコン機器です。</p>
        <ul>
          <li>リモコン画面をWebから完全カスタマイズ可能</li>
          <li>外出先から自宅の家電をコントロール</li>
          <li>家電自動操作</li>
          <li>超協力広角赤外線LED内蔵</li>
        </ul>
      </blockquote>
    </p>

    <p>なんかの機能があります。</p>

    <p>さらにスマートフォン向けアプリがあるので、iPhoneやAndoridを学習リモコン化させることができ、
      家電のリモコンを全部携帯1台で集約させることができます。さらにリモコンのデザインも(頑張れば)自由に変更することができ、
      たとえば僕は電気、TV、エアコンを扱えるようにカスタマイズしています。<br />
      <a href="http://www.flickr.com/photos/katsuma/7180699905/" title="iRemocon by katsuma, on Flickr"><img src="http://farm8.staticflickr.com/7222/7180699905_cc40a6e7b2_n.jpg" width="213" height="320" alt="iRemocon"></a>
    </p>

    <p>使い方としては、ルータと接続し、通常の学習リモコンと同じように学習させたいボタンを順に押すだけです。
      構成を説明すると、最初にルータと直接有線LANで接続することで、DHCPサーバからIPアドレスが自動的に割り振られ、51013番ポートで信号を待ち受けます。
      その後、上記のスマホアプリなどからTCPで送りつけられた命令を受け取り、命令に該当する赤外線を発し、家電をコントロールする、という流れになります。</p>

    <p>さらに、このiRemoconの面白い点として、<a href="http://i-remocon.com/development/">開発者向けのAPI</a>が公開されている点です。
      APIといっても簡単な仕様で、基本的には</p>

    <p>
      <pre>
*ic;{channel_id}\r\n   # リモコンを学習させる
*is;{channel_id}\r\n   # 赤外線を発光させる</pre>
    </p>

    <p>だけ覚えておくと十分に遊べます。たとえば僕は、channel_id=1201をNHK総合、1202をNHK教育、1204を日本テレビ...のように、「1200 + 普通のテレビのチャンネル」を
      iRemoconのIDに学習させています。なので、たとえばTVを利用しながらターミナルから
    </p>

    <p>
      <pre>
telnet 192.168.0.9 51013
Connected to 192.168.0.9.
Escape character is '^]'. </pre>
    </p>
    <p>と、接続したあと、</p>

    <p><pre>
*is;1204</pre></p>
    <p>と入力すると</p>
    <p>
      <pre>
is;ok</pre>
</p>

    <p>と、返答がかえってきて、チャンネルを変更することができます。</p>
    <p>pop-zapも基本的にこのAPIを利用してチャンネルを変更しているので、confディレクトリ以下の設定ファイルをご自宅の環境にあわせて書き換えれば、すぐに利用することが可能です。</p>

    <p>1つ注意することとして、iRemoconは同時に1つの接続しか受け付けられないので、1つのターミナルでセッションを張りっぱなしにしていると、別のセッションを張ることができません。なので、命令を送るたびに接続を張り直すか、接続を適切に使い回す必要があります。</p>

    <h3>まとめ</h3>
    <p>TCPで命令を送ることで自由に家電を操作できるiRemoconを利用して、TVをよりインターネットとの親和性を高め、より受動的なメディアにさせるpop-zapというライブラリを作りました。
      自分の意思を無視して勝手にどんどんチャンネルが変わる世界はなかなか新鮮です。
    </p>
    <p>
      また、iRemoconはここ最近見たガジェット中でも抜群に自由度が高くて面白いガジェットだと思います。
      家電がゼロアクションで自発的に動作する世界はなかなか夢があっておもしろいですよね。
      ほかの技術と組み合わせることでもっともっといろんなことが可能になると思うので、しばらく可能性を掘ってみたいと思います。</p>

    <p>
      <iframe src="http://rcm-jp.amazon.co.jp/e/cm?lt1=_blank&bc1=000000&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=katsumatv-22&o=9&p=8&l=as4&m=amazon&f=ifr&ref=ss_til&asins=B0053BXBVG" style="width:120px;height:240px;" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
    </p>


