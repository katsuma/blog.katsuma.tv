---
title: Key-Value Store勉強会に行ってきました
date: 2009/02/21 02:49:04
tags: develop
published: true

---

<p><a href="http://gree.jp/">gree</a>さんで開催されたKey Value Store勉強会に行ってきました。</p>

<p>時間にして4時間超え、内容も国内のKey-Value Storeなソフトウェアの最前線の話ばかりで相当なボリューム。以下、メモってたのを残しておきたいと思います。（誤字、脱字、内容に誤りを含むものなどありましたらお伝えください）また、発表者の方やプロダクトについて、ざっくり調べてURL見つけられたものについてはリンク張っています。
</p>

<h3>
  森さん / <a title="末永さん" href="http://d.hatena.ne.jp/tasukuchan/" id="y2ma">末永さん</a> &nbsp;
</h3>
<ul>
  <li>
    <a href="http://groonga.org/" id="mxkg" title="groonga">groonga</a>
  </li>
  
<ul>
    <li>
      Sennaの後継エンジン
    </li>
    
<ul>
      <li>
        融通が効かないのがSennaのデメリット
      </li>
    </ul>
    <li>
      スコア算出式のカスタマイズなど
    </li>
    <li>
      Sennaの転置索引
    </li>
    <li>
      索引の構成部品を自由に組み合わせて使える
    </li>
    <li>
      APIもいろいろ
    </li>
    
<ul>
      <li>
        QL
      </li>
      <li>
        DB
      </li>
      <li>
        Low Level
      </li>
    </ul>
    <li>
      memcached互換のkey-value store
    </li>
    <li>
      バイナリのみ対応
    </li>
    
<ul>
      <li>
        計測
      </li>
      
<ul>
        <li>
          クライアント　memstorm-0.6.8
        </li>
        <li>
          memcachedと同じくらいの性能
        </li>
        <li>
          valueサイズが小さいとほとんどかわらない
        </li>
        <li>
          valueサイズが大きくなると少しパフォーマンス悪くなる
        </li>
      </ul>
    </ul>
    <li>
      DB的な使い方もできる
    </li>
    
<ul>
      <li>
        Scheme以外の言語バインディングもできる（はず
      </li>
    </ul>
    <li>
      名前の由来
    </li>
    
<ul>
      <li>
        ブルース音楽の発祥地（？
      </li>
    </ul>
    <li>
      Sennaともあんましかわらない（はず
    </li>
  </ul>
</ul>
<h3>
  山田浩之さん (LuxIO)
</h3>
<ul>
  <li>
    IBM, Yahoo, MetaCast
  </li>
  <li>
    <a title="LuxIO" href="http://luxse.sourceforge.net/" id="lqr_">LuxIO</a> (ラックスIO)
  </li>
  
<ul>
    <li>
      データベースマネージャ
    </li>
    
<ul>
      <li>
        C++
      </li>
      <li>
        B+tree,
      </li>
    </ul>
    <li>
      分散はなし
    </li>
  </ul>
  <li>
    ほかに不得意なことがすこし得意
  </li>
  <li>
    分散検索エンジンLuxの内部データベースとして開発
  </li>
  <li>
    普通のB+-tree
  </li>
  <li>
    特徴1
  </li>
  
<ul>
    <li>
      mapped index
    </li>
    <li>
      index部を全部mmap
    </li>
    
<ul>
      <li>
        index部を実メモリより小さいシステムが対象
      </li>
    </ul>
  </ul>
  <li>
    特徴2
  </li>
  
<ul>
    <li>
      長いvalue
    </li>
    <li>
      4Gまで
    </li>
    <li>
      node size(page size)をこえたvalueも余計なオーバーヘッドなしで扱える
    </li>
  </ul>
  <li>
    特徴3
  </li>
  
<ul>
    <li>
      効率的なappend
    </li>
    <li>
      paddingなしでLinkedListのデータ構造
    </li>
  </ul>
  <li>
    SSDに向いてる？
  </li>
  <li>
    使い道
  </li>
  
