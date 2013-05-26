require 'quartz_composer/channel'

module TwYM
  module Channel
    class Base
      attr_reader :qc_channels

      def initialize(address: '225.0.0.0')
        @qc_channels = ports.each_with_object({}) do |(name, port), cs|
          cs[name] = QuartzComposer::Channel.new(port, address: address)
        end
      end

      private

      def ports
        raise NotImplementedError, "#{self.class}#ports missing"
      end

      def send_message(ch_name, str)
        ch = qc_channels[ch_name]
        ch << str
      end
    end

    class MessageChannel < Base
      def ports
        {
          name:  50100,
          line0: 50101,
          line1: 50102,
          line2: 50103,
          line3: 50104,
          line4: 50105,
          face:  50109,
          display_sec: 50110,
        }
      end

      def <<(message)
        texts = split_message(message.text)
        send_message :name, message.nick
        (0..4).each {|i| send_message :"line#{i}", texts[i] || ' ' }
        send_message :face, message.image_url
        send_message :display_sec, 10.to_s
        self
      end

      def split_message(str, n: 24)
        if str.nil? || str.empty?
          []
        else
          split_message(str[n..-1], n: n).unshift str.slice(0, n)
        end
      end
    end
  end
end
