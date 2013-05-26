module TwYM
  module Message
    class Post
      attr_reader :nick, :text, :image_url

      def initialize(nick, text, image_url)
        @nick = nick
        @text = text
        @image_url = image_url
      end
    end
  end
end