<ul>
    <li>
      key-valともに小さいデータで構想なアクセスが必要な場合
    </li>
    <li>
      実メモリ以下のデータベースという制約あり
    </li>
    <li>
      大きなvalueを扱いたい場合
    </li>
    <li>
      大きなvalueをどんどん追記したい
    </li>
  </ul>
  <li>
    向かない処理
  </li>
  
<ul>
    <li>
      削除が多い処理
    </li>
    <li>
      小さいデータをたくさんリンク
    </li>
    
<ul>
      <li>
        seekのオーバーヘッドが大きすぎる
      </li>
    </ul>
    <li>
      Read,Writeの激しいアプリ
    </li>
  </ul>
  <li>
    分散はたぶんしない
  </li>
  <li>
    Hashはつくるかも
  </li>
  <li>
    read lockはなくしたい
  </li>
  
<ul>
    <li>
      読み込みを重きをおく
    </li>
  </ul>
  <li>
    単純に作ってみたかった
  </li>
  <li>
    名前の由来
  </li>
  
<ul>
    <li>
      リッチな検索エンジン
    </li>
    <li>
      某シャンプーからとった（←ウケた
    </li>
  </ul>
</ul>
<h3>
  <a title="平林さん" href="http://qdbm.sourceforge.net/mikio/" id="a4z5">平林さん</a>  (TokyoCabinet / TokyoTyrant)
</h3>
<div>
  
<ul>
    <li>
      <a title="Tokyo-Cabinet" href="http://tokyocabinet.sourceforge.net/" id="bpwi">Tokyo-Cabinet</a> の歴史
    </li>
    <li>
      全文検索システムSnatcher
    </li>
    
<ul>
      <li>
        Namazu、スニペットつき
      </li>
      <li>
        GDBMをベースにした転置インデックス
      </li>
    </ul>
    <li>
      計量データベースライブラリQDBM
    </li>
    
<ul>
      <li>
        cat mode, B+木対応のGDBM
      </li>
    </ul>
    <li>
      全文検索システム　Estraier
    </li>
    <li>
      全文検索システム　HyperEstraier
    </li>
    <li>
      mixiの検索機能
    </li>
    
<ul>
      <li>
        外部システムからHEベースへ
      </li>
      <li>
        この成長ペースだと破綻するのは必須。。。
      </li>
    </ul>
    <li>
      Tokyo Cabinet
    </li>
    
<ul>
      <li>
        モダンなQDBM
      </li>
      
<ul>
        <li>
          C99, Pthread, mmap pread/pwrite...
        </li>
        <li>
          win32互換を破棄
        </li>
      </ul>
      <li>
        でも検索機能にはあんまり使ってない
      </li>
      
<ul>
        <li>
          HEからTokyo Dystopiaにおきかえたもの
        </li>
        <li>
          主にデータマイニングで利用
        </li>
        <li>
          HWのスペックあがってきててメモリ豊富なマシンでうごかせばHEのままでいい
        </li>
      </ul>
    </ul>
    <li>
      ハッシュデータベース
    </li>
    
<ul>
      <li>
        static hashingによる単純化
      </li>
    </ul>
    <li>
      データフォーマットの効率化
    </li>
    
<ul>
      <li>
        BER圧縮、アラインメントとビットシフト
      </li>
    </ul>
    <li>
      フリーブロックプール
    </li>
    
<ul>
      <li>
        ベストフィットアロケーション
      </li>
    </ul>
    <li>
      メモリにのればmmap, それ以外はpread
    </li>
    <li>
      ページキャッシュとBTree索引
    </li>
    
<ul>
      <li>
        LRU削除キャッシュ
      </li>
    </ul>
    <li>
      多機能
    </li>
    
<ul>
      <li>
        順序を維持、カスタム比較関数
      </li>
      <li>
        範囲検索、カーソル
      </li>
    </ul>
    <li>
      Trick
    </li>
    
<ul>
      <li>
        格納時にページ単位で圧縮可能
      </li>
      <li>
        投機的探索
      </li>
      <li>
        並列性はテーブル全体のrwrite
      </li>
    </ul>
    <li>
      そのほか
    </li>
    
<ul>
      <li>
        レコードに複数のカラム
      </li>
      <li>
        スキーマ不要
      </li>
      <li>
        250万qps
      </li>
    </ul>
    <li>
      <a title="Tokyo Tyrant" href="http://tokyocabinet.sourceforge.net/tyrantpkg/" id="laug">Tokyo Tyrant</a> </li>
    
