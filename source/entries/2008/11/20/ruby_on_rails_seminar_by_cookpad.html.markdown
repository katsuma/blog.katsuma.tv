---
title: Ruby on Rails セミナーに参加してきました
date: 2008/11/20 22:57:26
tags: diary
published: true

---

<p><a href="http://www.flickr.com/photos/katsuma/3045172395/" title="Ruby on Rails seminar by katsuma, on Flickr"><img src="http://farm4.static.flickr.com/3144/3045172395_a2369734f9_m.jpg" width="240" height="180" alt="Ruby on Rails seminar" /></a></p>

<p>クックパッドさん主催のRuby on Railsセミナーに参加してきました。Railsは仕事では利用していないのですが、CakePHPなんかはRailsと似たところがあるし、スケーリングの話なんかは参考になるところもあるかな、と思い参加。CTOの橋本健太さんのトークのみ、という内容だったのですがRailsに留まらない「クックパッドとしてのものづくりに対する考え方」は非常に興味深い内容がふんだんでした。以下、そのメモです。（誤字とかRails系の用語は間違っているものもあるかも、、）</p>

<h3>クックパッド</h3>
<ul>
<li>毎日の料理を楽しみにすることで心からの笑顔を増やす</li>
<ul>
<li>これだけやる！</li>
</ul>
<li>世界で一番！生活に役立つサイト作り</li>
<li>月刊ユーザ524万人</li>
<ul>
<li>四国の人口よりおおい！</li>
</ul>
<li>20,30代女性中心</li>
<ul>
<li>20代は４人に１人が見てる！</li>
</ul>
<li>&nbsp;Railsサイト中世界８位（ユーザ数）</li>
<ul>
<li>月刊PV2.8億</li>
<li>PV的にはRailsサイトで世界３位</li>
</ul>
<li>16-18 時がアクセスがピーク</li>
<li>秋からバレンタインにかけてトラフィックがのびる</li>
</ul>
<h3>構成</h3>
<ul>
<li>apache x8</li>
<li>app x44</li>
<li>db x13</li>
</ul>

