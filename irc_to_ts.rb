# For Ruby 2.0, 2.1
require 'drb'
require 'cinch'
load 'config.rb'

$ts = DRbObject.new_with_uri(TS_URL)

class IrcController
  def initialize(server: "chat.us.freenode.net", channels: ["#rubykaigi"])
    @bot = Cinch::Bot.new do
      configure do |c|
        c.server = server
        c.channels = channels
        c.nick = "twym"
      end

      on :message do |m|
        p "#{m.user.nick}: #{m.message}"
        mb = { NICK => m.user.nick, MESSAGE => m.message }
        $ts.write([IRC, mb], TUPLE_AVAILAVLE_TIME)
      end
    end
  end
  def run
    @bot.start
  end
end

IrcController.new(server: "irc.rubykaigi.org", channels: ["#rubykaigi", "#hall-a"]).run
