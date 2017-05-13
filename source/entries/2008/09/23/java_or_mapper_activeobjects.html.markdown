---
title: Javaで手軽にORマッピング ActiveObjects
date: 2008/09/23
tags: java
published: true

---

<p>CakePHPで作成したアプリケーションに対して、Javaアプリケーションから簡単なDB操作（実際はselectだけできればOK）をする必要があって、生のSQLを書くか、それともいい機会だしORマッパのライブラリを勉強がてら使ってみるか、、なんて悩んでいました。保守性を考えるとやっぱり生SQL案は無しで、ORマッパを使うことにしたのですが、Hibernateはどうもリッチすぎる印象があってなかなかやる気が進みませんでした。大規模アプリ開発ならまだしも、今回は上で書いた通り、最低限の参照だけできればそれで事足りる状況だったので、そのためだけにわざわざ設定用のXMLを書くのは気が引けていたのです。</p>

<h3>3分で始められるORマッパ</h3>
<p>3分間クッキングじゃないですけど、それくらい手軽に操作できるものをずっと探し続けていたら、ActiveObjectsなるプロジェクトに辿り着きました。</p>

<p><ul><li><a href="https://activeobjects.dev.java.net/">AcitiveObjects</a></li></ul></p>

<p>名前から分かるように、RailsのActiveRecordを強く意識して作られたもののようです。特徴としては、</p>

<p>
<ul>
<li>規約を重視(Convention Over Configuration)</li>
<li>XMLの設定ファイルは使わない</li>
<li>DDL作成機能 (migration)</li></ul>
</p>

<p>が、あります。とにかく「できるだけすぐに使える」ものを意識、というわけですね。</p>

<p>とにかく動くものを早く作って、そこからチューニングをしていくことを求められることはやはり多いので、ActiveObjectsのこの姿勢はすごく好きです。</p>

<h3>使い方</h3>
<p>では、使い方について。今回は上で書いたとおり、CakePHPですでに作っているRDBに対してのアクセス、についてまとめたいと思います。</p>

<h4>用意するもの</h4>
<p>ActiveObjectsを利用するにあたって、用意するものは次の２つです。</p>
<p>
<ul>
<li>activeobjects-x.x.x.jar</li>
<li>mysql-connector-x.x.x.jar</li>
</ul>
</p>

<p>
activeobjects-x.x.x.jarは<a href="https://activeobjects.dev.java.net/">公式サイト</a>のDownloadの箇所から入手可能です。2008/09/23時点での最新バージョンは0.8.3のようです。
</p>

<p>mysql-connector-x.x.x.jarはMySQLとの接続に対するドライバになるのですが、これは<a href="http://www.mysql.com/">MySQLの公式サイト</a>から入手可能です。2008/09/23時点での最新バージョンは<a href="http://dev.mysql.com/downloads/connector/j/5.1.html">5.1</a>のようです。(僕は実際はもう少し古いバージョンのものを利用していますが、最新のものを利用することで特に問題はないと思います)
</p>

<p>これらのファイルを入手して、クラスパスが通っているところに設置します。</p>

<h4>EntityManagerの作成</h4>
<p>まず、DBに接続するためのEntityManagerを作成します。これは接続情報をまとめたオブジェクトになります。</p>

<p><pre>
import net.java.ao.EntityManager;
...
EntityManager manager = new EntityManager("jdbc:mysql://" + db_host + "/" + db_database, db_login, db_password);
</pre></p>

<p>db_host, db_database, db_login, db_passwordはそれぞれ接続するRDBサーバのネットワークパス、データベース、接続ユーザ、接続パスワードになります。ここで接続に失敗するとSQLExceptionが発生するので、その際は接続ユーザ情報を見直してみましょう。 </p>

<h4>Entityの作成</h4>
<p>次に、テーブルに対して1-1対応するEntityを作成します。Entityは各フィールドのgetter,setterメソッドを定義したinterfaceを作成するだけでOKで、implementsの部分は勝手に行ってくれます。すごく便利！（実際は自分でもimplementsすることもできるような）</p>

<p>たとえば次のようなテーブルUsersが存在するとします。</p>

