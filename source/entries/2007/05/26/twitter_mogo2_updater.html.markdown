---
title: Twitterともごもごの同時更新
date: 2007/05/26 14:41:04
tags: javascript
published: true

---

<p>
<a href="http://lab.katsuma.tv/twitter_mogo2_updater/"><img alt="twitter_mogomogo.gif" src="http://blog.katsuma.tv/images/twitter_mogomogo.gif" width="288" height="210" /></a>
</p>

<p>もごもごがAPI公開してくれた、ということで、Twitterともごもごを両方同時に更新できるツールを作ってみました。</p>


<h3><a href="http://lab.katsuma.tv/twitter_mogo2_updater/">Twitter & もごもご updater</a></h3>

<p>仕掛けは単純にphp curlを使ってBasic認証を突破し、それぞれのAPIを呼び出しています。あとはAJAXで吹き出しの内容を変えてるくらい。</p>

<p><strong>パスワードはもちろん一切保存していません</strong>が、自己責任の元で試していただければと思います。</p>