<ul>
      <li>
        TCのネットワーク対応
      </li>
      
<ul>
        <li>
          ローカルのマルチプロセスでもDB共有に利用
        </li>
      </ul>
      <li>
        並列化
      </li>
      
<ul>
        <li>
          スレッドプール
        </li>
        <li>
          epoll. kqueue, evenports利用
        </li>
      </ul>
      <li>
        各種プロトコル
      </li>
      
<ul>
        <li>
          独自バイナリ、memcached互換、HTTP互換
        </li>
      </ul>
      <li>
        抽象データベース
      </li>
      <li>
        60000qps
      </li>
      <li>
        これから
      </li>
      
<ul>
        <li>
          並列分散処理の時代？
        </li>
        <li>
          TC/TTは１台あたりのスループットを最大化する技術
        </li>
        <li>
          １台あたりでできることは増えてる
        </li>
      </ul>
    </ul>
  </ul>
  
<h3>
    <a title="岡野原さん" href="http://www-tsujii.is.s.u-tokyo.ac.jp/members/wiki/wiki.cgi?page=%B2%AC%CC%EE%B8%B6%C2%E7%CA%E5" id="yhsf">岡野原さん</a> (Key-valueの効率的格納)
  </h3>
</div>
<div>
  
<ul>
    <li>
      興味分野
    </li>
    
<ul>
      <li>
        データ圧縮、自然言語処理、全文検索
      </li>
    </ul>
    <li>
      文字列のキーを利用していろんな値を格納したい
    </li>
    <li>
      方法１
    </li>
    
<ul>
      <li>
        木による格納
      </li>
      <li>
        キーに対してtrieなどの木構造を構築し、木の接点、葉に値を格納など
      </li>
    </ul>
    <li>
      方法２
    </li>
    
<ul>
      <li>
        ハッシュによる格納
      </li>
    </ul>
    <li>
      木によるキーの格納
    </li>
    
<ul>
      <li>
        各枝に文字が付随、つなげるとキー
      </li>
      <li>
        値は接点の先
      </li>
    </ul>
    <li>
      <a title="tx" href="http://www-tsujii.is.s.u-tokyo.ac.jp/%7Ehillbig/tx-j.htm" id="m1.s">tx</a> : <del>木の簡潔h町減による</del>木の簡潔な表現によるtrieライブラリ(09/02/22 修正。thx myuiさん)
    </li>
    
<ul>
      <li>
        キー集合をコンパクトに格納し操作可能
      </li>
      <li>
        元のサイズの約1/2 で格納
      </li>
      <li>
        10億くらいのキーでものる
      </li>
      <li>
        select, rankの組み合わせで定数時間で探索可能
      </li>
    </ul>
    <li>
      ハッシュ
    </li>
    
<ul>
      <li>
        Cuckoo Hashing
      </li>
      <li>
        1から作り直す確率は非常に低い
      </li>
      <li>
        全体の平均計算量はキーの線形倍で
      </li>
    </ul>
  </ul>
  
<h3>
    <a title="前坂さん" href="http://torum.net/" id="qpi:">前坂さん</a> 
  </h3>
  
<ul>
    <li>
      mixi, R&amp;D
    </li>
    <li>
      memcached
    </li>
    
<ul>
      <li>
        LRU
      </li>
    </ul>
    <li>
      最近はARCアルゴリズムがあつい？？
    </li>
    
<ul>
      <li>
        Patentされてる
      </li>
    </ul>
    <li>
      Key/Value,
    </li>
    
<ul>
      <li>
        Value=Object
      </li>
      <li>
        1MB以内なら何でも扱える
      </li>
    </ul>
    <li>
      RDBMSもキャッシュできるよ！
    </li>
    
<ul>
      <li>
        MySQL
      </li>
      
<ul>
        <li>
          QueryCache
        </li>
      </ul>
      <li>
        採用するには厳しい理由
      </li>
      
