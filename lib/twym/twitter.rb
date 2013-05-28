require 'json'
require 'uri'
require 'yaml'
require 'twitter/json_stream'

module TwYM
  class Twitter
    DEFAULT_QUERY = 'nowplaying'

    attr_reader :config, :channel

    def initialize(config)
      @config = config
      @channel = TwYM::Channel::MessageChannel.new
    end

    def run
      EventMachine::run do
        EventMachine::defer do
          stream = ::Twitter::JSONStream.connect(em_parameters)

          stream.each_item do |status|
            begin
              tweet = JSON.parse(status)
              message = create_message(tweet)
              channel << message
            rescue => e
              puts "Error: #{e}"
            end
          end
        end
      end
    end

    def em_parameters(query: DEFAULT_QUERY)
      {
         ssl: true,
         port: 443,
         path: "/1/statuses/filter.json?track=#{URI.encode query}",
         oauth: {
           consumer_key: config['consumer_key'],
           consumer_secret: config['consumer_secret'],
           access_key: config['access_token'],
           access_secret: config['access_token_secret'],
         }
      }
    end

    def create_message(tweet)
      name = tweet['user']['screen_name']
      text = tweet['text']
      image_url = tweet['user']['profile_image_url']

      TwYM::Message::Post.new(name, text, image_url)
    end
  end
end
