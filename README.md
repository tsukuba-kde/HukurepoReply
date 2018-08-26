## Hukurepo_reply
### 概要
Hukurepoの困りごとにSlackで返信してくれるSlack bot

### 想定する環境
* 現在、ruby 2.4.4 での実行を確認しています
* Gemfileにかいてあるrubyライブラリが必要です（bundle installでインストールする）

### 設定
1. Hukurepo APIのTOKENをもらって、ボット実行環境で環境変数 HUKUREPO_API_TOKEN に設定する
2. Slack APIで新しいAPIをつくる
  * botをつくる
  * PermissionのScopeを追加する
    * channels:history
    * channels:read
    * chat:write:bot
    * bot
    * reaction:write
  * Install Appする
  * OAuth Access Tokenをコピーして、ボット実行環境で環境変数 HUKUREPO_SLACK_TOKEN に設定する
3. ボットの実行環境で、rubyライブラリをインストールしてください

```
% bundle install
```

4. ボットの実行環境で、rubyプログラムを実行してください
```
% bundle exec ruby hukurepo_reply.rb
```
* connected. と表示されたらslackとの接続が完了しています。

5. ボットを止めたい時はCtrl-cで止めてください。

### 使い方
* Hukurepoから送られて来た困りごとに対して、スレッドを作って回答を返信してください。
* ボットが回答を確認したら、thumbsup(:+1:)がリアクションされます。
* Hukurepoが回答を確認したら、Hukurepo Postから返信が来ます。

### デプロイ先がHerokuの時の設定方法
* (後で書く)