#! ruby -Ku
# coding: utf-8

require 'net/http'
require 'uri'
require 'rubygems'
require 'json'
require 'oauth'

require 'twitter_oauth_authorize.rb'

#HASHTAG = '#kosenconf'
#HASHTAG = '#twym'
HASHTAG = '#nowplaying'

#twym
require 'drb'
require 'config.rb'
$ts = DRbObject.new_with_uri(TS_URL)

# for OAuth
consumer = OAuth::Consumer.new(TWITTER_OAUTH_CONSUMER_KEY, TWITTER_OAUTH_CONSUMER_SECRET, {
     :site               => TWITTER_URL,
     :http_method        => :post })

unless (File.exist?(TWITTER_OAUTH_CONFIG_FILE))
  # ユーザーにOAuth認証をしてもらう
  OAuthAuthorizer.run
end

at = JSON.parse(File.read(TWITTER_OAUTH_CONFIG_FILE))
oauth_access_token  = at['token']
oauth_access_secret = at['secret']
access_token = OAuth::Token.new(oauth_access_token, oauth_access_secret)


uri = URI.parse('http://stream.twitter.com/1/statuses/filter.json')
Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data('track' => HASHTAG)
  request.oauth!(http, consumer, access_token)
  http.request(request) do |response|
    raise 'Response is not chuncked' unless response.chunked?
    response.read_body do |chunk|
      status = JSON.parse(chunk) rescue next
      next unless status['text']
      user = status['user']
      puts "#{user['screen_name']}: #{status['text']}"
      mb = Hash.new
      mb[NICK] = user['screen_name']
      mb[MESSAGE] = status['text'].gsub(/#{HASHTAG}/i,'')
      $ts.write([TWITTER, mb], TUPLE_AVAILAVLE_TIME)
    end
  end
end

