---
title: MinibufferがGoogleDocsで干渉する場合がある？
date: 2007/12/09 01:30:14
tags: javascript
published: true

---

<p>Greasemonkeyの<a href="http://userscripts.org/scripts/show/11759">Minibuffer</a>がGoogleDocs（docs.google.com）で悪さをすることがあるみたいです。こんな現象は他で聞かないし、僕の環境だけなのかもしれないけど、会社と自宅のiMacで両方再現しました。Windowsでも再現したマシンがあった気がしたけど、そこはちょっとあやふや。とりあえず報告。</p>  <h3>現象</h3> <p><img src="http://blog.katsuma.tv/images/07120901.jpg" border="0" /></p> <p>上の画像のように、突如モニタのちょうど真ん中に黒い短形が表示されます。スクロールしても座標は不変なのでposition:absoluteで表示されてる感じ。作業するのに相当支障が。。。</p> <p>しかも、一度この短形が表示されると、GoogleDocsに再ログインしてもずっと変わらないので、状態を引きずってるような感じになります。</p>  <h3>対応方法</h3> <p>最初はGoogleDocs単独の不具合かと思っていたのですが、どうもこの「やや黒い」色に見覚えがある気がして、「MiniBufferの背景色？」と当たりをつけてみました。とりあえず個人的にGoogleDocsでMiniBufferは使う場面が無いので、docs.google.comでMiniBufferを無効に。</p>  <p><img src="http://blog.katsuma.tv/images/07120902.jpg" border="0" /></p>  <h3>結果</h3><p>見事にビンゴ！短形が消滅！！</p>  <p><img src="http://blog.katsuma.tv/images/07120903.jpg" border="0" /></p>  <h3>予想</h3> <p>GoogleDocsの何かのショートカットが影響したのかな、、、というおぼろげな予想。再現方法も今のところ全く分からないので無責任なことも言えないのですが。とりあえず同じような現象を見た人は情報を共有したいものです。</p> 


