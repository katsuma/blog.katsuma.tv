---
title: redisでユーザをfollowしたときにTimeLineをsortして再構築
date: 2010/03/27 06:10:39
tags: ruby, kvs
published: true

---

<p><a href="http://blog.katsuma.tv/2010/03/redtweet_by_redis_and_rails.html">前回</a>のつづき。</p>

<p>課題の1つに挙げてた中で、「Followした瞬間に、そのユーザの過去のTweetを自分のTLに追加できていない」というのがありましたが、こんなかんじでいいのかな。自分のTLに他人のTLを混ぜて、sortしてstoreし直し。(redis-rbが0.2.0じゃないと動かないかも)</p>

<pre>
  def merge_timeline(user_id)
    my_id = @login_user[:id]
    return if @redis.type?("uid:#{user_id}:posts") == "none"

    user_statuses = @redis.lrange("uid:#{user_id}:posts", 0, 100)
    user_statuses.each do |status|
      @redis.lpush("uid:#{my_id}:home", status)
    end
    @redis.sort("uid:#{my_id}:home", :order => "desc alpha", :store => "uid:#{my_id}:home")
  end
</pre>

<p>でも、そうしたあとにremoveしたときにまた再構築し直さないと駄目なことに気づいた。。と、いうかremove面倒ですねぇ、どうするんだろう。泥臭く全statusを走査し直しなのか、それとも順序付Setとか使えば楽にremoveできるのかな。また考え直しです。</p>

<p>あと、このupdateについて、github上の<a href="http://github.com/katsuma/RedTweet">RedTweet</a>のコードもpushし直してますので、興味ある方はご確認ください。</p>