<ul>
<li>apache 2.2.3</li>
<li>rails 2.0</li>
<li>mongrel 1.1.5/mongrel_1.0.5</li>
<li>mysql 5.0.45</li>
<li>tritton(未来検索ブラジルの全文検索エンジン)</li>
<li>capistrano(デプロイ)</li>
<li>god（mongrelの再起動）</li>
<li>nagios(リアルタイム監視)</li>
<li>Fiveruns Manage(モニタリング)</li>
</ul>
<h3>パフォーマンス</h3>
<ul>
<li>キャッシュ</li>
<ul>
<li>mongrelをとおすだけで10ms</li>
<ul>
<li>ページキャッシュをメインに実装中</li>
</ul>
<li>ページキャッシュできない</li>
<ul>
<li>ユーザごとにことなる表示</li>
<li>アクセスログ</li>
<li>広告</li>
<ul>
<li>これらはAjaxの１リクエストでうめこんでる</li>
</ul>
</ul>
</ul>
<li>クエリチューニング</li>
<ul>
<li>FiveRuns Tuneup</li>
<li>どんなクエリを発行したのか、が１クリックでわかる</li>
</ul>
<li>DB分割</li>
<ul>
<li>最初</li>
<ul>
<li>app 2GB</li>
<li>app 2GB</li>
<li>slave 8GB</li>
<li>検索 4GB</li>
</ul>
<li>検索DBをslave dbに統合</li>
<ul>
<li>app 2GB</li>
<li>app 2GB</li>
<li>slave 12GB</li>
</ul>
<li>OSのキャッシュにテーブルファイルがのりきるかが重要&nbsp;&nbsp;&nbsp; </li>
<li>アクセス数よりもデータ量がパフォーマンスを低下させる</li>
</ul>
</ul>
<h3>ノウハウ</h3>
<ul>
<li>開発者は全員Mac</li>
<li>Emacs</li>
<ul>
<li>rails.el</li>
</ul>
<li>Subversion, trac</li>
<li>Shinjiko</li>
<ul>
<li>Mondorianのクローンのコードレビューシステム</li>
</ul>
<li>DBのレプリケーション</li>
<ul>
<li>マスター、スレーブの切り替え</li>
<li>acts_as_readonlyable を使用</li>
<li>データ更新後のselectはマスターから</li>
</ul>
<li>全文検索</li>
<ul>
<li>Trittonを使用（未来検索ブラジル）</li>
<li>MySQLを拡張</li>
<li>テーブルをJoin できる</li>
<li>2 index</li>
<li>index を貼ったテーブルのファイルをそのまま</li>
</ul>
<li>専用URL</li>
<ul>
<li>一部のユーザは専用のURLをもつ</li>
<ul>
<li>（例）cookpad.com/kem</li>
</ul>
<li>routes.db</li>
<ul>
<li>すべてのコントローラ名を検索</li>
<li>一致しない場合に専用のコントローラに渡している</li>
<li>普通にファイル探索してコードかいてる</li>
</ul>
</ul>
<li>全ページのプレビュー機能</li>
<ul>
<li>x 月x比x時からx時のみ公開　などの場合</li>
<li>すべてのページで任意の日付を指定してプレビュー</li>
<li>Time.nowを上書き</li>
<ul>
<li>/?current_time=2008-10-11</li>
<li>アクセス制限はかけてる</li>
</ul>
</ul>
</ul>
<h3>ものづくり</h3>
<ul>
<li>つくるものをきめる</li>
<ul>
<li>Bestなことに集中する</li>
<ul>
<li>Betterなこと、やったほうがいいこと、はやらない</li>
<li>Bestなことを見つけるまでのの３つの輪</li>
<ul>
<li>やりたい（情熱を持ってとりくめること）</li>
<li>できる（世界で１番になれること）</li>
<li>やるべきこと（儲かること）</li>
</ul>
</ul>
<li>ユーザの欲求に基づいたゴール設計</li>
<ul>
<li>EOGS(Emotion Oriented Goal Setting)</li>
<li>そのサービスに関わるキャストを立てる</li>
<li>キャストごとの疑いようのない欲求を理解する</li>
<li>解決方法を探す</li>
<ul>
<li>疑いようのない欲求</li>
<li>何をすれば？</li>
<li>How to do? / action</li>
<li>指標</li>
</ul>
</ul>
</ul>
<li>計画する</li>
<ul>
<li>スケジュールの３分割の法則</li>
<ul>
<li>サービス完成までの時間にやるべきこと</li>
<ul>
<li>設計</li>
<li>開発</li>
<li>質をたかめる</li>
</ul>
<li>これらに同じだけの時間をかける</li>
</ul>
<ul>
<li>３週間後にサービスインするならば</li>
<ul>
<li>設計１</li>
<li>開発１</li>
<li>質をたかめる　１</li>
</ul>
</ul>
<ul>
<li>１週間の開発でできるように設計する</li>
<li>不必要な機能は削りBestに集中する</li>
<ul>
<li>設計にも１週間かける</li>
<li>調査も入る</li>
</ul>
</ul>
<li>クックパッドものづくり３原則</li>
<ul>
<li><del>無限実行</del>無言実行（2008/11/21 11:00修正）</li>
<ul>
<li>公開前にサービスについての説明をしない</li>
<li>リューアルします！　なんかも言わない</li>
<li>サービスを言葉で説明することはできない</li>
<ul>
<li>ユーザさんにしなくていい不安感を抱かしてしまう</li>
</ul>
<li>公開前に告知するメリットはない</li>

</ul>
<li>無言語化</li>
<ul>
<li>機能を言葉で説明しない</li>
<ul>
<li>一瞬で理解できるインターフェースじゃないと使われない</li>
<li>最大２秒</li>
</ul>
<li>ヘルプやFAQを読ませるのはユーザに負担</li>
<ul>
<li>そもそも読まれない</li>
</ul>
</ul>
<li>サービスに値段をつける</li>
<ul>
<li>どんなサービスでもいくらの価値があるか値段をつけて考える</li>
<ul>
<li>無料だから大丈夫、という考えでは負ける</li>
<li>無料だというだけの理由では使われない</li>
<li>お金を払ってでも使いたいサービスは無料だと使われる</li>
</ul>
<li>ウェブ以外のサービスやものは価値に大して値段がついている</li>
<li>クックパッドは当初は有料サイト</li>
</ul>

