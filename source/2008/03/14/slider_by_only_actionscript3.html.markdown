---
title: ActionScript3だけでSliderを作る
date: 2008/03/14
tags: actionscript
published: true

---

<object width="200" height="40" align="middle" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" id="slider1">
<param name="allowScriptAccess" value="sameDomain"/>
<param name="movie" value="http://blog.katsuma.tv/actionscript/TestSlider.swf"/>
<param name="quality" value="high"/>
<param name="bgcolor" value="#ffffff"/>
<embed width="200" height="40" align="middle" src="http://blog.katsuma.tv/actionscript/TestSlider.swf" quality="high" bgcolor="#ffffff" name="slider1" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/>
</object>

<p>スライダーっていうのはボリュームコントロールとかでよく使われてるアレ。クリックとドラッグイベントをとって値を変化させることができるやつ。mxmlで書けばスライダーなんて数行で作れちゃうのですが、ちょっと凝ったインターフェースを作る場合、mxmlでは納得できなかったりする場合があります。</p>

<p>で、バーやノブの部分を好き勝手な画像を設定させることができる汎用的なスライダーを作ってみました。D&Dのところでやや不自然な挙動をする場合もあるのですが、とりあえず満足できるものができたので制作過程含めて晒しておきます。スライダーに限らず、独自UIを作る場合に少しでも役立てばと思います。</p>

<h3>カスタムイベントはそんなに難しくない</h3>
<p>イメージとしては、</p>
<p>
<ol>
<li>flash.events.Eventを継承したカスタムイベントクラスを作成</li>
<li>スライダーのUIを司るクラスがMOUSE_DOWN(バーをクリック)、またはMOUSE_DOWN/MOUSE_UP(ノブをD&D)した場合に、カスタムイベントを発生</li>
<li>addEventListener(カスタムイベント, イベントハンドラ)でイベントを取得、処理</li>
</ol>
</p>

<p>みたいな感じ。2,のカスタムイベントを発生させる場合、AS3ではflash.events.EventDispatcher#dispatchEvent()を使うとイベントの発生を行わさせることができます。このEventDispatchクラスはSpriteが実は継承しているので、UIを作るクラスは特に意識することばく、dispatchEventメソッドは利用できるはずです。なので、UI作成クラスのマウスイベントのハンドラ内でdispatchEventを実行すればOK。</p>

<p>で、とりあえずソースはこんな感じ。</p>

<h3>SliderEvent.as</h3>
<p>カスタムイベントのクラスです。イベントの名前を定義したら親クラスに処理を丸投げしてるだけ。プロパティvalueにSliderの値が入ります。</p>
<p>
<pre>
package {
	import flash.events.Event;

	public class SliderEvent extends Event {
		
		public static const CHANGE : String = 'change';
		public var value:int = 0;
		
		/*
		 * constructor
		 */
		public function SliderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) : void {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new SliderEvent(type, bubbles, cancelable);
		}
	}
}
</pre></p>

<h3>Slider.as</h3>
<p>UIのメインクラスです。bar, nobはそれぞれpng使ってます。スライダの取りうる値はコンストラクタで最小値、最大値、初期値を決めることができるようにしました。ノブをドラッグできる範囲をRectangleクラスを利用して決定しています。これをちゃんと決定させておかないと、y軸方向にもブレて気持ち悪い挙動になってしまいます。イベントハンドラはもうちと奇麗に書けそう。。このあたり、まだ慣れないです。setterを巧みに使って奇麗に書けないかなぁ。</p>

