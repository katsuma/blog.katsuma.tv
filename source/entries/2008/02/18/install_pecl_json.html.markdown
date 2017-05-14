---
title: JSON用PECLパッケージのインストール方法
date: 2008/02/18 13:42:16
tags: php
published: true

---

<p>個人的なメモです。php 5.2.0以降は標準で入っている<a href="http://pecl.php.net/package/json">PECLのJSON モジュール</a>のインストール方法。手元のテスト環境でphpのバージョンをupgradeさせるのが面倒そうだったのでPECLでインストールしました。そのメモです。（実はPECL使ったの初めて）</p>

<h3>jsonモジュールのインストール</h3>
<p>
<pre>
sudo yum -y install php-pecl\*
sudo yum -y install php-devel
sudo pecl install json
</pre>
</p>

<h3>php.iniの編集</h3>
<p>
<pre>
# コメントアウトされてあったらコメントを削除
extension_dir = "/usr/lib/php/modules"
# 標準でロードする
extension=json.so
</pre>
</p>

<p>上書きしたらhttpdを再起動するとOK。json_encode($array), json_decode($str)の関数が標準で使えるようになります。</p>


