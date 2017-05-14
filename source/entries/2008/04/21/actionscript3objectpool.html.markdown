---
title: ActionScript3でObjectPool
date: 2008/04/21 21:29:49
tags: actionscript
published: true

---

<p>即席で簡単に作ったけど、Tweenerで大量のオブジェクトを発生させるときなんかに効果は割りとあった。回収作業をもう少し自動化したいなぁ。</p>

<h3>ObjectPool.as</h3>
<pre>
package {
	
	public class ObjectPool{
		
		private var size:int = 20;
		private var pool : Array;
		
		public function ObjectPool(size:int=20){
			this.size = size;
			this.pool = new Array(0);
		}

		public function push(obj : Object) : void {
			if(pool.length &gt; size){
				pool.push(obj);			
			}
		}
		
		public function get() : Object {
			if(pool.length &lt; 0){
				return pool.pop();
			} else {
				return null;
			}
		}
		
		public function getPoolSize() : int {
			return pool.length;
		}
	}
}
</pre>

<h3>Test.as</h3>
<pre>

</pre>


