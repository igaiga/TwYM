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

query = URI.encode(HASHTAG)
#query = ARGV.shift
#raise "please give some query" if query.nil?

#BASIC_認証
twitter_id   = "username"
twitter_pass = "password"
# StreamAPIでは将来に渡ってBasic認証で良いらしい
# http://dev.twitter.com/pages/auth_overview
# The Streaming API supports both basic and OAuth authentication on stream.twitter.com. For the time being there is no date on which basic authentication will be turned off for the Streaming API so you are free to choose whichever method you wish. On User Streams and Site Streams, OAuth is required.

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
