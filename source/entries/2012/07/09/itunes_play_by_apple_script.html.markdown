---
title: AppleScriptを利用してiTunesにファイルを追加、再生、削除する
date: 2012/07/09 23:21:27
tags: applescript
published: true

---

    <p>「<a href="http://blog.katsuma.tv/2012/06/rb-appscript_not_work_on_itunes10_6_3.html">iTunes10.6.3からrb-appscriptが利用できない</a>」の通り、rb-appscript経由でのiTunes操作が一切使えなくなっているので、その対応策としてAppleScriptを利用する必要があります。<a href="https://github.com/katsuma/pop-zap">pop-zap</a>でチャンネル変更時に、「変更後の番組情報を音声でスピーカーで出力させる」ということを実現したくて、AirPlay経由でiTunesで再生させればいいなというとこまでは考えられたので、そこから試行錯誤して次のような感じで実現できました。</p>

    <p><pre>
tell application "iTunes"
  set added_track to add #{MacTypes::FileURL.path(File.expand_path("foo.aiff")).hfs_path)}
  play added_track with once
  delay 10
  pause
  set loc to (get location of added_track)
  delete added_track

  tell application "Finder"
    delete loc
  end tell
end tell
    </pre></p>

    <p>このAppleScriptを適当な名前、たとえばsound.scptで保存してAppleScriptを実行するインタープリタのosascriptで実行すればOK。</p>

    <p><pre>`osascript sound.scpt`</pre></p>

    <p>1つポイントとして、playしたあとにdelayさせてpauseさせています。これは、iTunesの再生処理が別スレッドで実行されるため、同期的に処理を行うにはdelay {再生時間}させないと、どうにもならなかったことによります。。。また、その後にpauseを明示的に実行しないと、指定のファイルを再生後に次のトラックを再生してしまったので、このような処理を行っています。もし、再生後にファイルの削除など(トリッキーなことが)必要なければ、delay, pauseは不要ですね。</p>

    <p>しかし、AppleScriptはなかなか慣れずに苦労しました。。でも、この感じで手元で動かなくなったscriptも修正できそうです。</p>


