---
title: Google Codeで管理していたコードをgithubへ移行する
date: 2010/07/11 04:37:18
tags: develop
published: true

---

<p>最近は仕事でgitを使うケースがSubversionと比べて圧倒的に多いので、個人的にGoogle Codeでホスティングしていたコードもgithubに移すことにしました。</p>

<h3>git-svn</h3>
<p>移行作業にはgit-svnが必要になります。MacOSXでgit-svnを使うには、git-coreをmacportsで入れるときに、<strong>+svn</strong>のvariantsをつけてインストールしてあげるとOK。ぼくはすでにgit-coreをインストールしていたので、次のようにしてインストールしなおしました。</p>

<p><pre>
sudo port deactivate git-core
sudo port install git-core +svn
</pre></p>

<h3>作業用ディレクトリの作成</h3>
<p>作業用の適当なディレクトリを作ります。</p>
<p><pre>
mkdir ~/Desktop/git
cd ~/Desktop/git
</pre></p>

<h3>authors.txtの作成</h3>
<p>次のような内容のauthors.txtを作成。(no author)はGoogle Codeの初期設定で、名無しさんがtrunk, branches, tagsを作成しているようなので、この２行が必要になります。左辺はGoogleアカウント名、右辺はgithubに登録した名前とメールアドレスです。</p>
<p><pre>
ryo katsuma = ryo katsuma &lt;katsuma@gmail.com&gt;
(no author) = ryo katsuma &lt;katsuma@gmail.com&gt;
</pre></p>

<h3>移行用レポジトリを作成</h3>
<p>githubで移行用のレポジトリを作成します。作成は<a href="http://github.com/repositories/new">ここ</a>から。</p>

<h3>移行</h3>
<p>ここまでくるとあとは簡単。</p>
<p><pre>
git svn clone -s -A ./authors.txt http://svn_repo.googlecode.com/svn repo
cd repo/
git remote add origin git@github.com:katsuma/new_repo.git
git push origin master
</pre></p>

<h3>まとめ</h3>
<p>Google Codeからgithubの移行は、実作業はauthors.txtを用意するくらいで、全体としてそんなに複雑なものではなかったと思います。
ちなみに今回の作業を通して<a href="http://www.tokyo-jogging.com/">Tokyo-Jogging</a>のコードを全部<a href="http://github.com/katsuma/tokyo-jogging">github</a>に移しました。
コード管理はもちろん、サイト全体の操作性なんかもGoogle Codeと比べてgithubの方が優れていると思うので、移行して正解だったかなーと感じています。
</p>


