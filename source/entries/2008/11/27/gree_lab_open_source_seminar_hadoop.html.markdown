---
title: オープンソーステクノロジー勉強会に参加してきました
date: 2008/11/27 01:40:58
tags: diary
published: true

---

<p><a href="http://www.flickr.com/photos/katsuma/3061697084/" title="open source technology seminar @ gree by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3217/3061697084_997b75907e_m.jpg" width="240" height="180" alt="open source technology seminar @ gree" /></a></p>

<p>greeさん主催の<a href="http://labs.gree.jp/Top/Study/20081125/Report.html">第16回 オープンソーステクノロジー勉強会</a>に参加してきました。今回は<a href="http://hadoop.apache.org/core/">Hadoop</a>がお題。greeさんでの勉強会は初めて参加しましたが、定員オーバーの大盛況でした。そんな勉強会のメモを少し残しておきます。<a href="http://labs.gree.jp/Top/Study/20081125.html">発表内容の資料がアップされています</a>ので、そちらを合わせて読まれると分かりやすいかもしれません。</p>

<h3>開催前</h3>
<ul class="ul1">
 
 <li>無線LANつながらない</li>
 <li>Ust見ないで！</li>
<ul><li>回線圧迫しちゃう
</li>
</ul>
 <li>ボールペン返してください！</li>
 </ul>
<h3> 太田 一樹さん</h3>
<ul class="ul1"><li><a title="http://kzk9.net" href="http://kzk9.net" id="ojlr">http://kzk9.net</a> </li>
 
<ul>
 <li>CTO</li>
 <li>Sedue</li>
 <li>Codeineでもつかってる</li>
 </ul>
 <li>はてなブックマークの全文検索</li>
 <li>hadoop&nbsp;の概要</li>
 
 
<ul><li>Google基盤ソフトウェアクローン</li>
<li>Google File System</li>
<li>MapReduce</li>
<ul>
 
 
 </ul>
<li>Yahoo ResearchのDogue Cuttieさん開発</li>
</ul>
 
 
 
<ul><li>preferred.jp/pub/hadoop.html</li>
 
<ul><li>NTTレゾナンスと共同での解析</li>
</ul>
 </ul>
 <li>Webページ</li>
 
<ul>
 <li>200億x20KB- = 400TB</li>
 <li>1だいでは読み込むだけで１日</li>
 </ul>
 <li>お金だけでは解決できない</li>
 
<ul>
 <li>プログラミングが困難</li>
 
<ul>
 <li>プロセス起動</li>
 <li>プロセス監視</li>
 <li>プロセス間通信など。。</li>
 </ul>
 </ul>
 <li>既存の分散／並列プログラミング環境</li>
 
<ul>
 <li>MPI</li>
 
<ul>
 <li>並列プログラミングのためのライブラリ</li>
 
<ul>
 <li>スパコンの世界では主流</li>
 </ul>
 </ul>
 </ul>
 <li>　MPIの問題</li>
 
<ul>
 <li>耐障害性の考慮がすくない</li>
 <li>壊れるたびにチェックポイントから戻すとかやってらんない</li>
 </ul>
 <li>　MapReduce</li>
 
<ul>
 <li>2006年/Google</li>
 
<ul>
 <li>17万Jobs</li>
 <li>Avg 5/jobくらい死ぬ</li>
 </ul>
 </ul>
<li>MapReduce側の処理</li>
 
<ul>
 <li>Grep</li>
 <li>Sort</li>
 <li>Log Analysis</li>
 <li>Web graph Generation</li>
 <li>Inverted Index Construction</li>
 <li>Machine learning</li>
 
<ul>
 <li>Naive Bayes</li>
 <li>K-manas</li>
 <li>Expectation</li>
 <li>SVM ....</li>
 </ul>
 </ul>
 <li>Hadoopの中身</li>
 
<ul>
 <li>Hadoop distributed file system</li>
 
<ul>
 <li>GFSクローン</li>
 <li>Master/Slave</li>
 <li>ファイルはブロック単位</li>
 <li>Hadoopは64MBごとのブロック</li>
 <li>NameNode</li>
 
