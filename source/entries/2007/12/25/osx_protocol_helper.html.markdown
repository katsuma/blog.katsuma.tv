---
title: OSXでオレオレ･プロトコルのヘルパアプリケーションを作成する
date: 2007/12/25 01:46:13
tags: osx
published: true

---

<p>Skypeでは「callto:」, Peercastでは「peercast:」なんかの「オレオレ･プロトコル」がアプリケーションに関連付けられています。これらは、Web上のHTMLファイルからURLクリック（または、同等の処理）で、アプリケーションを起動させることができる、という利点があります。（もちろんセキュリティ上の問題もあるのですが、その話はまた別途）。</p>

<p>
このプロトコルとアプリケーションの関連づけ、つまりプロトコルヘルパのアプリケーションをOSX上で作成する方法について、Mac初心者（利用歴1ヶ月くらい）がまとめたメモを残しておきます。よく理解できていない箇所もあるのでツッコミは大歓迎です。</p>

<p>お題として「<strong>kefir:</strong>」というプロトコルを定義したとして、ブラウザランチャアプリとして「<strong>KefirRunner</strong>」というアプリケーションを作ってみることにします。分かりやすく言うと、ターミナルから「open kefir://yahoo.co.jp」と入力すると、Firefox（標準のブラウザ）がyahoo.co.jpを開く感じです。</p>




<h3>アプリケーションの構成</h3>
<p>まず、OSXではアプリケーションは基本的には次のような構成になっています。</p>

<p><pre>
KefirRunner.app/
  - Contents/
      - Info.plist
      - MacOS/
      - Resources/
</pre></p>

<p>KefirRunner.appがアプリケーション「KefirRunner」にあたります。OSX上では、拡張子「app」のディレクトリはひとまとまりなアプリケーションとして認識されます。実際、/Applications の中身をターミナルで覗いてみると、Finder上では１つのアイコンにまとまって見えたアプリケーションも、実はただのディレクトリであることが確認できると思います。</p>

<p>さて、KefirRunner.appの中には「Contents」というディレクトリが入っています。さらに、その中にはアプリケーション全体の仕様について述べた「Info.plist」、実行プログラムの実体が収められた「MacOS」ディレクトリ、アイコンファイルなどリソースファイルが格納された「Resources」ディレクトリがあります。（さらにアプリケーションのライブラリが格納された「Library」ディレクトリが存在する場合や、それ以外のファイル、ディレクトリが存在する場合もあります）</p>

<h3>Info.plist</h3>
<p>プロトコルヘルパでポイントとなるのは、info.plistです。ここで実行ファイルが任意の「オレオレ・プロトコル」を扱うことができるように、その設定を記述することとなります。Info.plist自体の説明はここでは省略しますが、要するにアプリケーション名やアイコンファイル名、Dockに表示させるかどうか、なんかの情報をXML形式でまとめたものと考えて良いと思います。</p>

<p>実際のプロトコル情報は、plist > dict 内にkey:<strong>「CFBundleURLTypes」</strong>で設定します。たとえば「kefir」プロトコルを設定する場合は、次のような内容を追加することになります。</p>

<p><pre>
        &lt;key&gt;CFBundleURLTypes&lt;/key&gt;
        &lt;array&gt;        
                &lt;dict&gt;
                &lt;key&gt;CFBundleURLName&lt;/key&gt;
                &lt;string&gt;kefir URL&lt;/string&gt;
                &lt;key&gt;CFBundleURLSchemes&lt;/key&gt;
                &lt;array&gt;
                        &lt;string&gt;kefir&lt;/string&gt;
                &lt;/array&gt;
                &lt;/dict&gt;
        &lt;/array&gt;
        &lt;key&gt;NSiUIElement&lt;/key&gt;
        &lt;true/&gt;
</pre></p>

<p>ポイントは「CFBundleURLSchemes」のValueに設定したいプロトコル名を設定すること。あとはお決まりの定型文のように考えておいて大丈夫です。Info.plistの編集はこの後にも行う必要があるので、この段階では「こんな風に編集する必要があるんだな」くらいに考えておきます。</p>

<h3>AppleEvent</h3>
<p>さて、あるプロトコルのアプリケーションに対するアクセスはイベントで上がってきます。MacOSX上では、このイベントは「<strong>Apple Event</strong>」という名前のイベントで上がってきます。なので、プロトコルヘルパを実装する場合は、このAppleEventを扱うアプリケーションを実装することと等価です。現在は<a href="http://developer.apple.com/jp/technotes/tn1168.html#Section3">Java</a>や<a href="http://www.python.jp/doc/2.3.5/mac/module-aepack.html">Python</a>、<a href="http://rubyosa.rubyforge.org/">Ruby</a>などさまざまな言語でApple Eventを扱うことができるライブラリが存在しているので、環境に応じた言語を選択すればOKです。今回は「kefir://yahoo.co.jp」の「yahoo.co.jp」の箇所を（解析し、）取得することだけがとりあえずの目的なので、もっとも簡単なApple Scriptを利用することとします。</p>

<h3>AppleScriptからアプリケーションを作成</h3>
<p>まず、Finderから「/Applications/Applescript/スクリプトエディタ.app」を開き、以下のAppleScriptを書きます。</p>

<p><pre>
on open location v
	if v starts with "kefir://" then
		activate
		set kefir to text from character 7 to character -1 of v
		set kefir to "http:" & kefir
		set href to kefir
		tell application "Finder" to open location kefir
	end if
	quit
end open location
</pre></p>

<p>細かな説明は省略しますが、大体の内容はそのまま読めば理解できるかと思います。イベントで上がったときに与えられた文字列が「kefir://」で始まっていたら、それ以降の文字列をopenコマンドで開いています。（エラー処理とかは省いてしまっているので、適切な処理を追加する必要はあります）</p>

