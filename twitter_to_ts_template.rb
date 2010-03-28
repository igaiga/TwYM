#! ruby -Ku
# coding: utf-8

#twitter stream api
require 'net/http'
require 'uri'
require 'rubygems'
require 'json'
USERNAME = 'igaiga555'# twitter user name
PASSWORD = 'passwd' # twitter password 
#HASHTAG = '#kosenconf'
#HASHTAG = '#twym'
HASHTAG = '#nowplaying'

#twym
require 'drb'
load 'config.rb'
$ts = DRbObject.new_with_uri(TS_URL)

uri = URI.parse('http://stream.twitter.com/1/statuses/filter.json')
Net::HTTP.start(uri.host, uri.port) do |http|
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data('track' => HASHTAG)
  request.basic_auth(USERNAME, PASSWORD)
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