<ul>
 <li>Madter</li>
 <li>ファイルのメタデータ</li>
 </ul>
 <li>DataNode</li>
 
<ul>
 <li>Slave</li>
 </ul>
 </ul>
 <li>NAmeNodeは実際のSingle point of failure</li>
 </ul>
 <li>Master/Slave architecture</li>
 
<ul>
 <li>JobTracker</li>
 
<ul>
 <li>Master</li>
 <li>Jobをタスクに分割し、Taskを各TaskTracekrに分配</li>
 </ul>
 <li>TaskTracker</li>
 
<ul>
 <li>Slave</li>
 <li>実際の処理を行う</li>
 </ul>
 </ul>
 <li>Hadoop Streaming</li>
 
<ul>
 <li>各プログラミング言語の標準入出力を利用できる</li>
 </ul>
 <li>使用事例</li>
 
<ul>
 <li>Yahoo Inc</li>
 
<ul>
 <li>2000ノードくらい</li>
 <li>検索、広告、ログ処理、データ解析</li>
 <li>SIGIRなどでもY!Rの論文はHadoopがでてくる</li>
 </ul>
 <li>Amazon, Facebook</li>
 
<ul>
 <li>400ノードくらい</li>
 <li>ログ処理、データ解析</li>
 <li>行動ターゲティング</li>
 
<ul>
 <li>Facebookはファイブ？とかいうSQL的な文でMapReduceをたたける</li>
 </ul>
 </ul>
 <li>はてな</li>
 
<ul>
 <li>ログ解析</li>
 <li>はてなブックマーク２の全文検索</li>
 </ul>
 <li>メールで何件か相談</li>
 
<ul>
 <li>Lucene, ログ処理系が多い</li>
 <li>Cellクラスタ、EC2(blogeye)なども</li>
 </ul>
 <li>某キャリア</li>
 
<ul>
 <li>ストレージとして使ってる</li>
 <li>耐障害性はOK</li>
 </ul>
 <li>数十GBくらいのデータを取り扱うようになると利用を考えたらいいかも</li>
 </ul>
 <li>hBaseはまともに動かない</li>
 <li>GFSはappendできる、Hadoopはできない</li>
 
<ul>
 <li>0.19でappendをサポート</li>
 </ul>
 <li>今のところレプリケーション（耐障害性）よりも、分散処理としての位置づけのほうが’つよい</li>
 <li>リアルタイムで同期は考えない</li>
 
<ul>
 <li>リアルタイムでなくてもOKのような仕組みでないといけない</li>
 </ul>
 </ul>
<h3>大倉 務さん</h3>
<ul class="ul1">
 <li><a title="http://ohkura.com/" href="http://ohkura.com/" id="g5qz">http://ohkura.com/</a> </li>
<li>24歳</li>
<li>Amazonの営業ではありません</li>
<ul>
 
 
 
 </ul>
 <li>blogeye</li>
 
<ul>
 <li>日々、日本中のblogを収集</li>
 <li>属性ごとにランキングなんかがわかる</li>
 </ul>
 <li>作ったきっかけ</li>
 
<ul>
 <li>データマイニングアルゴリズムの研究</li>
 <li>せっかく作ったので公開</li>
 <li>テキストデータで200-300GB</li>
 <li>Blog500万サイト</li>
 </ul>
 <li>導入コスト０に</li>
 
<ul>
 <li>EC2,S3</li>
 <li>EC2</li>
 
<ul>
 <li>10cent/hourのレンタルサーバ</li>
 </ul>
 <li>S3</li>
 
<ul>
 <li>1month 15cent/GB</li>
 </ul>
 <li>EC2からS3の読み書きは無料</li>
 </ul>
 <li>Hadoop</li>
 
<ul>
 <li>Hadoopは動的にノードの追加、削除可能</li>
 <li>１時間他にで利用できるEC2との相性がよい</li>
 <li>HadoopからS3を読み書きするライブラリは既に存在</li>
 <li>S3は並列化すればするほど速くなる</li>
 </ul>
 <li>Blogeyeでの利用例</li>
 
