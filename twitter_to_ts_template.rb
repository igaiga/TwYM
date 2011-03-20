#! ruby -Ku
# coding: utf-8
$:.unshift File.join(File.dirname(__FILE__))

require 'net/http'
require 'uri'
require 'rubygems'
require 'json'
require 'oauth'

require "twitter/json_stream"
require "eventmachine"

require 'twitter_oauth_authorize.rb'

#HASHTAG = 'kosenconf'
#HASHTAG = 'glt'
#HASHTAG = 'twym'
#HASHTAG = 'nowplaying'
HASHTAG = 'iphone'

require 'drb'
require 'config.rb'
$ts = DRbObject.new_with_uri(TS_URL)

# for OAuth
# consumer = OAuth::Consumer.new(TWITTER_OAUTH_CONSUMER_KEY, TWITTER_OAUTH_CONSUMER_SECRET, {
#      :site               => TWITTER_URL,
#      :http_method        => :post })

# unless (File.exist?(TWITTER_OAUTH_CONFIG_FILE))
#   # ユーザーにOAuth認証をしてもらう
#   OAuthAuthorizer.run
# end

# at = JSON.parse(File.read(TWITTER_OAUTH_CONFIG_FILE))
# oauth_access_token  = at['token']
# oauth_access_secret = at['secret']
# access_token = OAuth::Token.new(oauth_access_token, oauth_access_secret)

query = URI.encode(HASHTAG)
#query = ARGV.shift
#raise "please give some query" if query.nil?

#BASIC_認証
twitter_id   = "username"
twitter_pass = "password"

EventMachine::run {
  EventMachine::defer {
    stream = Twitter::JSONStream.connect(
               :path => "/1/statuses/filter.json?track=#{query}",
                                         :auth => "#{twitter_id}:#{twitter_pass}"
             )

    stream.each_item do |status|
      tweet = JSON.parse(status)      
      screen_name = tweet['user']['screen_name']
      body = tweet['text']
      puts "#{screen_name}: #{body}"
      mb = Hash.new
      mb[NICK] = screen_name
      mb[MESSAGE] = body.gsub(/#{query}$/i,'')
      $ts.write([TWITTER, mb], TUPLE_AVAILAVLE_TIME)
    end
  }
}
