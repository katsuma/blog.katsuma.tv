---
title: githubで新しい環境から自分のレポジトリにpush
date: 2009/05/31 13:49:16
tags: develop
published: true

---

<p>小ネタだけど、少しハマってたネタについて。</p>

<p>githubの「自分のレポジトリに最初にpushしていたマシンとは別」のマシン上でgit cloneでデータを取得して、そこで編集、変更を反映するためにpushしようとしたらエラーになりました。</p>

<p><pre>
$ git push
fatal: protocol error: expected sha/ref, got '
*********'

You can't push to git://github.com/user/repo.git
Use git@github.com:user/repo.git

*********'
</pre></p>

<p>何だこれー！と自分のレポジトリなのになぜエラー？？と思ってたら、cloneするときのURLには"Public Clone URL"と"Your Clone URL"の２種類あることを知りました。僕は前者をずっと使ってたのですが、こちらが「公開用URL」後者が「自分専用の(pushをがんがんする前提のURL」という感じなのかな。</p>

<p>と、いうわけでもういちど次のような手順でcloneすると無事、別環境でもpushできました。
</p>

<p><pre>
git clone git@github.com:katsuma/config.git
(編集)
git add .
git commit
(コメント追記)
git push
</pre></p>

<p>今回はこちらの記事を参考にさせていただきました。ありがとうございます！</p>
<p>（参考）<a href="http://d.hatena.ne.jp/tenkoma/20080906/1220728367">githubからローカルにコピーするところまで</a></p>