<ul>
        <li>
          オブジェクトの粒度をコンとトールできない
        </li>
        <li>
          テーブル更新でデータがinvalidate
        </li>
        <li>
          マシンをこえたメモリ容量がつかえない
        </li>
        <li>
          フラグメントが発生しやすい
        </li>
        <li>
          キャッシュを共有できない
        </li>
        <li>
          ロードバランサは？
        </li>
        <li>
          一貫性のないキャッシュ配布
        </li>
      </ul>
    </ul>
    <li>
      Facebook
    </li>
    
<ul>
      <li>
        28TB
      </li>
      <li>
        独自の改良
      </li>
      <li>
        Shared Buffer Pool
      </li>
      <li>
        Stats Global Lock&nbsp;&nbsp;の除去
      </li>
      <li>
        TCPからUDPへの移行（cacheだし）
      </li>
      <li>
        通信パケットのバッチ
      </li>
      <li>
        秒間20万クエリ(!!!!←すごい)
      </li>
      <li>
        変更しすぎたのでとりこまれなかった
      </li>
      
<ul>
        <li>
          一部はとりこまれる予定
        </li>
      </ul>
    </ul>
    <li>
      最近の話
    </li>
    
<ul>
      <li>
        バイナリプロトコルでno-replyが加わった
      </li>
      <li>
        エラーはかえす
      </li>
      <li>
        CASに固定で8byteもわりあてていいの？
      </li>
      
<ul>
        <li>
          <a title="http://tinyurl.com/more-space" href="http://tinyurl.com/more-space" id="qpw4">http://tinyurl.com/more-space</a> </li>
      </ul>
    </ul>
    <li>
      11211はmemcachedのポートとして公式に決定された
    </li>
  </ul>
  
<h3>
    安井さん(<a title="repcached" href="http://lab.klab.org/wiki/Repcached" id="tcmm">repcached</a> のなかみ)
  </h3>
  
<ul>
    <li>
      KLabの方
    </li>
    <li>
      memcacpedにレプリケーション機能をつけたもの
    </li>
    <li>
      案1 マルチスレッド
    </li>
    
<ul>
      <li>
        スレッド作成
      </li>
      <li>
        キューをつくってセットされたデータを入れる
      </li>
      <li>
        メリット
      </li>
      
<ul>
        <li>
          本体への影響がすくなそう
        </li>
        <li>
          比較的簡単
        </li>
      </ul>
      <li>
        ただし、、
      </li>
      
<ul>
        <li>
          アクセス数が多いときに問題発生
        </li>
        <li>
          忙しいときにレプリケーション処理が追いつかない
        </li>
        <li>
          キューがあふれる
        </li>
        <li>
          memcachedのレスポンスが悪くなる
        </li>
      </ul>
    </ul>
    <li>
      案2　シングルスレッド
    </li>
    
<ul>
      <li>
        libeventを利用
      </li>
      <li>
        ハンドラを登録しておくとコールバックしてくれる
      </li>
      <li>
        自分でselect(2), poll(2)とかしなくていいのでらくちん
      </li>
      <li>
        set/addのついでにrepl
      </li>
      
<ul>
        <li>
          プロトコルの処理中にレプる必要
        </li>
        <li>
          どうしても応答時間が長くなる
        </li>
      </ul>
    </ul>
    <li>
      案3 Pipeにキーを書き込むように変更
    </li>
    
<ul>
      <li>
        だいぶよくなった
      </li>
      <li>
        やっぱりリクエストが多くなれば素のパフォーマンスよりもすこし悪くなる
      </li>
    </ul>
    <li>
      今のところ２台までの構成
    </li>
    
<ul>
      <li>
        １台だけレプリケーション？
      </li>
      <li>
        ３台使わないといけないシチュエーションがまだない
      </li>
    </ul>
    <li>
      利用用途
    </li>
    
<ul>
      <li>
        PHPのセッション管理
      </li>
      <li>
        某SNSのアバターの着せ替え機能のセッションなど
      </li>
      
<ul>
        <li>
          OKおすまで
        </li>
      </ul>
    </ul>
  </ul>
  
<h3>
    <a title="たけまるさん" href="http://teahut.sakura.ne.jp/b/" id="ne4b">たけまるさん</a> </h3>
  
