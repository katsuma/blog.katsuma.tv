---
title: Flash Playerバージョン判定スクリプト
date: 2009/01/07
tags: javascript
published: true

---

<p>空前のFlash Playerバージョン判定スクリプトブームなわけですが、便乗して僕も乗ってみたいと思います。いろんなところからのものを集めてきたものですけど実際に使っているスクリプトであったりします。結構古い環境もサポートしてます。</p>

<p><pre>
FlashPlayer= {
	version : (function(){
		var version='0.0.0';
		if(navigator.plugins && navigator.mimeTypes['application/x-shockwave-flash']){
			var plugin=navigator.mimeTypes['application/x-shockwave-flash'].enabledPlugin;
			if (plugin && plugin.description) {
				version=plugin.description.replace(/^[A-Za-z\s]+/, '').replace(/(\s+r|\s+b[0-9]+)/, ".");
			}
		} else { // Win IE
			var x='';
			try {
				var axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.7");
				x=axo.GetVariable("$version");
			} catch(e) {
				try {
					axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.6");
					x="WIN 6,0,21,0";
					axo.AllowScriptAccess="always";
					x=axo.GetVariable("$version");
				} catch(e) {
					if (!x.match(/^WIN/)) {
						try {
							axo=null;
							axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash.3");
							x=axo.GetVariable("$version");
						} catch(e) {
							if (axo) {
								x="WIN 3,0,18,0";
							} else {
								try {
									axo=new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
									x="WIN 2,0,0,11";
								} catch(e) {
									x="WIN 0,0,0,0";
								}
							}
						}
					}
				}
			}
			version=x.replace(/^WIN /,'').replace(/,[0-9]+$/,'').replace(/,/g,'.');
		}
		
		if (version.match(/^[0-9]+\.[0-9]+\.[0-9]+$/)) {
			return version;
		} else {
			return '0.0.0';
		}
	})()
}
</pre></p>

<h3>使い方</h3>
<p><pre>FlashPlayer.version</pre></p>
<p>で値が取れます。また、Flash Playerが未インストール時は0.0.0が返ります。</p>

<p>あと、どうやらIE用のFlash Player10 debugバージョンだとうまく値が取れなかったりするようです。ActiveXObjectの生成でコケるっぽい...んだけども、まだ手を出せていません。これはなんとかしないとなぁ。。</p>


<h3>参考</h3>
<p><ul>
<li><a href="http://d.hatena.ne.jp/HolyGrail/20090106/1231256465">Flash判定スクリプトをwww.yahoo.comを参考にしてみる</a></li>
<li><a href="http://d.hatena.ne.jp/amachang/20090106/1231233046">「はてなダイアリーの「バックアップ機能」を復活させるグリースモンキー </a></li>
</p>


