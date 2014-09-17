$:.unshift File.join(File.dirname(__FILE__))

require 'rubygems'
require 'oauth'
require 'json'
require 'config.rb'

class OAuthAuthorizer
  def self.run
    consumer = OAuth::Consumer.new(
                                   TWITTER_OAUTH_CONSUMER_KEY,
                                   TWITTER_OAUTH_CONSUMER_SECRET, {
                                     :site => TWITTER_URL })

    request_token = consumer.get_request_token
    puts "The page have been opened in browser is for OAuth. "
    puts "URL : " + request_token.authorize_url
    system "open #{request_token.authorize_url}"

    puts 'input the oauth PIN code : (7-digit number. for example : 0123456)'
    pin = gets
    pin = pin.chomp!.slice(/^.{0,7}/)

    access_token = request_token.get_access_token(:oauth_verifier => pin)
    token        = access_token.token
    secret       = access_token.secret

    json = { :token => token, :secret => secret }.to_json
    File.open(TWITTER_OAUTH_CONFIG_FILE, "w") { |f|
      f.puts json
    }

  end
end


=begin
# test code
OAuthAuthorizer.run
at = File.read(TWITTER_OAUTH_CONFIG_FILE)
hash = JSON.parse(at)
p token  = hash['token']
p secret = hash['secret']
=end