</ul>
</ul>
<li>設計する</li>
<ul>
<li>サイトの設計の順番</li>
<ul>
<li>広域な設計から詳細へ</li>
<li>詳細から設計すると機能にとらわれる</li>
<ul>
<li>ユーザに届けるべきものは機能ではなく価値</li>
</ul>
</ul>
<li>設計に最低限必要なもの</li>
<ul>
<li>アジャイル宣言の一節</li>
<ul>
<li>包括的なドキュメントよりも動くソフトウェアを重視する</li>
</ul>
<li>これはドキュメンドがないほうがいい、という概念とは全く違う</li>
<li>最低限必要なドキュメントとは？</li>
</ul>
<li>遷移</li>
<ul>
<li>どんなによくできたページでも遷移がおかしいとユーザは目的の行動をできない</li>
<li>&nbsp;ページ詳細</li>
<ul>
<li>紙でかいたものでOK</li>
<li>構造をメモ</li>
<ul>
<li>紙の真ん中のデザインをかいて左右に空白をあけておくと書き込みしやすくてオススメ！</li>
</ul>
</ul>
<li>DB構造</li>
<li>サイトマップ</li>
<ul>
<li>規模の大きな開発の場合</li>
</ul>
</ul>
</ul>
<li>開発する</li>
<ul>
<li>&nbsp;&nbsp;&nbsp; 開発の３原則</li>
<ul>
<li>Railに乗る</li>
<ul>
<li>Railを外れると</li>
<ul>
<li>明日の自分は他人。コードが読みにくくなる。</li>
<li>早いRailsのバージョンアップへの対応が困難</li>
</ul>
<li>Railを外れそうになったら</li>
<ul>
<li>Railの機能でできないかさがしてみる</li>
<li>Railをはずれない代替案がないかさがしてみる</li>
</ul>
</ul>
<li>リファクタリングしつづけられる状態をたもつ</li>
<ul>
<li>テスト駆動により可能になる</li>
<li>現在のクックパッドはここが課題</li>
<li>2006年にリニューアルしたコードは２年で拡張が不可能に</li>
</ul>
<li>DRY</li>
<ul>
<li>同じことを２度しない</li>
<li>YAGNI You Are not Going Need Itに注意</li>
<ul>
<li>いずれ必要にならない</li>
</ul>
</ul>
</ul>
</ul>
<li>質をたかめる</li>
<ul>
<li>ユーザテスト</li>
<ul>
<li>ユーザテストにおいてはバグの発見よりも、ユーざにねらった価値を提供できているかをテスト</li>
<li>ユーザにゴールを伝えて行動してもらう</li>
<ul>
<li>質問などには答えない</li>
<li>質問がでる遷移、インターフェースは失敗</li>
</ul>
<li>ユーザが自分が何をかんがえているか話しながら操作してみる</li>
</ul>
<li>顔マーケティング</li>
<ul>
<li>「かうき」の法則</li>
<ul>
<li>ウリをつたえる　顔</li>
<li>ライバルにかてる　ウリ</li>
<li>ウリが実感できる　効き</li>
</ul>
</ul>
</ul>
</ul>


<h3>まとめ</h3>
<p>Railsの細かな話は分かりませんでしたが、クックパッドさんのものづくりに対する姿勢は他社と比べてもかなり特徴的だと思います。実装内容の検討について「設計、実装、QAに費やす時間が自動的に決定されるので（そういうルールなので）そこから逆算される実装可能なボリュームだけ実装を行い、そのボリュームを設計する」という時間配分ドリブン？な考え方は結構ユニークだけど合理的。ユーザ試験の方法やBestなことに集中する姿勢などを見ても、合理的に行うにはどうすればいいか？に拘っているように感じ取れました。これを機に、自分たちの開発スタイルにもクックパッドスタイルで取り入れられそうなものが無いか、じっくり考えてみたいと思います。</p>