<ul>
 <li>データストアはS3 + mySQL</li>
 <li>blog記事はS3,</li>
 <li>キャシュやクロール先URLはMySQL</li>
 <li>クロール、著さや属性推定はHadoopで分散</li>
 <li>普段は４台、重い処理のMAX時は200台</li>
 
<ul>
 <li>重い処理＝著者属性推定とか</li>
 </ul>
 </ul>
 <li>クロール</li>
 
<ul>
 <li>クロールはマスターでやらない</li>
 
<ul>
 <li>接続先のれsポンスがわるくなったり</li>
 <li>巨大なコンテンツがおちてきたり</li>
 </ul>
 <li>データ保管</li>
 
<ul>
 <li>とりあえずMySQLに保存</li>
 
<ul>
 <li>重複検知できる</li>
 </ul>
 <li>１日ごとにまとめてS3にストア</li>
 </ul>
 </ul>
 <li>インデックス</li>
 
<ul>
 <li>MySQL + Senna</li>
 <li>indexはそれ専用サーバ</li>
 <li>indexのレプリカをフロントエンド(Webサーバ)においてある</li>
 
<ul>
 <li>不可分散用</li>
 </ul>
 </ul>
 <li>著者属性推定ジョブ</li>
 
<ul>
 <li>扱うデータ</li>
 
<ul>
 <li>週種したBlopg記事すべて</li>
 <li>日付ごとではなく、サイトごとに扱う</li>
 </ul>
 <li>MapReduce</li>
 
<ul>
 <li>Map : サイトをキーにして出力</li>
 <li>Reduce : 記事から著者属性を推定</li>
 </ul>
 <li>80GBx2日で300GBくらいのテキスト処理</li>
 
<ul>
 <li>4万円くらい</li>
 </ul>
 </ul>
 <li>複数ジョブのあつかい</li>
 
<ul>
 <li>Hadoopのジョブは優先度を設定できる</li>
 
<ul>
 <li>pingサーバのクロール</li>
 <li>流行ワードの計算ジョブ</li>
 <li>ブログ記事のクロール</li>
 <li>実験用ジョブ</li>
 </ul>
 <li>Tips</li>
 
<ul>
 <li>Mapper終了後にReducerも確保できるようにしている</li>
 
<ul>
 <li>MapReducerが終わってもReducerが確保できなかったらもったいない</li>
 </ul>
 </ul>
 </ul>
 <li>そのほか</li>
 
<ul>
 <li>Amazonの中でもS3ではなくSimpleDBでもいいかも？</li>
 <li>Amazonににみついだ額</li>
 
<ul>
 <li>40万/年くらい</li>
 <li>いまはGoogleで稼働中</li>
 </ul>
 <li>ざっくり構成</li>
 
<ul>
 <li>Apache x2</li>
 <li>index x1</li>
 <li>Master + MySQL x1</li>
 <li>Slave x2</li>
 </ul>
 <li>IOが苦手なジョブとCPU使わないとだめなジョブを混ぜたほうが効率がよい</li>
 <li>Slaveのサイズ変更は手元のスクリプトで</li>
 <li>昔はジョブの優先度がつけられなかった</li>
 <li>悪かったところ</li>
 
<ul>
 <li>ログが超でかくなる場合がある</li>
 
<ul>
 <li>１週間くらいで消したり</li>
 </ul>
 <li>Hadoopそんなに悪くないよ！</li>
 </ul>
 <li>必要なときに必要だけ使えるのがいい</li>
 
<ul>
 <li>EC2 + S2 + Hadoop</li>
 </ul>
 </ul>
</ul>

<h3>感想</h3>
<p>一番興味深かったのはHadoopの使用事例について。どれくらい使われてるものなのか、全く知らなかったのですが思ったより使われてるのかも、という印象です。大きなサイトではログ解析にHadoopを使うってのがじわじわとデファクトになりつつあるのかな？と感じました。あと、国内の大規模な利用ははてブ２が初？</p>
<p>あと、個人的に大規模分散ネタはこっそりやりたいことがあるのでヒマを見てHadoop触ってみたいと思いました。特にEC2との組み合わせで実現したいのですが、この組み合わせの
新しいマッシュアップサイトはどんどん出てきそうな予感がしますね。</p>


