TwYM (Timer with Your Messages)
時間と想いを共有するタイマー

- about TwYM
IRC, twitter のメッセージを表示できるタイマーです。

- Environment
-- Mac OS X Snow Leopard
--- Leopardでは動作すると思います。未確認です。 
--- Tigerでは動作しないと思います。未確認です。 
-- ruby 1.8.7
--- ruby1.9.1 では動作しません。(本体およびnadokaが未対応)

- 使用している外部ライブラリのライセンスにも同意した上でご利用ください。
-- nadoka　(IRC bot framework)
--- http://www.atdot.net/nadoka/nadoka.ja.html
-- json (jsonファイルパースライブラリ)

- Files
-- readme.txt
-- TwYM.qtz : Quartz Composer File (GUIフロントエンド)
-- TwYM.rb : TwYM.qtz へメッセージ文字列を送信
-- config.rb : 設定ファイル
-- tuple_space.rb 中間キュー
-- ts_to_twim.rb 中間キューからQCへ送信するスクリプト
-- test_to_ts.rb 中間キューへテスト文字列を送信するスクリプト
-- twymbot.nb nadokaから中間キューへ送信するnadoka bot設定ファイル
-- friendchart_nadokarc : nadoka 設定ファイルサンプル(friend-chat)
-- ustream_nadokarc : nadoka 設定ファイルサンプル(ustream)
-- twitter_to_ts_template.rb twitterから中間キューへ送信するスクリプト

- install
-- setup.sh
 $ ./setup.sh
setup.sh を実行すると、nadoka を 取得し、設定ファイルを配置します。
詳細はsetup.shを読んでください。

-- IRC をメッセージを表示する場合
--- nadokarc を編集します。
下記の箇所を修正してください。
詳細はnadokaの説明書を参照してください。
動作しない場合、サンプルファイル *_nadokarc も参考にしてください。
                                   
  Servers = [
    { :host => 'chat1.ustream.tv', # IRC server address
      :port => (6667),                       # default: 6667
      :pass => 'passwd',                    # ustreamの場合はここにパスワードを指定
#      :pass => nil,                              # パスワード無しの場合
    }
  ]

...
  User     = 'twym'# IRC 内でのbotの名前(好きな名前でOKですが、ustreamの場合はuserIDを指定)
  Nick     = 'twym' # IRC 内でのbotの名前(好きな名前でOKですが、ustreamの場合はuserIDを指定)
...
  Channel_info = {
    '#genesislightningtalks' => { # channel名
      :timing  => :startup,
      :log     => '${setting_name}-nadoka-chan/%y%m%d.log',
    },
  }

-- Twitterをメッセージを表示する場合
--- 下記のコマンドで json ライブラリをインストールします
--- $ sudo gem install json
--- または、下記から json ライブラリをダウンロードして配置してください
--- http://rubyforge.org/frs/?group_id=953
--- twitter_to_ts_template.rb の下記の箇所を編集して、例えば twitter_to_ts.rb という名前で保存してください。
 USERNAME = 'igaiga555'# twitter user name
 PASSWORD = 'pass' # twitter password 
 HASHTAG = '#nowplaying' # twitter hashtag

- run
-- TwYM.qtz を起動します
-- 中間キューを起動します
 ターミナルから以下を起動します。
 $ ruby tuple_space.rb 
 druby://localhost:12555 と表示されればOKです。
-- 中間キュー→QC スクリプトを起動します
 別のターミナルから以下を起動します。
 $ ruby ts_to_twym.rb
-- テストスクリプトで中間キューに文字列を投げてみます。
 別のターミナルから以下を起動します。
 $ ruby test_to_ts.rb
   QC側に文字列が表示されればOKです。ctrl+c で停止します。
   QC側で文字化けなどする場合は rbuconv がうまく動いてない可能性があります。
-- IRCに接続する方法
--- nadokaを起動します
 別のターミナルから以下を起動します。
 $ cd nadoka
 $ ruby nadoka.rb -r ../friendchat_nadokarc
-- Twitterに接続する方法
 別のターミナルから以下を起動します。
 $ ruby twitter_to_ts.rb
※あらかじめ、ソース内の以下を書き換えておいてください。
USERNAME, PASSWORD, HASHTAG

- TwYM.qtz 操作方法
  Input Parameters を押すと時間設定、
  タイマーとコメントとSTAR機能の表示有無、
  メッセージ位置の調整などができます。
  主なショートカットキーは cmd+f で全画面化、
  cmd+. で停止、cmd+r で開始、cmd+t で設定画面 です。
  また、STAR機能が有効の場合は、★ or ☆ or * で星マーク(変更可能)が画面に表示されます。

- How is TwYM working?
--中間キュー -> QuartzComposer
UDP で通信しています。
ts_to_twym.rb が TwYM.rb を使ってQCへ送信しています。
-- IRC, twitter, test  -> 中間キュー
drb を使って通信しています。

- 表示されないコメントがある
  config.rb 
    TUPLE_AVAILAVLE_TIME = 30 #sec
TUPLE_AVAILAVLE_TIME 以上経過したコメントは破棄しています。
必要に応じて長さを変えてください。

- license
new BSD license

- about creator
igaiga [at] gmail.com
http://igarashikuniaki.net/tdiary/
http://code.google.com/p/twym/
http://github.com/igaiga

イベントや勉強会などで使っていただけるとうれしいです。
使いました報告をもらえると小躍りして喜びます。ヽ(´▽`)ノ

- 今後やりたいこと
-- デザイン改良
-- gem対応
-- ruby1.9対応
-- gitHubで開発

-- Ver.0.80
--- 2010.3.28
メッセージ表示を140文字へ拡張
rbuconvを標準ライブラリnkfで置き換え
バグ修正
 QC で表示が黒帯になる問題修正

-- Ver.0.70
--- 2010.3.15
仕組みを全面更新
Rindaを使い中間キュー機能を実装
twitter機能追加
文字化けすることがあるバグを修正
qrzファイルをリファクタリング

-- Ver.0.60
--- 2009.8.1
STAR機能を追加
botファイルの名前を変更

-- Ver.0.50
--- 2009.4.19
仕組みを全面更新
表示まで最大20秒あった遅延を解消
QCへの受け渡しを yaml,rss からUDP通信に変更
$LOAD_PATH設定を追加

-- Ver.0.10
--- 2008.11.2
公開
