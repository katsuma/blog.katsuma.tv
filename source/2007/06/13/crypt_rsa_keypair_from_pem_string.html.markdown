---
title: Crypt_RSA_KeyPairでfromPEMStringが動かない
date: 2007/06/13
tags: php
published: true

---

<p>PHPで公開鍵暗号を利用する場合、PEARの<a href="http://pear.php.net/package/Crypt_RSA/docs/latest/li_Crypt_RSA.html">Crypt_RSA</a>が利用できます。</p>

<p>このCrypt_RSAで、KeyPairをPEM形式の文字列から生成するためにCrypt_RSA_KeyPair::fromPEMString($pem)　な関数があるのですが、手元の環境では動きませんでした。原因はundefinedな配列を操作しているみたいで。と、いうわけで以下、修正方法。</p>

<p>Crypt/RSA/KeyPair.phpの235行目に</p>

<p><pre>$len |= ord($in[$pos++]);</pre></p>

<p>な箇所がありますが、これを</p>

<p><pre>$len |= ord($str[$pos++]);</pre></p>

<p>にすればOKです。これで、次にように確認できるはず。</p>

<p>
<pre>
$key_pair = new Crypt_RSA_KeyPair(1024);
echo("[PubKey]" . $key_pair->getPublicKey()->toString() . "\n");
echo("[PriKey]" . $key_pair->getPrivateKey()->toString(). "\n");

$pem = $key_pair->toPEMString();
echo("[PEM]" . $pem);

$new_key_pair = Crypt_RSA_KeyPair::fromPEMString($pem);
echo("[PubKey]" . $new_key_pair->getPublicKey()->toString() . "\n");
echo("[PriKey]" . $new_key_pair->getPrivateKey()->toString(). "\n");
</pre>
</p>

<p>
それにしても、$inな配列なんてどこにも出てきてないのに、βとはいえ、よくこれでリリースしてるなぁ。。。</p>