<ul>
    
    <li>
      <a title="Kai" href="http://teahut.sakura.ne.jp/b/2008-05-13-1.html" id="uxwb">Kai</a>  = Dynamo + memcached API / Erlang
    </li>
    <li>
      Dynamoの特徴
    </li>
    
<ul>
      <li>
        amazonの裏
      </li>
      <li>
        分散したkey-val
      </li>
      <li>
        高い分散透過性
      </li>
      <li>
        ショッピングカートでも使われてるらしい
      </li>
      <li>
        高い可用性
      </li>
      
<ul>
        <li>
          ロックなし、いつでもかきこめる
        </li>
        <li>
          Eventually Consistant
        </li>
        
<ul>
          <li>
            3レプリカ
          </li>
          <li>
            Consistent Hashingで選択
          </li>
          
<ul>
            <li>
              ベクトルタイムスタンプを比較
            </li>
            <li>
              古いデータを上書き
            </li>
          </ul>
          <li>
            結果的に整合性がとれる
          </li>
        </ul>
      </ul>
      <li>
        分散透過性
      </li>
      
<ul>
        <li>
          分散していることの隠蔽
        </li>
        
<ul>
          <li>
            P2P
          </li>
        </ul>
        <li>
          透過性が高いと管理コストが低下
        </li>
        <li>
          場所、移動、障害
        </li>
      </ul>
      <li>
        memcachedのAPIだけだとすこし不十分、、、
      </li>
      
<ul>
        <li>
          なんだけども、とりあえずサポート
        </li>
      </ul>
      <li>
        Erlangの使いどころ
      </li>
      
<ul>
        <li>
          分散システムの適している
        </li>
        <li>
          アクターモデルが便利
        </li>
        
<ul>
          <li>
            共有メモリがなく安全
          </li>
          <li>
            プロセスが軽い
          </li>
          <li>
            Copy on write的にメッセージングパッシングを効率化
          </li>
        </ul>
        <li>
          そこそこ速い
        </li>
        
<ul>
          <li>
            Java未満、LL以上
          </li>
        </ul>
        <li>
          弱点は正規表現がだめ
        </li>
      </ul>
    </ul>
    <li>
      Kai
    </li>
    
<ul>
      <li>
        Dynamo + memcached API / Erlang実装
      </li>
      <li>
        開発者の本籍地から命名
      </li>
      
<ul>
        <li>
          検索しにくい。。
        </li>
      </ul>
      <li>
        Kaiの性能
      </li>
      
<ul>
        <li>
          約10000 qps
        </li>
      </ul>
      <li>
        Erlangの備え付けのストレージがボトルネックっぽい
      </li>
      
<ul>
        <li>
          TCとか使えばいい？
        </li>
      </ul>
      <li>
        某ポータルサイトで試験中らしい
      </li>
    </ul>
  </ul>
  
<h3>
    <a title="上野さん" href="http://d.hatena.ne.jp/nyaxt/" id="u5f9">上野さん</a> （分散メディアストレージ的ななにか）
  </h3>
  
<ul>
    <li>
      株式会社Fillotの方
    </li>
    <li>
      配信をメインターゲット
    </li>
    <li>
      ブロードバンドメディアの配信基盤
    </li>
    <li>
      Cagra
    </li>
    
<ul>
      <li>
        1000 speakers confで古橋さんとペアプロでつくった
      </li>
      
<ul>
        <li>
          amazon dynamo like zero-hop DHT
        </li>
        
<ul>
          <li>
            consistant hashing based
          </li>
        </ul>
        <li>
          zero conf
        </li>
        <li>
          single thread
        </li>
      </ul>
      <li>
        &nbsp;商用版を作成中
      </li>
      
<ul>
        <li>
          独自アルゴリズム
        </li>
        <li>
          multi thread / FSM
        </li>
      </ul>
      <li>
        リセットした理由
      </li>
      
<ul>
        <li>
          商用化
        </li>
        <li>
          アーキテクチャの限界
        </li>
        
<ul>
          <li>
            fiberアーキテクチャ
          </li>
          <li>
            TCPチューニング重要
          </li>
          
<ul>
            <li>
              パフォーマンスが４桁あがった
            </li>
            <li>
              read/writeは計画的に
            </li>
          </ul>
        </ul>
        <li>
          アルゴリズムの限界
        </li>
        
