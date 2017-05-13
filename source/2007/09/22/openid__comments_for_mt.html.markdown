---
title: OpenID Comments for MTを導入しました
date: 2007/09/22
tags: develop
published: true

---

<p>以前からこのBlogはコメントスパムが激しくて、それがゆえに人力で全部削除して、、、とかなりアナログな運営をしていました。先日もスパムコメントと間違えて大量のありがたいコメントを間違って削除してしまうミスを犯したり、、、orz と、いうわけでそんな凡ミスを防ぐためにも、今回<a href="http://ja.wikipedia.org/wiki/OpenID">OpenID</a>の認証サービスを導入してみました。コメント欄に次のようなフォームが表示されていると思います。</p>

<p><img alt="openID signin" src="http://blog.katsuma.tv/images/openid_signin-thumb.gif" width="432" height="51" /></p>

<p>ここから自分のOpenID URLでサインインをしていただくと、次のようなコメント入力欄が表示されます。</p>

<p><img alt="comment by openID" src="http://blog.katsuma.tv/images/openid_form.gif" width="450" height="64" /></p>

<p>MTはデフォルトでTypePadの認証を利用することができますが、ほかのBlogサービスをご利用の方などにはちょっと敷居があるなぁと思ってコメント欄は完全に開放していたのですが、これで割とオープンな技術での認証ができるんじゃないかな、と思います。コメントスパムの変化についてもみていきたいと思います。</p>

<p>なお、今回はMTのプラグインの「OpenID Comments for MT」を利用してのですが、せっかくなのでその導入メモを残しておきます。</p>

<h3>プラグインのDL</h3>
<p><a href="http://www.sixapart.com/pronet/docs/powertools">SixApartの公式ページ</a>ではバージョンが1.2と古いので<a href="http://markpasc.org/code/mt/openid_comments/index.html">こちら</a>からDLします。2007.09.22時点で1.7があります。</p>

<h3>プラグインのアップロード</h3>
<p>DLしたzipファイルを解凍後、</p>
<ol>
<li>「plugins」フォルダをそのままMovable Typeのシステムディレクトリにアップロード</li>
<li>「mt-static」フォルダをMovable TypeのStaticWebPathにアップロード</li>
<li>plugins/openid-comment/signon.cgi のパーミッションを755に（地味に忘れがち）</li>
</ol>

<h3>プラグインの設定</h3>
<ol>
<li>管理画面の「環境設定」カテゴリの「設定」ページの「コメント/トラックバック」タブを開く</li>
<li>［投稿を受け付ける条件］を［認証サービスで認証されたコメント投稿者のみ］に設定。認証用トークンが未入力の場合は、ここで入力（内容は適当な文字列でOK）</li>
<li>エントリー・アーカイブに<MTOpenIDSignOnThunk>タグを追加（このタグ自身がformタグを書き出すので、コメントエリアのformタグ前後に書くのが望ましい）たとえば
<pre>
&lt;MTEntryIfCommentsOpen&gt;
&lt;form method="post" action="&lt;$MTCGIPath$&gt;&lt;$MTCommentScript$&gt;" &gt;
   &lt;input type="hidden" name="static" value="1" /&gt;
   &lt;input type="hidden" name="entry_id" value="&lt;$MTEntryID$&gt;" /&gt;
   &lt;div class="comments-open" id="comments-open"&gt;
      &lt;h2 class="comments-open-header"&gt;コメントを投稿&lt;/h2&gt;
…
   &lt;/div&gt;
&lt;/form&gt;
&lt;MTOpenIDSignOnThunk&gt;
&lt;/MTEntryIfCommentsOpen&gt;
</pre>
などとなります。
</li>
<li>[メールアドレスの要求]のチェックをはずす（OpenIDの仕様がメールアドレスを送らないものなので、そもそもこの必要性が無いから）</li>
<li>サイト全体を再構築</li>
</ol>

<p>これでOKです！</p>

<p>このプラグインは導入が簡単で、10分程度で導入が完成しました。OpenIDの認証機能はMT4から導入されるみたいですが、OpenIDは最近対応サイトもどんどん増えてる注目の技術ですし、MT3.xのユーザの方はぜひ導入を検討してみてはいかがでしょうか？</p>

