---
title: emacs.el, anything.el, anything-rcodetools.elを導入
date: 2009/05/31 18:12:38
tags: emacs
published: true

---

<p>前回のemacs導入時にtomoyaさんに<a href="http://b.hatena.ne.jp/tomoya/20090511#bookmark-13394468">コメント</a>いただいたり、<a href="http://polog.org/">negipo</a>さんにもanything.elいれるといいよー！てずっと言われてて、軽く試してもなんかうまく導入できなくて途方に暮れて放置してたところ、この週末に時間とって試してみるとすんなり入りました。得てしてそういうものですよね。。あと、あわせてrails.el, anything-rcodetools.elなんかも入れてみました。その導入メモを残しておきたいと思います。</p>

<h3>anything.el</h3>
<p><a href="http://www.emacswiki.org/emacs/download/anything.el">ここ</a>からanything.elをDL.ロードパスが通ってるディレクトリにつっこみます。僕は<a href="http://d.hatena.ne.jp/tomoya/20090121/1232536106">ここのサイト</a>の影響で .emacs.d/elisp/ 以下につっこんでます。ロードパスを変えたいときは、.emacs.elに</p>

<p><pre>
(setq load-path (cons "~/path/to/loadpath" load-path))
</pre></p>

<p>みたいな記述を書けばOKです。</p>

<p>さて、anything.elをロードパスに置いたら、次の内容を.emacs.elに追記します。</p>

<p><pre>
(require 'anything-config)
(setq anything-sources (list anything-c-source-buffers
                             anything-c-source-bookmarks
                             anything-c-source-recentf
                             anything-c-source-file-name-history
                             anything-c-source-locate))
(define-key anything-map (kbd "C-p") 'anything-previous-line)
(define-key anything-map (kbd "C-n") 'anything-next-line)
(define-key anything-map (kbd "C-v") 'anything-next-source)
(define-key anything-map (kbd "M-v") 'anything-previous-source)
(global-set-key (kbd "C-;") 'anything)
</pre></p>

<p>これで、emacsを再起動させると、編集中にC-;を打つとanythingが起動します。すると、Bufferの中に保存された内容や、最近開いたファイルやら何やらが表示されます。これをC-n,C-p / C-v,M-vで選択できます。</p>

<p>もう、これすごい。みんなすごいって言ってた意味がやっとわかりました。QuickSilverみたいなかんじで編集したいファイルに辿り着けるのがすごく便利。C-x,C-fでファイル選択するの、ちょっと扱いづらいなぁと思ってたけど、これで一気に解決できそうです。</p>

<p>
（参考）<a href="http://yamashita.dyndns.org/blog/anythingel/">anything.elが手放せなくなった</a>
</p>



<h3>rails.el</h3>

<p>必要なファイルは「<a href="http://rubyforge.org/projects/emacs-rails/">rails.el</a>」一式、「<a href="http://www.webweavertech.com/ovidiu/emacs/find-recursive.txt">find-recursive.el</a>」「<a href="http://www.kazmier.com/computer/snippet.el">snippet.el</a>」の３種類。これらをロードパスが通ったところに設定します。（上の例だと.emacs.d/elisp/）</p>

<p>その上で、次のような内容を.emacs.elに追加。</p>

<p><pre>
;; rails.el
(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))

(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))
(setq rails-use-mongrel t)
(require 'rails)

;; 対応するファイルへの切り替え(C-c C-p)
(define-key rails-minor-mode-map "\C-c\C-p" 'rails-lib:run-primary-switch)
;; 行き先を選べるファイル切り替え(C-c C-n)
(define-key rails-minor-mode-map "\C-c\C-n" 'rails-lib:run-secondary-switch)

(setq auto-mode-alist  (cons '("\\.rhtml$" . html-mode) auto-mode-alist))
</pre></p>

<h4>対応ファイルへの切り替え</h4>
<p>Controller, View上でC-c C-p をタイプ。すると該当のアクション箇所、またはViewにさくっとジャンプ。これすごい。今まで毎回毎回ウィンドウ分割してファイルを選択して、、てやってたのが２キーでジャンプ。やばい！</p>


<h4>行き先を選択するメニューの表示</h4>
<p>C-c C-nでメニューがポップアップ表示され、ここからHelperやpartialにジャンプできます。これもすごい。。</p>

<h4>view間の移動</h4>
<p>
  &lt;%= render :partial =&gt; 'news' %&gt; みたいになってる箇所で C-Enterをタイプ。すると_news.rhtmlのpartialファイルに一気にジャンプ。これも便利すぎてウケます。</p>

<p>まとめると、とにかく、これでもかというくらいに移動系が便利になってます。
Railsは、あちらこちらに移動してファイルいじることが多いので、rails.elは確かに必須。
今まで入れてなくて相当損してました。。</p>

<p>（参考）<a href="http://d.hatena.ne.jp/higepon/20061222/1166774270">rails.elまとめ</a>
</p>


<h3>anything-rcodetools.el</h3>
<p>Rubyそのものを書くときに、補完周りなんかで便利になるelispです。これインストールかなりハマりました。次の手順でインストールをすすめます。anything.elはあらかじめ入れておきましょう。</p>

<p><ol>
    <li>gem install rcodetools</li>
    <li>gem install fastri</li>
    <li><a href="http://www.emacswiki.org/cgi-bin/wiki/download/anything-rcodetools.el">ここ</a>からanything-rcodetools.elを導入</li>
    <li>~/.gem/ruby/1.8/gems/rcodetools-0.x.x/にあるrcodetools.elをロードパスの通った場所にコピー</li>
</ol></p>

<p>ハマりどころは4.のrcodetools.elを持ってくるところ。ずっとこのファイルのロードエラーが出て困ってましたが、自分で持ってこないといけないみたい。ちなみにRubyに慣れてる人なら当然かもしれませんが、gemでインストールするときに、sudoでインストールすると上記ファイルは.gem/以下に作られないので、そこもあわせて注意です。（これもハマった）</p>

<p>その上で、次のような内容を.emacs.elに追加しておきます。</p>

<p>
<pre>
(require 'anything)
(require 'anything-rcodetools)
;; Command to get all RI entries.
(setq rct-get-all-methods-command "PAGER=cat fri -l")
;; See docs
(define-key anything-map "\C-e" 'anything-execute-persistent-action)
</pre>
</p>

<p>これで"def"と入力した後に、スペースを入力すると、自動的に"end"が挿入されるなど、Rubyに特化した補完が効いてきます。これもタイプ数さぼるために便利。</p>

<p>ただ、anything-rcodetoolsは、明らかにまだまだもっと便利そうな機能がいっぱいありそうなんですけど、まだ何をどうやってどうなれば便利なのか、自分の中でそのメリットが確認できていません。ここは要研究。</p>

<p>（参考）<a href="http://haraita9283.blog98.fc2.com/blog-entry-298.html">(solved) anything-rcodetools.el が動かない （Ubuntu Studio 8.04）</a></p>

<h3>github</h3>
<p>また、いつものようにここまでの内容を<a href="http://github.com/katsuma/config/tree/master">github</a>にpushしています。興味ある方はご参考ください。あと「こうすればもっと便利になるよ！」みたいな意見は相変わらずどんどん募集中です。</p>


