---
title: FlashPlayer9のガベージコレクタのメモリ解放の考察
date: 2008/03/29
tags: actionscript
published: true

---

<p>Tweenerのメモリ解放の挙動について調べている中で、そもそもFlashPlayer9(AVM2)のガベージコレクタの挙動が気になったので、簡単な検証コードを書いてみました。結構興味深い挙動をしていたことに気づいたのでメモ。ちなみにPlayerは<a href="http://www.adobe.com/support/flashplayer/downloads.html">Windowsデバッグ用プレイヤー</a>を利用しています。これはガベージコレクタを強制的に呼び出すSystem.gc()がデバッグ用プレイヤーしか利用できないためです。</p>

<h3>検証</h3>
<p>検証用コードはこんなかんじ。Spriteオブジェクト作ってaddChildして、removeしてnullつっこんで、それぞれの過程でメモリ使用量を計測してるだけ。</p>
<p><pre>
package {
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.System;

	public class GCTest extends Sprite{
		
		public function GCTest() : void {
			log("[0]" + System.totalMemory);

			var sprite : Sprite = new Sprite();	
			log("[1]" + System.totalMemory);
			
			addChild(sprite);
			log("[2]" + System.totalMemory);
			
			removeChild(sprite);
			log("[3]" + System.totalMemory);
			
			System.gc(); // A
			log("[4]" + System.totalMemory);
			
			sprite = null;
			log("[5]" + System.totalMemory);
			
			System.gc(); // B
			log("[6]" + System.totalMemory);				
		}
	}
}
</pre></p>

<p>さて、単純に考えるとオブジェクト作ったものを完全に解放しきっているので[0]の値と[6]の使用量は同じ値になるはず。でも僕の環境での結果はこんな感じでした。</p>

<p><pre>
[0]2240512
[1]2330624
[2]2334720
[3]2338816
[4]2334720
[5]2347008
[6]2334720
</pre></p>

<p>オブジェクトの作成、addChildまでは分かりやすく使用量は上がっていますが、</p>

<p><ul>
<li>GC実行直後はメモリ使用量が減らずに増える</li>
<li>nullを代入してオブジェクトをGC回収対象にしても完全にメモリ解放されていない（[0
]!=[5 or 6]）</li>
</ul></p>

<p>なんてことがわかります。とりあえずGC強制呼び出しは悪影響っぽいのでGC呼び出しをやめて、上の例のA, Bの箇所をコメントアウトするとこんな結果になりました。</p>

<p><pre>
[0]2240512
[1]2330624
[2]2334720
[3]2338816
[4]2338816
[5]2342912
[6]2342912
</pre></p>

<p>null入れたらメモリ使用量上がってます。なにこれw</p>

<h3>見直し</h3>
<p>そこでremoveChildの定義を見直し。するとこんな風に書かれています。</p>

<p>
<blockquote>DisplayObjectContainer インスタンスの子リストから指定の child DisplayObject インスタンスを削除します。削除された子の parent プロパティは null に設定されます。その子に対する参照が存在しない場合、そのオブジェクトはガベージコレクションによって収集されます。DisplayObjectContainer の子より上位にある表示オブジェクトのインデックス位置は 1 つ下がります。

<a href="http://livedocs.adobe.com/flash/9.0_jp/ActionScriptLangRefV3/index.html">DisplayObjectContainer</a>
 </blockquote>
</p>

<p>なるほどー。removeChildすると、もうそれだけでGCの対象になるわけですね。これremoveChildだけじゃだめで、null参照させないとダメだと勘違いしてました。あと、Twitter経由でこんなこと教えていただきました。</p>

<p>
<blockquote>@ryo_katsuma add 分と new 分というニュアンスがちとわからないのだけど、 GC はゴミが残るので正確な差分は求められないかもしれません<br />
<a href="http://twitter.com/kunzo/statuses/778423808">via Twitter</a>
</blockquote>
</p>

<p>
<blockquote>@ryo_katsuma オブジェクト単位じゃなくてブロック単位で開放するらしいので。と、 kamijo さんのブログに書いてありました。<br />
<a href="http://twitter.com/kunzo/statuses/778424217">via Twitter</a></blockquote>
</p>

<p>kamijoさんのblogの該当記事がまだ見つけられていないのですが、どうもGCは逐一オブジェクト単位でメモリ解放を実行しているのではない、ということのようですね。また、null参照させたりして、解放の対象にさせても完全にクリーンアップしてくれることを保証してくれるわけでは無さそうです。</p>

<h3>そんなわけで</h3>
<p>GCの挙動を追っかけるためには、仕様をもう少し読みこなさないとダメぽいです。あとJavaのGCについてももう少し調べたいと思いました。</p>