<p><pre>
+-------------+------------------+------+-----+---------+----------------+
| Field       | Type             | Null | Key | Default | Extra          |
+-------------+------------------+------+-----+---------+----------------+
| id          | int(10) unsigned | NO   | PRI | NULL    | auto_increment | 
| name        | varchar(50)      | NO   |     |         |                | 
| email       | varchar(255)     | NO   | UNI |         |                | 
| password    | varchar(255)     | NO   |     |         |                | 
| created     | datetime         | YES  |     | NULL    |                | 
| modified    | datetime         | YES  |     | NULL    |                | 
+-------------+------------------+------+-----+---------+----------------+
</pre></p>

<p>ここでのUsers Entityは次のようになります。</p>

<p><pre>
import net.java.ao.Entity;

public interface Users extends Entity{
	
	public int getId();
	public void setId(int id);
	
	public String getName();
	public void setName(String name);
	
	public String getEmail();
	public void setEmail(String email);
	
	public String getPassword();
	public void setPassword(String password);
		
	public String getCreated();
	public void setCreated(String datetime);
	
	public String getModified();
	public void setModified(String datetime);
}
</pre></p>

<p>これだけ。簡単！</p>
<p>ここでは全カラムのgetter/setterのインターフェースを定義したけど、実際は利用するカラムのgetter/setterを用意するだけでいいと思います。あとこのgetter/setterのjavaファイルを作成するジェネレータ作っちゃうのもいいかもですね。</p>

<h4>接続＋実行</h4>
<p>SQLの実行は先に作ったEntityManager経由で行います。たとえばUsersテーブルからid=10のユーザ情報を取得するにはこんなかんじです。</p>

<p>
<pre>
EntityManager manager = new EntityManager("jdbc:mysql://" + db_host + "/" + db_database, db_login, db_password);
Users[] users = manager.find(Users.class, Query.select().where("id = ?",10));
</pre>
</p>

<p>見たまんまなので使い方は超簡単なことがわかると思います。EntityManagerは当然使い回しまくるものなので、メインなクラスのコンストラクタあたりで作って、それを使い回すのがよさそう。</p>

<p>あと、データの挿入も同じ感じで書けて、たとえば</p>



<p><pre>
Users user = manager.create(Users.class);
user.setName("Jane");
user.setEmail("jane@hoge.com");
user.save();
</pre></p>

<p>こんな感じで書けちゃいます。</p>

<h4>テーブル名とEntity名に注意</h4>
<p>Cake使ってるとテーブル名は名詞の複数形にして、Modelのクラス名はその単数形にするのがルールになっています。なのでたとえば上の例だとModelで作成するときはUsersクラスではなく、Userクラスになります。</p>

<p>ActiveObjectsの場合、interfaceを作成するときにテーブル名とinterface名は同じにしておく必要があるようです。なので、テーブルで複数形の名前を利用している際は、interface名も同じように複数形にしないとEntityManagerのRDBに接続の際に例外が吐かれてしまいます。これについては正直ちょっと納得いかない制約でもあるのですが、うまく回避というか、対応付けるテーブル名を明示的に指定する方法をご存知の方がいらしゃいましたらぜひ教えていただければと思います。</p>

<h4>一レコードだけselectするメソッドが無い？</h4>
<p><a href="https://activeobjects.dev.java.net/api/net/java/ao/EntityManager.html">API</a>をざっと眺めていて気づいた点としてCakePHPにおけるfind("last")のような１レコードだけselectするようなメソッドはどうも用意されていないようで、find系のメソッドは全部配列で取得されて、つまり複数レコードが取得されることが期待されるような作りになっているようです。</p>

<p>上の例でもあるようなPRY KEYの値をもとにレコードをもってくるときには１レコードだけ持ってこれるメソッドが用意されてあったほうがよさそうなのですが、そこは少し残念な点ではあります。</p>

<h3>とは言え</h3>
<p>まだまだ完璧に使い勝手がよい、とも言い切れない点も正直あるのですが、それでも下準備が多いHibernateと比較するとサクっとORマッピングを導入することができるActiveObjectsは十分に魅力的なライブラリではないでしょうか。ぜひ一度利用の検討を考えてもいいものだと思います。</p>


