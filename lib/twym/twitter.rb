require 'excon'
require 'json'
require 'simple_oauth'

module TwYM
  class Twitter
    DEFAULT_KEYWORD = 'nowplaying'

    attr_reader :config, :channel, :keyword

    def initialize(config, keyword: DEFAULT_KEYWORD)
      @config = config
      @keyword = keyword

      @channel = TwYM::Channel::MessageChannel.new
      @buffer = Buffer.new
    end

    def run
      streamer = ->(chunk, __remaining_bytes, __total_bytes) do
        entities = @buffer << chunk

        entities.each do |entity|
          begin
            tweet = JSON.parse(entity)
            @channel << create_message(tweet)
          rescue => e
            puts "Failed to handle the tweet: #{e}"
          end
        end
      end

      parameters = create_parameters(keyword)
      headers = create_headers(parameters)

      connection = Excon.new(twitter_url)
      connection.request(method: 'GET', query: parameters, headers: headers, response_block: streamer)
    end

    private

    def twitter_url
      'https://userstream.twitter.com/1/statuses/filter.json'
    end

    def twitter_oauth_config
      twitter_config = config['twitter']
      {
        consumer_key: config['consumer_key'],
        consumer_secret: config['consumer_secret'],
        token: config['access_token'],
        token_secret: config['access_token_secret'],
      }
    end

    def create_parameters(keyword)
      {
        track: keyword,
      }
    end

    def create_headers(parameters)
      authorization = create_oauth_header(parameters)

      {
        'Authorization' => authorization,
      }
    end

    def create_oauth_header(parameters)
      header = SimpleOAuth::Header.new('GET', twitter_url, parameters, twitter_oauth_config)
      header.to_s
    end

    def create_message(tweet)
      name = tweet['user']['screen_name']
      text = tweet['text']
      image_url = tweet['user']['profile_image_url']

      TwYM::Message::Post.new(name, text, image_url)
    end

    class Buffer
      NEWLINE = "\r\n"

      def initialize
        @string = ''
      end

      def <<(chunk)
        finished = chunk.length >= 2 && chunk[-2..-1] == NEWLINE

        current = @string + chunk
        entities = current.split NEWLINE
        @string = finished ? '' : entities.pop

        entities
      end
    end
  end
end
