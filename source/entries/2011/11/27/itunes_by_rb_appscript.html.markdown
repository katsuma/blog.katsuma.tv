---
title: rb-appscriptを利用してwavデータを自動的にiTunesにタグ情報付きでエンコード、ライブラリに追加
date: 2011/11/27 00:17:22
tags: ruby
published: true

---

    <h3>musical 0.0.2リリース</h3>
    <p><a href="https://github.com/katsuma/musical">musical</a>の0.0.2をリリースしました。(インストールなんかの細かい話は<a href="http://blog.katsuma.tv/2011/11/gem_musical.html">こちら</a>)</p>

<p>リッピングしたwavデータを自動的にiTunesのエンコード設定(mp3/AAC/Appleロスレス...)に従ってエンコードし、アーティスト名とDVDタイトル名を与えることでタグ情報付きでライブラリに追加します。たとえばDVDをドライブに入れた状態で、次のように実行します。</p>

    <p><pre>musical --title "TOUR あいのわ" --artist ハナレグミ</pre></p>
    <p>そうすると、</p>
    <p>
      <ol>
        <li>チャプタごとにvobでリッピング</li>
        <li>wavに変換</li>
        <li>iTunesライブラリにwavを追加</li>
        <li>エンコード設定に従ってタグ付きでエンコード</li>
      </ol>
    </p>

    <p>の順に処理がすすみ、最終的にはiTunesのライブラリにこのように取り込まれます。</p>

    <p>
<img src="/images/049ac944d0c9738d398daa4403b75db1.png" width="425" height="97" />
</p>
    <p>各チャプタのタイトルは今は自動にタグ付けする仕組みはないので、そこは自前で編集を。ここもうまく自動化したいのですが、DVD自身にはトラック情報を持っていないので、amazonなりから情報をうまく吸い出すなりいい方法を模索してます。</p>

    <p>--title, --artistを与えない場合は、それぞれ「LIVE」「ARTIST」の名前でタグ付けされます。また、半角スペースを挟む情報の場合(上の例だと、「TOUR あいのわ」)は、「"」と「"」で囲って渡してあげます。</p>

    <h3>rubyからiTunesを操作</h3>
    <p>iTunesを操作する処理については、<a href="http://appscript.sourceforge.net/rb-appscript/">rb-appscript</a>を利用しています。rb-appscriptは、AppleEventをブリッジしてrubyから扱えるようにしたライブラリで、AppleScriptに対応したアプリケーションは、全て制御することができます。</p>

    <p>一見、すごく便利で万能すぎるように思えるんですけど、ドキュメントが全くないのが辛いとこ。(単純にファイルをライブラリに追加するだけでも相当苦労しました。) 基本的に、method_missingで実装されているので、APIを把握してないと何も開発できません。。最初は、AppleScriptのAPIをdeveloper.apple.comからAPIを探しまくってたのですが、全然見つからなくて途方に暮れてたら意外にも手元にすでに存在してました。</p>

    <p>「アプリケーション」「ユーティリティ」から「Appleスクリプトエディタ」を起動し、「ウィンドウ」&gt;「ライブラリ」から「iTunes」を選択すると、AppleScript用のAPIが表示されます。(ちなみに裏技的に、Appleスクリプトエディタのアイコンに、iTunesのアイコンをD&Dしてもこのライブラリウィンドウは起動します。すごい使いづらいですけど。。)</p>

    <p>
<img src="/images/0e20d45228d622404c53980dead9fe01.png" width="533" height="446" />
</p>

    <p>これを元に、上で述べたファイルを追加+エンコードの基本的な操作をまとめるとこんなかんじになります。</p>
    <p><script src="https://gist.github.com/1380680.js?file=gistfile1.rb"></script></p>
    <p>見てわかる通り、割と直感的な操作が可能になっていると思います。基本的にはgetで情報を取得、setで更新し、このときにAppleEventが発行されています。(なので、できるだけget/setの数は減らすほうがイベント発行の節約になって、パフォーマンスが上がる)</p>


    <p>また、普段irbやpryなんかで簡単な操作をしているときに、APIを確認するまでもなく、ざっとプロパティを確認することくらいはもうちょっと手軽な方法で確認できます。<a href="http://appscript.sourceforge.net/tools.html">ASDictionary</a>をインストールしておくと、各オブジェクトに対してhelpメソッドを利用できます。たとえば、現在iTunes上で選択中のトラック、current_trackには次のようなプロパティが存在することを確認できます。</p>

