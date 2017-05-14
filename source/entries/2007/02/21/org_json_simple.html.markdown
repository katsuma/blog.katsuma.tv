---
title: Javaで手軽にJSON - org.json.simple
date: 2007/02/21 03:33:43
tags: java, javascript
published: true

---

<p>
Javaでサーバプログラムなんかを書いてクライアントにJSONでレスポンスを返す、なんてケースも最近は増えてきつつあります。小さなJSONなら自前で書いても問題はないのですが、やはりライブラリに頼ったほうがバグも少なくて開発も効率的です。
そんなとき<a href="http://www.json.org/java/simple.txt">org.json.simple</a>は、その名の通りシンプルながらもなかなか使えるいい感じです。
使い方は上のリンクにもあるテキストファイルの通りなのですが、簡単にメモっておきます。

<p>まず既存のオブジェクトからJSONを作成するときはHashMapベースのJSONObjectオブジェクトを利用します。

<pre>
import org.json.simple.JSONObject;

JSONObject obj=new JSONObject();
obj.put("name","foo");
obj.put("num",new Integer(100));
obj.put("balance",new Double(1000.21));
obj.put("is_vip",new Boolean(true));
obj.put("nickname",null);

System.out.print(obj.toString());
// {"nickname":null,"num":100,"balance":1000.21,"is_vip":true,"name":"foo"}
</pre>

<p>こんな感じ。

<p><br /><p>

<p>また、配列を扱うときはJSONArrayオブジェクトを利用します。

<pre>
import org.json.simple.JSONArray;

JSONArray array=new JSONArray();
array.add("hello");
array.add(new Integer(123));
array.add(new Boolean(false));

System.out.println(array.toString());
// ["hello",123,false]
</pre>

<p>こんな感じ。もちろんJSONObjectに対してJSONArrayオブジェクトをputできますし、JSONArrayオブジェクトに対してJSONObjectをputできます。


<p>プログラムミスでSyntaxErrorなJSONを吐き出しちゃったときって、JavaScriptでloadが完了せずに延々とloading状態が続いちゃうことがあって、しかも最悪のケースtry-catchでも救えないこともあります。
なので、こんなつまらないミスを避けるためにもこんなライブラリは非常に有効だと思いますよ。
