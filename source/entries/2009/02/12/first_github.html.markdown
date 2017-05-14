---
title: はじめてのgithub
date: 2009/02/12 01:15:45
tags: develop
published: true

---

<p>いろんなBlog巡回してると、どこもかしこもgit, gitなのでアカウントだけ作って放置してたgithubで昔に書いたちょこちょこしたコードをコミットしてみました。</p>

<p>
<ul>
<li><a href="http://github.com/katsuma">github/katsuma</a></li>
<li><a href="http://github.com/katsuma/mt-delicious-bookmark-counter/tree/master">katsuma / mt-delicious-bookmark-counter</a></li>
<li><a href="http://github.com/katsuma/flickr-gadget/tree/master">katsuma / flickr-gadget</a></li>
<li><a href="http://github.com/katsuma/sbm-comment/tree/master">katsuma / sbm-comment</a></li>
</ul>
</p>

<p>さすがにはじめてのgitは戸惑うことばかりだったので、メモを残しておきたいと思います。</p>

<h3>gitのインストール</h3>
<p>作業OSはMac OSXです。ソースからもインストールできますが、管理しやすいようにMac portsでインストールしてしまいます。</p>

<p><pre>
sudo port -d sync # 同期
port search git # cogito, git-core, stgit, cgitあたりがあるはず. git-coreを選択
port variants git-core # オプションを確認, 今回はgitweb, svnを指定
sudo port install git-core +gitweb +svn
</pre></p>

<p>これで</p>

<pre>
$ git version 
git version 1.6.1.2
</pre>

<p>なんかの表示になるとインストールOKですね。</p>

<h3>gitのglobal設定</h3>
<p>まず、名前とメールアドレスの設定をしておきます。</p>

<p><pre>
$ git config --global user.name "ryo katsuma"
$ git config --global user.email katsuma＠gmail.com
</pre></p>

<h3>githubでアカウントを作成</h3>
<p><a href="http://github.com/plans">ここ</a>からサインアップ。とりあえずFreeのプランでいいと思います。</p>

<h3>gravatarでアカウントを作成</h3>
<p>gitを使うだけだとここは飛ばしてもいいのですが、githubのアカウントのアバター画像を何か設定したい場合はgravatarのアカウントが必要になります。たしかいろんなサイトでアバター画像を設定するの面倒だから共通化しようよ、みたいなサービスだったかと思います。（実際はgravatar使えるサービスってあまり目にしないのですが。。。）gravatarのアカウント作成は<a href="http://en.gravatar.com/signup">ここ</a>から。</p>

<p>アカウントを作成したら「My Account」> 「Add an Image」から画像を追加。追加後に「G」「PG」「R」「X」の４つの中からRatingが選択できるようになっているので、ここで「G」を選択しておきます。「Global」というわけで、どのWebサービスでも利用できる、という意味ですね。</p>

<p>ここで、Ratingを選ぶ画面が出てこない場合は、画像の追加からやり直しておきましょう。実際、僕はGravatarのアカウントだけ作って放置してたら処理がおかしくなてどうやってもRatingを選択できませんでした。 そこで画像の追加からやり直したら、うまくいきましたので。</p>

<p>さて、githubのアカウント設定ページに戻ってみましょう。サムネイルの画像がちゃんと表示されてあればGtavatarの設定はOKです。</p>

<h3>SSH公開鍵をgithubに登録</h3>
<p>githubにpushするときに、SSH公開鍵を登録しておく必要があるようです。公開鍵は自分のホームディレクトリで</p>
<p><pre>
$ ssh-keygen
</pre></p>
<p>で、$HOME/.ssh/の箇所にid_rsa.pubの名前で作成されます。この内容をコピーしておいて、<a href="https://github.com/account">githubのaccount</a>のページの「SSH Public Keys」の箇所で登録しておきます。（Titleは適当でOK）</p>

<h3>レポジトリを作成</h3>
<p>まず、github上で管理したいプロジェクトのレポジトリを作成します。githubにログインした状態で<a href="https://github.com/">トップページ</a>の「Create a Repository」から作成します。とりあえず今回は「<a href="http://blog.katsuma.tv/2008/12/delicious_bookark_counter_patch_by_ruby.html">Rubyでブックマークカウンタの修正スクリプト書きました</a>」のMTBookmarkCounterのdelicious用修正スクリプトをpushするレポジトリを作りたいと思います。レポジトリ名は「MT Delicious Bookmark Counter」で作成することにします。</p>

<h3>githubにpush</h3>
<p>作成後はレポジトリにpushする方法が表示されるので、基本的にはこれに習うことにします。</p>

<p>まず、ローカルでpushしたいファイルがある場所に移動します。その後、</p>

<p><pre>
git init
</pre></p>
<p>で、作業ディレクトリの初期化を行います。</p>

<p><pre>
git add delicious.rb simple-json.rb
</pre></p>
<p>で、コミットしたいファイルを登録します。</p>

<p><pre>
git commit -m 'first commit'
</pre></p>
<p>で、実際にローカルにコミットします。ここではコミット時のコメントが「first commit」になっているわけですね。</p>

<p><pre>
git remote add origin git@github.com:katsuma/mt-delicious-bookmark-counter.git
</pre></p>

<p>で、リモートレポジトリに登録します。ここでは「github:{githubのユーザ名}/{githubで管理したいレポジトリ名}」になっています。ここでのレポジトリ名は、さっきgithub上でレポジトリを作成したときに表示されているはずなので、それに従います。</p>

<p><pre>
git push origin master  
</pre></p>

<p>で、実際にgithubにpushされます。ここで、SSH公開鍵の設定などに不備があるとエラーになります。特にエラーメッセージが表示されない場合は、pushできているはずなので、確認してみましょう。たとえば今回のレポジトリだと、<a href="http://github.com/katsuma/mt-delicious-bookmark-counter/tree/master">このように</a>アクセスできるはずです。</p>

<h3>まとめ</h3>
<p>実際は作業をしている中で公開鍵まわりでエラーがよく出て、なかなかpushするのに手間取っていました。ただ、コミットはものすごく簡単にできるので、手元で気軽にバージョン管理するにはかなりよさそうです。</p>

<p>とりあえず僕の方針として、大きめのプロジェクトなんかはGoogle codeなんかでホスティングして、小ネタなんかはどんどんgithubにpushしていくことにしたいと思います。あと、.zshrcとか設定ファイルなんかをpushしておくのもいいかもですね。</p>


