---
title: TensorFlow / TF Learn v0.9のDNNClassifier / TensorFlowDNNClassifierの罠
date: 2016/07/18 02:05:01
tags: tensorflow
published: true

---

（2016.07.18 19:00 追記： 誤解のある表現が多かったのでタイトル含め加筆しています）

唐突ですが、1年ぶりの更新を機に、最近興味を持って触っているTensorFlow / TF Learn(skflow) の話をします。

## 背景
2016.06.27にTensorFlow v0.9がリリースされています。

- [TensorFlow v0.9 now available with improved mobile support](https://developers.googleblog.com/2016/06/tensorflow-v09-now-available-with.html)

「モバイルサポートが充実したよ〜」が今回のウリなのですが、v0.8から本体に梱包されてるTF Learn(skflow)において、
シンプルなDeep Neural NetworkモデルのClassifierを扱うときに便利な`DNNClassifier`周辺で
罠が多いことが分かったので備忘録としてメモを残しておきます。
ちなみに、下記のコードや調査はすべて[TensorFlow Learn(TF Learn)](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/contrib/learn/python/learn)ベースのものです。
いろいろな罠の話をしていますが、TensorFlow本体の話では無いのでご注意ください。

結論からいうとv0.9は実用段階では無さそうです。

## v0.9はmodelをsave/restoreできない

いきなり致命的な問題です。要するに学習したmodelを使いまわせないというもの。どうしてこうなったのか。。
当然のように、IssueやStackOverflowでは同様の質問が乱立しています。

- [cannot save/restore contrib.learn.DNNClassifier](https://github.com/tensorflow/tensorflow/issues/3340)
- [.Save, .Restore for contrib.learn.DNNClassifier](https://github.com/tensorflow/tensorflow/issues/3306)
- [tensorflow contrib.learn save](http://stackoverflow.com/questions/38364438/tensorflow-contrib-learn-save)
- [tensorflow 0.9 skflow model save and restore doesn't work](http://stackoverflow.com/questions/38223839/tensorflow-0-9-skflow-model-save-and-restore-doesnt-work)

これはv0.8まであった`TensorFlowDNNClassifier`がv0.9からDeprecatedになって
`DNNClassifier`の利用を推奨される流れで入ったバグのようです。問題を整理すると、

- v0.9の`DNNClassifier`は `TensorFlowDNNClassifier`にあった`save`, `restore`メソッドが落ちてる
- v0.9の`TensorFlowDNNClassifier`の`save`, `restore`メソッドはv0.8から引き続き生きている
 - ただし、v0.9の`TensorFlowDNNClassifier.save`はcheckpointファイルを作るものの、modelファイルを保存しないバグがある
 - 結果としてv0.9の`TensorFlowDNNClassifier.save`の結果を`restore`することができない
 - 詰む

というわけで、modelのsave, restoreをする必要がある場合、2016/07/18時点ではv0.8の利用が必要になります。
ただし、いろんなIssueで話題になってるので、この問題は近いうちに修正されるでしょう。

## v0.9のDNNClassifierはパフォーマンスが悪い
じゃぁsave, restoreはおいといて、ひとまずコードを`TensorFlowDNNClassifier`から`DNNClassifier`に
移そうか、、と思うのですが、v0.9の`DNNClassifier`はパフォーマンスがかなり悪いです。

`DNNClassifier`, `TensorFlowClassifier`で学習とテストデータ、およびstepを固定し、
fitにかかる時間とclassification_reportを計測してみると以下のような結果に。

### DNNClassifier

<pre>
             precision    recall  f1-score   support
          0       0.77      0.96      0.86      4265
          1       0.86      0.45      0.59      2231
avg / total       0.80      0.79      0.76      6496

elapsed_time: 7359.658695936203 [sec]
</pre>

### TensorFlowDNNClassifier

<pre>
             precision    recall  f1-score   support
          0       0.77      0.92      0.84      4265
          1       0.75      0.47      0.58      2231
avg / total       0.76      0.76      0.75      6496

elapsed_time: 68.16537308692932 [sec]
</pre>

まず、`DNNClassifier`は`TensorFlowDNNClassifier`と比較してprecisionが10%ほど向上。
おそらくデフォルトのハイパーパラメータが一部異なるのでしょう。原因は不明確ですが、ひとまず結果が良くなる分はまだ良いです。

問題は、elapsed_timeが68秒から7359秒とハチャメチャに長くなってる点。なんだこれは。。
これだと使い物にならなさすぎるので、Stackoverflowに投げてみたものの、2016/07/18時点ではまだ回答はありません。

- [Is DNNClassifier unstable compared with TensorFlowDNNClassifier?](http://stackoverflow.com/questions/38413172/is-dnnclassifier-unstable-compared-with-tensorflowdnnclassifier)

このとおり、`TensorFlowDNNClassifier`は近い将来`DNNClassifier`に乗り換える必要があるものの、
このパフォーマンス差はだと乗り換えは辛いです。100倍以上遅くなってるけど、これどうなるんでしょ・・・？
ちなみに、`DNNClassifier`は、CPU使用率も`TensorFlowDNNClassifier`と比較すると20%くらい高くて、
正直何もいいことが無い印象です。

## v0.8のTensorFlowDNNClassifierはv0.9と比較すると遅い

これまでの通り、v0.9は辛い状態かつmodelをsaveできない状態なので、
v0.9でチューニングしたハイパーパラメータでv0.8を利用してmodelをsaveさせることにします。

ところが、v0.8の`TensorFlowDNNClassifier`はv0.9と比較すると **約３倍遅い**結果に。

つまり、v0.9では実は`TensorFlowDNNClassifier`はDeprecatedになりながらも
内部では全体的にパフォーマンスが向上してるようですね。
もう、ここまでくるとDeprecaedにするのもやめてくれ、、、と思い始めます。

## v0.8のTensorFlowDNNClassifierはOptimizerを指定しているとmodelをsaveできない

v0.8でsave/restoreの調査を進めてて気づいた問題なのですが、

<pre>
optimizer = tf.train.AdagradOptimizer(learning_rate=learning_rate)
classifier = learn.TensorFlowDNNClassifier(hidden_units=units, n_classes=n_classes, steps=steps, optimizer=optimizer)
classifier.fit(features, labels)
classifier.save(model_dir)
</pre>

こんなかんじのコードをv0.8で実行すると、最後のsave時にJSONのシリアライズに失敗して
`ValueError("Circular reference detected")`が出てコケます。
ちなみにsaveを呼び出さない場合はコケないのでこれも地味に辛いです。

回避方法としては、「Optimizerは使わない」を選ぶしか無いのかな。この場合、learning rateを調整できないのが辛いですね。

<pre>
classifier = learn.TensorFlowDNNClassifier(hidden_units=units, n_classes=n_classes, steps=steps)
</pre>

ちなみにv0.9ではOptimizerを指定した`TensorFlowDNNClassifier`で`save`を呼び出してもエラーにはなりません。
ただし、modelデータの保存もできてないので、このバグが修正されたときにOptimizerのバグも治っているかどうかは不明です。

## まとめ

トラップだらけなのですが、modelのsave/restoreが必要な場合、

1. v0.8 + `TensorFlowDNNClassifier` を利用
2. save/restoreのバグが修正されるであろう、v0.9.1相当のリリースを待つ
3. `DNNClassifier`のパフォーマンスが上がってたら`TensorFlowDNNClassifier`から乗り換える。上がってなかったらしばらく使う

のような感じでしょうか。

まだまだTensorFlowの知識は少ないので、誤った情報がある場合はぜひ教えていただきたいです。