<ul>
          <li>
            人気の集中
          </li>
          <li>
            非対称ノード
          </li>
          
<ul>
            <li>
              Virtual node増減させる？
            </li>
            <li>
              LC-VSS by Godfrey et al.
            </li>
            <li>
              大量のノード前提
            </li>
          </ul>
          <li>
            データ局所性
          </li>
          
<ul>
            <li>
              DHT =&gt; すべてをぶちこわす。。！
            </li>
            
<ul>
              <li>
                似たようなコンテンツもバラバラ
              </li>
            </ul>
            <li>
              検索どうしよう？
            </li>
          </ul>
          <li>
            少数ノード系
          </li>
          
<ul>
            <li>
              最近の論文だと大規模系を対象にしすぎ
            </li>
            <li>
              昔の論文のほうが数十ノードを対象にしていて実は役立ったりする
            </li>
          </ul>
        </ul>
      </ul>
      <li>
        これらの問題を解決すべきアルゴリズムを改良中
      </li>
    </ul>
  </ul>
  
<h3>
    <a title="古橋さん" href="http://d.hatena.ne.jp/viver/" id="yh-h">古橋さん</a> (kumofs, kumo fast strage)
  </h3>
  
<ul>
    <li>
      えとらぼ株式会社のプロジェクト
    </li>
    
<ul>
      <li>
        小さいkey-valueを大量に保存
      </li>
      <li>
        永続化させたい
      </li>
    </ul>
    <li>
      名前
    </li>
    
<ul>
      <li>
        雲は落ちない！（会場でおおお！という声）
      </li>
    </ul>
    <li>
      特徴
    </li>
    
<ul>
      <li>
        replicationは３つ
      </li>
      <li>
        サーバおちても動作
      </li>
      <li>
        サーバを追加してスケールアウト
      </li>
      <li>
        低遅延
      </li>
    </ul>
    <li>
      機能
    </li>
    
<ul>
      <li>
        set, get, delete
      </li>
    </ul>
    <li>
      性能的にはmemcachedよりいい
    </li>
    <li>
      応答速度はmemcachedよりすこし遅い
    </li>
    
<ul>
      <li>
        set
      </li>
      
<ul>
        <li>
          非同期にすることで速くなる
        </li>
      </ul>
      <li>
        ハイブリッドP2P型
      </li>
      
<ul>
        <li>
          Gateway
        </li>
        
<ul>
          <li>
            ローカルホストに
          </li>
          <li>
            memcachedのプロトコルで扱えるように
          </li>
        </ul>
        <li>
          Manager
        </li>
        
<ul>
          <li>
            サーバ一覧を監視
          </li>
          <li>
            GatewayやServerに通達
          </li>
        </ul>
      </ul>
      <li>
        ハッシュ空間は２つもっている
      </li>
      
<ul>
        <li>
          古いバージョン(rhs)と新しいバージョン(whs)
        </li>
      </ul>
      <li>
        困った
      </li>
      
<ul>
        <li>
          再配置で大量のトラフィック
        </li>
        <li>
          Managerの分断問題
        </li>
        <li>
          Gatewayを中継するのはオーバーヘッド？
        </li>
        <li>
          deleteが一貫性を保証しない
        </li>
        <li>
          バックエンドDBにTC
        </li>
      </ul>
    </ul>
  </ul>
</div>
<div>
  
<h3>
    西澤さん(ROMA)
  </h3>
  
<ul>
    <li>
      ROMA
    </li>
    
<ul>
      <li>
        複数マシンから構成されるP2Pを利用した
      </li>
      <li>
        Ruby実装のkey-value store
      </li>
      <li>
        Key : 4~6KB
      </li>
    </ul>
    <li>
      社内クラウド
    </li>
    
<ul>
      <li>
        高負荷な状況であっても十分高速なデータアクセス
      </li>
    </ul>
    <li>
      Pure P2Pで自律的にノード管理
    </li>
    
<ul>
      <li>
        Consistent Hash(環状)
      </li>
    </ul>
    <li>
      各ノードが環全体のノード情報を保持
    </li>
    <li>
      クライアントが環情報を保持することも可能
    </li>
    
