#! ruby -Ku
# coding: utf-8

TS_URL = 'druby://localhost:12555'
NICK = :nick
MESSAGE = :message
FACE = :face
IRC = :irc
TWITTER = :twitter
FACE_DEFAULT = "file:///Users/igarashi/twym/twym_github/ruby.png" # 画像が取得できなかったときの表示画像URL
TUPLE_AVAILAVLE_TIME = 30 #sec
  #↑この時間以上経過したメッセージは表示しない

# twitter
TWITTER_OAUTH_CONSUMER_KEY    = 'Fwt207Mk1k6SPACXrVoK6Q' # for twym
TWITTER_OAUTH_CONSUMER_SECRET = 'eTYqz70dB3QLcuU5RBJCGyW6VJogz32PBQXteZ5Y' # for twym
TWITTER_URL = 'http://twitter.com'
TWITTER_OAUTH_CONFIG_FILE = 'config_twitter_oauth_access_token.rb'
