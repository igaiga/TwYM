# TwYM (Timer with Your Messages)
時間と想いを共有するタイマー

## about TwYM
IRC, twitter のメッセージを表示できるタイマーです。

## Environment
- Mac OS X
  - Quartz Composer (Apple のサイトからダウンロードしてインストールしてください)
- Ruby 2.0, 2.1

## Files
- readme.md
- TwYM.qtz : Quartz Composer File (GUIフロントエンド)
- TwYM.rb : TwYM.qtz へメッセージ文字列を送信
- config.rb : 設定ファイル
- Gemfile : bundler 設定ファイル
- Gemfile.lock : bundler 設定ファイル
- tuple_space.rb : 中間キュー
- ts_to_twim.rb : 中間キューからQCへ送信するスクリプト
- test_to_ts.rb : 中間キューへテスト文字列を送信するスクリプト
- irc_to_ts.rb : IRCから中間キューへ送信するスクリプト
- twitter_to_ts.rb : twitterから中間キューへ送信するスクリプト
- twitter_oauth_authorize.rb : twitter OAuth認証クラス

## Install
下記のコマンドで gemパッケージをインストールします。（必要に応じて sudo してください。）
- $ gem install bundler
- $ bundle install

## Run
- TwYM.qtz を起動します
- 中間キューを起動します
  - ターミナルから以下を起動します。
  - $ ruby tuple_space.rb 
  - druby://localhost:12555 と表示されればOKです。
- 中間キュー→QC スクリプトを起動します
  - 別のターミナルから以下を起動します。
  - $ ruby ts_to_twym.rb
- テストスクリプトで中間キューに文字列を投げてみます。
  - 別のターミナルから以下を起動します。
  - $ ruby test_to_ts.rb
  -   QC側に文字列が表示されればOKです。ctrl+c で停止します。
- Twitterに接続する方法
  - 別のターミナルから以下を起動します。
  - $ ruby twitter_to_ts.rb [検索語]
  -  例) $ ruby twitter_to_ts.rb iphone
    - ※[検索語]を指定しない場合は、ソース内のHASHTAG で検索します。
　  - HASHTAG を上書きすることでも検索語を指定可能です。
  - 初回のOAuth認証
    -  初回起動時にOAuth認証を行います。
    -  ブラウザが起動してtwitterのOAuth認証画面が表示されますので、
    -  確認の上、allow を選択するとPIN番号(7桁数字)が表示されます。
    -  PIN番号をコンソールへ入力してください。
  - 別のアカウントでログインする場合
    - config_twitter_oauth_access_token.rb を削除してから、いつものように
    -  $ ruby twitter_to_ts.rb
    - を起動してください。
- IRCに接続する方法
  - 別のターミナルから以下を起動します。
  - $ ruby irc_to_ts.rb
  - server, channel を変更する場合
    - `IrcController.new(server: "chat.us.freenode.net", channels: ["#rubykaigi", "#rubykaigi-1"]).run` を変更してください

## TwYM.qtz 操作方法
-  Input Parameters を押すと時間設定、タイマーとコメントとSTAR機能の表示有無、メッセージ位置の調整などができます。
-  主なショートカットキー 
  - cmd+f : 全画面化
  - cmd+. : 停止
  - cmd+r : 開始
  - cmd+t : 設定画面
- STAR機能が有効の場合は、★ or ☆ or * で星マーク(変更可能)が画面に表示されます。

## How is TwYM working?
- 中間キュー(tupple_space) -> QuartzComposer
  - UDP で通信しています。
  - ts_to_twym.rb が TwYM.rb を使ってQCへ送信しています。
- IRC, twitter, test  -> 中間キュー
  - drb を使って通信しています。

- 表示されないコメントがある
```
config.rb 
  TUPLE_AVAILAVLE_TIME = 30 #sec
```
TUPLE_AVAILAVLE_TIME 以上経過したコメントは破棄しています。必要に応じて長さを変えてください。

## License
new BSD license

## About creator
- igaiga [at] gmail.com
- http://github.com/igaiga/TwYM
- http://igarashikuniaki.net/tdiary/

イベントや勉強会などで使っていただけるとうれしいです。
使いました報告をもらえると小躍りして喜びます。ヽ(´▽`)ノ

## Contributer
- @_ko1 (Nadoka)
- @m_seki (Rinda)
- @yoozoosato
- @yamaguchiintlab
- @june29
- @kei_s
- @mitaku
- @sora_h
- @cesare
- @120reset
- @murokaco
ご協力ありがとうございます。

## 今後やりたいこと
- 定期的なメンテナンス
- デザイン改良
- gem化

## Version History

### Ver.1.10
- 2014.9.14
- Add cinch gem instead of Nadoka for IRC.
  - Nadoka と、作者の笹田さんに深く感謝いたします。
- Ruby 2.0, 2.1 対応

### Ver.1.00 at Chicago Starbucks
- 2011.10.27
- キューの待ち個数に応じて表示時間を変更
- twitter の仕様変更に伴い接続をSSLに変更
- bundler対応

### Ver.0.90
- 2011.3.21
- twitter データ取得をtwitter-streamライブラリを使うよう変更(取得漏れ対応)
  - (june29さんにご協力いただきました。ありがとうございました。)

### Ver.0.81
- 2010.8.14
- twitter OAauth認証対応

### Ver.0.80
- 2010.3.28
- メッセージ表示を140文字へ拡張
- rbuconvを標準ライブラリnkfで置き換え
- バグ修正
-  QC で表示が黒帯になる問題修正
- githubにリポジトリ作成

### Ver.0.70
- 2010.3.15
- 仕組みを全面更新
- Rindaを使い中間キュー機能を実装
- twitter機能追加
- 文字化けすることがあるバグを修正
- qrzファイルをリファクタリング

### Ver.0.60
- 2009.8.1
- STAR機能を追加
- botファイルの名前を変更

### Ver.0.50
- 2009.4.19
- 仕組みを全面更新
- 表示まで最大20秒あった遅延を解消
- QCへの受け渡しを yaml,rss からUDP通信に変更
- $LOAD_PATH設定を追加

### Ver.0.10
- 2008.11.2
- 公開