<p>
<pre>
package {
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;

	public class Slider extends Sprite {
		[Embed(source="./images/slider_bar.png")]
		private const imgBar : Class;
		private var bar : Sprite;
		
		[Embed(source="./images/slider_nob.png")]
		private const imgNob : Class;
		private var nob : Sprite;
		
		private var dragging : Boolean = false;
		private var dragArea : Rectangle;
				
		public var _value : Number;
		public var minimum : Number;
		public var maximum : Number;
		
		public static const CHANGE : String = 'change';
		
		/*
		 * constructor
		 */
		public function Slider( _min:Number=0, _max:Number=100, _val:Number=50) : void {
			this.minimum = _min;
			this.maximum = _max;
			this.value = _val;	
			
			// background
			this.bar = new Sprite();
			this.addChild(bar);
			this.bar.addChild(new imgBar());
			
			// nob
			this.nob = new Sprite();
			this.nob.buttonMode = true;
			this.addChild(this.nob);
			this.nob.addChild(new imgNob());
			
			// move nob
			_val = (_val &gt; _max)? _max : _val;
			this.nob.x = this.bar.width * (_val / _max) - nob.width/2;
			
			// drag area
			this.dragArea = new Rectangle(0, 0, bar.width-nob.width, 0);
			
			// click to bar
			this.bar.addEventListener(MouseEvent.MOUSE_DOWN, clickHandler);
			
			// D&D to nob
			this.nob.addEventListener(MouseEvent.MOUSE_DOWN, dragHandler);
			this.nob.addEventListener(MouseEvent.MOUSE_UP, dropHandler);
			
		}
		
		private function clickHandler  (evt : MouseEvent) : void{
			var _x:Number = evt.localX;
			
			_x = (_x&lt;0)? 0 :  _x;
			_x = (_x&gt;bar.width-nob.width)? bar.width-nob.width : _x;
			nob.x = _x;
			
			this.callEvent();
			
		}
		
		private function dragHandler (evt : MouseEvent) : void {
			this.dragging = true;
			var target : Sprite = evt.target as Sprite;
			target.startDrag(false, this.dragArea);			
			target.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			this.callEvent();
			
		}
		
		private function dropHandler  (evt : MouseEvent) : void{
			if(this.dragging){
				var target : Sprite = evt.target as Sprite;
				target.stopDrag();
				target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);

				var _x : Number = this.mouseX - nob.width/2;
				_x = (_x&lt;0)? 0 :  _x;
				_x = (_x&gt;bar.width-nob.width/2)? bar.width-nob.width/2 : _x;
				nob.x = _x;

				this.callEvent();
				
				dragging = false;	
			}
		}
		
		private function mouseMove (evt : MouseEvent) : void {
			if(this.dragging){
				var _x : Number = this.mouseX;
				_x = (_x&lt;0)? 0 :  _x;
				_x = (_x&gt;bar.width-nob.width/2)? bar.width-nob.width/2 : _x;
				this.nob.x = _x - this.nob.width/2;
				evt.updateAfterEvent();
				
				this.callEvent();
			}
		}
		
		
		private function callEvent() : void {
			var se : SliderEvent = new SliderEvent(SliderEvent.CHANGE);
			se.value = this.value;
			dispatchEvent(se);
		}
		
		public function get value() : Number {
			var max : Number = this.maximum;
			var min  : Number = this.minimum;
			var abs_min : Number = (min&lt;0)? -min : min;
			var totalVal  : Number = max + abs_min;
			
			_value = (totalVal * (this.nob.x / (this.bar.width-this.nob.width))) - abs_min;
			_value = (_value&lt;min)? min : _value;
			_value = (_value&gt;max)? max : _value;
			return _value;
		}
		
		public function set value(val:Number) : void {
			this._value = val;
		}
		
	}
}
</pre></p>

<h3>SliderTest.as</h3>
<p>Sliderのテストコードです。Sliderのchangeイベントを取得して、値を出力しつづけるもの。<a href="http://blog.katsuma.tv/2008/01/as3_log_function.html">log関数</a>はいつものやつ。</p>
<p><pre>
package {
	import flash.display.Sprite;
	import flash.events.Event;

	public class TestSlider extends Sprite{
		
		public function TestSlider() : void {
			var slider : Slider = new Slider();
			slider.addEventListener(SliderEvent.CHANGE, changeValueHandler);
			this.addChild(slider);
		}
		
		private function changeValueHandler(evt : Event) : void {
			log(evt.target.value);
		}
	}
}
</pre></p>

<h3>完成</h3>
<p>こんな感じになります。値はFirebugに出てくるのでFirefox/Firebug必須。他の環境だと何が何だかよく分からない可能性が高いですけど。。。</p>


<object width="200" height="40" align="middle" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" id="slider">
<param name="allowScriptAccess" value="sameDomain"/>
<param name="movie" value="http://blog.katsuma.tv/actionscript/TestSlider.swf"/>
<param name="quality" value="high"/>
<param name="bgcolor" value="#ffffff"/>
<embed width="200" height="40" align="middle" src="http://blog.katsuma.tv/actionscript/TestSlider.swf" quality="high" bgcolor="#ffffff" name="slider" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"/>
</object>

<h3>まとめ</h3>
<p>実際に作るとそこまでハマることなくさくさく作れました。パーツの座標調整が一番面倒ですかねぇ。イベントの委譲も割と簡単にできるし、いろいろ応用が効くネタにできそうです。</p>