<ul>
      <li>
        ROMAに始めてアクセスしたときにクライアントは環序湯法を取得
      </li>
    </ul>
    <li>
      クライアントとRoma間は独自プロトコル
    </li>
    
<ul>
      <li>
        Java, Rubyで実装
      </li>
      <li>
        開発者に分散を意識させない
      </li>
    </ul>
    <li>
      データPUT時に、ノードは左右のノードにレプリケーションされる
    </li>
    
<ul>
      <li>
        データは３つ存在することになる
      </li>
      <li>
        クライアントはレプリケーション完了まで待つ
      </li>
    </ul>
    <li>
      障害がなくてもPUTレプリケーション失敗するときがある
    </li>
    
<ul>
      <li>
        ノードが忙しすぎるときとか
      </li>
    </ul>
    <li>
      マスターがPUT成功したらクライアントにはPUT成功を返す
    </li>
    
<ul>
      <li>
        PUT失敗した隣接ノードはdirty flag
      </li>
      <li>
        dirty flagは自然に解消される
      </li>
    </ul>
    <li>
      ノードの参加、脱退が自由に可能
    </li>
    
<ul>
      <li>
        各ノードはじわじわ情報を伝搬させていく
      </li>
    </ul>
  </ul>
  
<h3>
    <a title="首藤さん" href="http://www.shudo.net/" id="zyvx">首藤さん</a> 
  </h3>
  
<ul>
    <li>
      <a title="Overlay Weaver" href="http://overlayweaver.sourceforge.net/index-j.html" id="js-6">Overlay Weaver</a> のデモ
    </li>
    
<ul>
      <li>
        オーバーレイ上でのDNS
      </li>
    </ul>
    <li>
      PC１台で15万くらいのノードをシミュレーション
    </li>
    <li>
      性能重視
    </li>
    
<ul>
      <li>
        no-hop
      </li>
      <li>
        全ノードが全ノードを知る
      </li>
    </ul>
    <li>
      スケーラビリティ（P2P由来）
    </li>
    
<ul>
      <li>
        multi-hop
      </li>
      <li>
        小さな経路表O(log n)以下
      </li>
    </ul>
    <li>
      XML-RPC, memcachedプロトコル
    </li>
    
<ul>
      <li>
        memcache対応のためにあえて1つだけしかvalueを返さない、とか
      </li>
    </ul>
    <li>
      クラウド上の技術コンテストがあるのでぜひ参加してください！
    </li>
  </ul>
  
<h3>
    藤本さん
  </h3>
</div>
<ul>
  <li>
    <a title="Flare" href="http://labs.gree.jp/Top/OpenSource/Flare.html" id="trfi">Flare</a>   </li>
  <li>
    memcached互換
  </li>
  
<ul>
    <li>
      delete key expire_date(！)
    </li>
    
<ul>
      <li>
        実装していない
      </li>
    </ul>
    <li>
      勝手拡張も
    </li>
  </ul>
  <li>
    Diskに書き込み(メモリ上じゃない)
  </li>
  
<ul>
    <li>
      TCベース
    </li>
    <li>
      Slaveの数だけenque
    </li>
  </ul>
  <li>
    set → getですぐに取得できない場合にset syncコマンドがある
  </li>
  <li>
    proxy機能も
  </li>
  <li>
    2000 qps
</li>
<ul><li>greeの足跡で使ってる</li>
<ul><li>mixiの足跡でTTを使っていると信じていた(←某記事は少し間違ってたみたい)
</li></ul></ul>
</ul>


<h3>まとめ</h3>
<p>メモ読み返しただけでも相当濃い内容でした。同時にこの分野のトレンドはざっと見渡せた感じ。印象深いのはTokyo Cabinetを最下層のストレージに使って、その上でいろんな展開をしている、というトレンドはありそう。あと岡野原さんや首藤さんたちの学問的なアプローチからの視点によるKey-Value Storeの話も面白かったです。ハッシュ関数のトレンド(!)なんてあるんですねー。</p>
<p>ボリュームがあったからかもしれませんが、久々にインプットが相当多い勉強会でした。企画、司会をされた<a href="http://kzk9.net/">太田さん</a>、場所を提供いただいたgreeのみなさん、どうもありがとうございました！</p>