<p>スクリプトを書いたら「コンパイル」を行い、「ファイル」から「保存」を選択します。このとき名前は「KefirRunner」に、フォーマットは「アプリケーションバンドル」を指定して保存します。</p>

<h3>Info.plistの修正</h3>
<p>これでKefirRunnerアプリケーションが先に説明したディレクトリ構成を保ったまま、完成しているはずです。FinderからKedirRunnerを保存したところまで移動して中身を覗いてみましょう。{$path_to_src}/KefirRunner.app/ContentsにInfo.plistがあることを確認すると、先のkefirプロトコルの内容を追加します。追加した後のInfo.plistはこのようなものになります。 
</p>

<p><pre>
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"&gt;
&lt;plist version="1.0"&gt;
&lt;dict&gt;
        &lt;key&gt;CFBundleAllowMixedLocalizations&lt;/key&gt;
        &lt;true/&gt;
        &lt;key&gt;CFBundleDevelopmentRegion&lt;/key&gt;
        &lt;string&gt;English&lt;/string&gt;
        &lt;key&gt;CFBundleExecutable&lt;/key&gt;
        &lt;string&gt;applet&lt;/string&gt;
        &lt;key&gt;CFBundleIconFile&lt;/key&gt;
        &lt;string&gt;applet&lt;/string&gt;
        &lt;key&gt;CFBundleInfoDictionaryVersion&lt;/key&gt;
        &lt;string&gt;6.0&lt;/string&gt;
        &lt;key&gt;CFBundleName&lt;/key&gt;
        &lt;string&gt;KefirRunner&lt;/string&gt;
        &lt;key&gt;CFBundlePackageType&lt;/key&gt;
        &lt;string&gt;APPL&lt;/string&gt;
        &lt;key&gt;CFBundleSignature&lt;/key&gt;
        &lt;string&gt;aplt&lt;/string&gt;
        &lt;key&gt;LSRequiresCarbon&lt;/key&gt;
        &lt;true/&gt;
        &lt;key&gt;WindowState&lt;/key&gt;
        &lt;dict&gt;
                &lt;key&gt;name&lt;/key&gt;
                &lt;string&gt;ScriptWindowState&lt;/string&gt;
                &lt;key&gt;positionOfDivider&lt;/key&gt;
                &lt;real&gt;310&lt;/real&gt;
                &lt;key&gt;savedFrame&lt;/key&gt;
                &lt;string&gt;423 514 870 512 0 0 1920 1178 &lt;/string&gt;
                &lt;key&gt;selectedTabView&lt;/key&gt;
                &lt;string&gt;result&lt;/string&gt;
        &lt;/dict&gt;

        &lt;key&gt;CFBundleURLTypes&lt;/key&gt;
        &lt;array&gt;
                &lt;dict&gt;
                        &lt;key&gt;CFBundleURLName&lt;/key&gt;
                        &lt;string&gt;Kefir URL&lt;/string&gt;
                        &lt;key&gt;CFBundleURLSchemes&lt;/key&gt;
                        &lt;array&gt;
                                &lt;string&gt;kefir&lt;/string&gt;
                        &lt;/array&gt;
                &lt;/dict&gt;
        &lt;/array&gt;
        &lt;key&gt;NSUIElement&lt;/key&gt;
        &lt;true/&gt;
&lt;/dict&gt;
&lt;/plist&gt;

</pre></p>

<p>要するに、"kefirプロトコルはKefirRunnerアプリケーションに関連付けられていて、実行ファイル「applet（スクリプトエディタからビルドしたときの標準の実行ファイル名）」になる"　と、ということを指しています。これでKefirRunnerに必要なものは揃いました。</p>

<h3>Info.plistの反映</h3>
<p>Info.plistの情報をOSに反映させるためにはアプリケーションファイルを一度dmg型式のイメージファイルにまとめて、アプリケーションフォルダにD&Dし、インストールする必要があります。<strong>（イメージファイルからインストール、というのがポイント）</strong>。
たとえばフリーソフトのCleanArchiverならD&Dでdmgファイルを作成することができます。KefirRunner.appフォルダからKedirRunner.dmgファイルが作成できれば完成です。アプリケーションフォルダにD&Dでインストールを行います。
</p>

<p>インストールが終わったらターミナルを開き、「open kafir://www.yahoo.co.jp」と入力します。これでブラウザが起動してyahoo.co.jpが開けたら無事完成です！一応完成品も置いておくのでうまくできなかった人はご参考ください。</p>
<p>
（<a href="http://blog.katsuma.tv/data/KefirRunner.dmg">KefirRunner.dmg</a> : 31.7KB）</p>

<p>これでターミナル上で開発してるときに「あーググりたい！」とか思ったときは迷わず</p>

<p><pre>
open kefir://google.com</pre></p>

<p>ですよ。</p>

<p><strong>「http？いいえ、kefirです。」</strong>（結局これが言いたいだけだった）</p>

<h3>アンインストール方法</h3>
<p>勝手にkefirプロトコルが関連付けられてしまったわけですが、この情報を削除するためにはkefirプロトコルのヘルパプログラムであるKedirRunnerをアプリケーションフォルダからゴミ箱に移して削除してしまうとOKです。簡単でしょう？</p>

<h3>まとめ</h3>
<p>kefirとかふざけたプロトコルを定義しましたが、たとえば独自のメーラやブラウザを作りたいときは、今回のようにInfo.plistを編集したアプリケーションバンドルを作成することで、標準のブラウザやメーラを作成することもできます。</p>

<p>また、Webから独自のアプリケーションを起動させることがこれでできますので、Webアプリとローカルアプリとの連携にも役立たせることができると思います。</p>
