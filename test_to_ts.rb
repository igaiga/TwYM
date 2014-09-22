# For Ruby 2.0, 2.1
require 'drb'
load 'config.rb'

#test_str = ['Hello world!','日本語のテストです。']
test_str = ['Hello world!','日本語のテストです。', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわおん５０あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわお１００あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらり１４０', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわおん５０', 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわおん５０あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわお１００']
#test_str = ['あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわおん５０あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらりるれろやいゆえよわお１００あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもらり１４０']
test_str << ARGV[0] if ARGV[0]

$ts = DRbObject.new_with_uri(TS_URL)
i = 1
while true
  message = "#{i} #{test_str[i%test_str.size]}"
  message += ' ☆' if i % 3 == 0
  message += ' *' if i % 5 == 0
  tweets = []
  tweets << {name: 'igaiga555',       face: 'https://si0.twimg.com/profile_images/2775085674/aacc6da0f43115bb2e60878e10a92377_bigger.jpeg' }
  tweets << {name: 'june29',          face: 'https://si0.twimg.com/profile_images/3433607286/e4cd5a708d9644957545b9b1165cf196_bigger.jpeg' }
  tweets << {name: 'hmsk',            face: 'https://si0.twimg.com/profile_images/1491871238/kengo05_bigger.png' }
  tweets << {name: "TwYM_tester_123", face:  '' } # twitter id 最大が15文字

  mb = {}
  mb[MESSAGE] = message
  tweet = tweets.shuffle.first
  mb[NICK] = tweet[:name]
  mb[FACE] = tweet[:face]
  p mb
  $ts.write([IRC, mb], TUPLE_AVAILAVLE_TIME)
  i += 1
  sleep 1
end
