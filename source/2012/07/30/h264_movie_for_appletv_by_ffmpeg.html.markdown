---
title: ffmpegを利用してDVDのVOBデータをAppleTVに最適なH.264エンコードのHD動画に変換する
date: 2012/07/30
tags: appletv
published: true

---

    <h3>注意</h3>
    <p>本内容は、自身で著作権を有するDVDをAppleTVで再生する場合のみ参考ください。</p>


    <h3>手順</h3>
    <p>ffmegはhomebrewで最新版に上げておきます。手元のバージョンは0.11.1でした。</p>
    <p>
<pre>$ffmpeg
ffmpeg version 0.11.1 Copyright (c) 2000-2012 the FFmpeg developers
  built on Jul 28 2012 15:27:19 with clang 4.0 ((tags/Apple/clang-421.0.57))
  configuration: --prefix=/usr/local/Cellar/ffmpeg/0.11.1 --enable-shared --enable-gpl --enable-version3 --enable-nonfree --enable-hardcoded-tables --enable-libfreetype --cc=/usr/bin/clang --host-cflags='-Os -w -pipe -march=native -Qunused-arguments -mmacosx-version-min=10.8' --host-ldflags='-L/usr/local/Cellar/gettext/0.18.1.1/lib -L/usr/local/lib -L/opt/X11/lib' --enable-libx264 --enable-libfaac --enable-libmp3lame --enable-librtmp --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libxvid --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libass --enable-libvo-aacenc --disable-ffplay
</pre></p>

    <p>手順としては、チャプタ(大抵、VTS_01_0.VOB)を飛ばしたそれ以降のVOBファイルを連結し、エンコードします。</p>
    <p>
<pre>cat VTS_01_1.VOB VTS_01_2.VOB VTS_01_3.VOB ... VTS_01_7.VOB > VTS.VOB
ffmpeg -i VTS.VOB  -vcodec libx264 -vprofile high -preset slow -b:v 1000k -vf scale=-1:720 -threads 0 -acodec libvo_aacenc -b:a 196k Output.mp4</pre>
</p>

    <p>ffmpegで利用したオプションは、だいたいこんなかんじです。</p>
    <p>
      <ul>
        <li>vcodec ... libx264を利用して動画のコーデックにH.264を利用</li>
        <li>vprofile ... 高解像度のデバイスに利用するときはhighを利用、iPhone3GS, iPhone4などの利用だとmainを利用</li>
        <li>preset ... slowがエンコード時間と画質のバランスで最適。slowerを指定すると、もっと時間がかかるけど画質は向上する模様</li>
        <li>b:v ... 動画のビットレート</li>
        <li>scale ... 画角。720は720pでHD画角の意味。SD画角と576。-1はアスペクト比を保つ。</li>
        <li>threads ... エンコードに最適なスレッド数。コアの数によっては変更させると高速化できそう(未確認)</li>
        <li>acodec ... 音声のコーデックにAACを利用</li>
        <li>b:a ... 音声のビットレート</li>
      </ul>
    </p>

    <p>こうしてできあがったOutput.mp4をiTunesに追加すると、AppleTVのホームシェアリングから選択することができ、TVで再生することが可能になります。</p>

    <h3>補足</h3>
    <p>手元の環境だと、Core2 Duo 2.4GHzの古めのCPUで、2時間弱のDVDデータを上記設定を利用したエンコードに5時間ほどかかっていた模様。threads変えればもう少し速くなるかも?あと画質については40インチのTVに写す分には十分なかんじですが、2passエンコードなどすると、もうちょっと向上させることもできそうです。</p>


    <h3>参考</h3>
    <p><ul>
        <li><a href="https://www.virag.si/2012/01/web-video-encoding-tutorial-with-ffmpeg-0-9/">H.264 WEB VIDEO ENCODING TUTORIAL WITH FFMPEG</a></li>
</ul></p>


