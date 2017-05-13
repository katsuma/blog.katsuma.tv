---
title: キーボードからTVのチャンネルとボリュームを簡単に変更する
date: 2012/07/02
tags: ruby
published: true

---

<p>pop-zapにキーボードリモコンモードを追加して、簡単にチャンネルとボリュームを変更できるようにしました。</p>

<p><ul><li><a href="https://github.com/katsuma/pop-zap">pop-zap</a></li></ul></p>

<h3>使い方</h3>
<p>--remoconか-rのオプションでリモコンモードで起動します。</p>
<p><pre>
bin/pop-zap --remocon

[Pop-zap] Remocon mode:

     Number            Change your channel
     KeyUp/KeyDown     Change your volume
     Enter             Exit
</pre></p>

<p>1~8の数字キーはチャンネル番号、上下キーはボリューム、Enterキー（実際は数字と上下以外のキーすべて）はプログラムの終了、に対応しています。単純なコマンドのラッパにすぎないのですが、Macで作業中にTVのリモコンを探すのはやっぱり面倒くさいので即席で作りました。便利！</p>

<p>あと、本当はAlfredなんかのランチャから１キーで起動させたいのですが、パスの問題かgemのrequireでコケる問題でハマってます。。なんとかせねば。とりあえず今は、.zshenvに</p>

<p><pre>
alias v='cd ~/repos/pop-zap && bin/pop-zap --remocon'
</pre></p>

<p>としておいて、ターミナルから「v」で起動できるようにしてます。</p>

<p>あわせて、TVに変更を与えたときにディスプレイ上にもなんらのフィードバックを表示しないとよくわかんないので、いい感じのビジュアルのフィードバックを返してあげることをTODOに考えています。</p>



