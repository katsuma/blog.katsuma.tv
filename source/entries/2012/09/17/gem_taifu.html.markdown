---
title: YouTubeの音声をiTunesに転送するgem - taifu
date: 2012/09/17
tags: ruby
published: true

---

<p>
<a href="http://blog.katsuma.tv/2011/12/taifu.html">この</a>続きです。
iTunesが10.6.3になってからrb-appscriptがまともに動かなくなって、AppleScriptを経由しないとiTunesを操作できなくなったものに対応 + gemにまとめたものです。
</p>

<p>バックエンドでffmpegとyoutube-dlを利用しているので（いつの間にかVLCでYouTubeを再生できなくなってたのでその対応。。）</p>

<p><pre>
brew install ffmpeg
brew install youtube-dl
</pre></p>

<p>で、インストールしておいて</p>

<p><pre>
gem install taifu
</pre></p>

<p>で、インストール可能です。使い方は<a href="http://blog.katsuma.tv/2011/12/taifu.html">今まで</a>と同じ。</p>