```

$ pry
[1] pry(main)&gt; require 'appscript'
=&gt; true
[2] pry(main)&gt; include Appscript
=&gt; Object
[3] pry(main)&gt; its = app("iTunes.app")
=&gt; app("/Applications/iTunes.app")
[4] pry(main)&gt; its.current_track
=&gt; app("/Applications/iTunes.app").current_track
[5] pry(main)&gt; its.current_track.help
==============================================================================
Help (-t)

Reference: app("/Applications/iTunes.app").current_track

------------------------------------------------------------------------------
Description of reference

Property: current_track (r/o) : track -- the current targeted track


Terminology for track class

Class: track -- playable audio source
  Plural:
    tracks
  Inherits from:
    item (in iTunes Suite)
  Properties:
    container (r/o) : reference -- the container of the item
    id_ (r/o) : integer -- the id of the item
    index (r/o) : integer -- The index of the item in internal application order.
    name : unicode_text -- the name of the item
    persistent_ID (r/o) : string -- the id of the item as a hexidecimal string. This id does not change over time.
    album : unicode_text -- the album name of the track
    album_artist : unicode_text -- the album artist of the track
    album_rating : integer -- the rating of the album for this track (0 to 100)
    album_rating_kind (r/o) : :user / :computed -- the rating kind of the album rating for this track
    artist : unicode_text -- the artist/source of the track
    bit_rate (r/o) : integer -- the bit rate of the track (in kbps)
    bookmark : short_float -- the bookmark time of the track in seconds
    bookmarkable : boolean -- is the playback position for this track remembered?
    bpm : integer -- the tempo of this track in beats per minute
    category : unicode_text -- the category of the track
    comment : unicode_text -- freeform notes about the track
    compilation : boolean -- is this track from a compilation album?
    composer : unicode_text -- the composer of the track
    database_ID (r/o) : integer -- the common, unique ID for this track. If two tracks in different playlists have the same database ID, they are sharing the same data.
    date_added (r/o) : date -- the date the track was added to the playlist
    description : unicode_text -- the description of the track
    disc_count : integer -- the total number of discs in the source album
    disc_number : integer -- the index of the disc containing this track on the source album
    duration (r/o) : short_float -- the length of the track in seconds
    enabled : boolean -- is this track checked for playback?
    episode_ID : unicode_text -- the episode ID of the track
    episode_number : integer -- the episode number of the track
    EQ : unicode_text -- the name of the EQ preset of the track
    finish : short_float -- the stop time of the track in seconds
    gapless : boolean -- is this track from a gapless album?
    genre : unicode_text -- the music/audio genre (category) of the track
    grouping : unicode_text -- the grouping (piece) of the track. Generally used to denote movements within a classical work.
    kind (r/o) : unicode_text -- a text description of the track
    long_description : unicode_text
    lyrics : unicode_text -- the lyrics of the track
    modification_date (r/o) : date -- the modification date of the content of this track
    played_count : integer -- number of times this track has been played
    played_date : date -- the date and time this track was last played
    podcast (r/o) : boolean -- is this track a podcast episode?
    rating : integer -- the rating of this track (0 to 100)
    rating_kind (r/o) : :user / :computed -- the rating kind of this track
    release_date (r/o) : date -- the release date of this track
    sample_rate (r/o) : integer -- the sample rate of the track (in Hz)
    season_number : integer -- the season number of the track
    shufflable : boolean -- is this track included when shuffling?
    skipped_count : integer -- number of times this track has been skipped
    skipped_date : date -- the date and time this track was last skipped
    show : unicode_text -- the show name of the track
    sort_album : unicode_text -- override string to use for the track when sorting by album
    sort_artist : unicode_text -- override string to use for the track when sorting by artist
    sort_album_artist : unicode_text -- override string to use for the track when sorting by album artist
    sort_name : unicode_text -- override string to use for the track when sorting by name
    sort_composer : unicode_text -- override string to use for the track when sorting by composer
    sort_show : unicode_text -- override string to use for the track when sorting by show name
    size (r/o) : integer -- the size of the track (in bytes)
    start : short_float -- the start time of the track in seconds
    time (r/o) : unicode_text -- the length of the track in MM:SS format
    track_count : integer -- the total number of tracks on the source album
    track_number : integer -- the index of the track on the source album
    unplayed : boolean -- is this track unplayed?
    video_kind : :none / :movie / :music_video / :TV_show -- kind of video track
    volume_adjustment : integer -- relative volume adjustment of the track (-100% to 100%)
    year : integer -- the year the track was recorded/released
  Elements:
    artworks -- by index



==============================================================================
=> app("/Applications/iTunes.app").current_track
```

    <p>実際は、さきほどのAppleスクリプトエディタのヘルプ情報から引っ張ってきて表示しているだけですが、都度手元で確認できるのは便利です。ざっとAPI全体を眺めて把握した上で、手元で動かしながら動作を確認するのが開発を進める方法として良さそうです。</p>

    <h3>今後の予定</h3>
    <p>当面、次の内容くらいはどうにかしたいです。</p>
    <p>
      <ul>
        <li>iTunesのライブラリに追加したとき、変換前のwavファイルをライブラリ上から削除</li>
        <li>副音声の扱いを制御</li>
        <li>テストを追加</li>
        <li>トラック名を自動追加</li>
      </ul>
    </p>

    <p>あとrb-appscriptめちゃめちゃ可能性を感じるので、こいつでもうちょっと遊んでみたいですね。API見ているだけでムフムフします。。！</p>


<p>
    <iframe src="//rcm-jp.amazon.co.jp/e/cm?lt1=_blank&bc1=000000&IS2=1&bg1=FFFFFF&fc1=000000&lc1=0000FF&t=katsumatv-22&o=9&p=8&l=as4&m=amazon&f=ifr&ref=ss_til&asins=B00317CONK" width="120" height="240" scrolling="no" marginwidth="0" marginheight="0" frameborder="0"></iframe>
</p>
