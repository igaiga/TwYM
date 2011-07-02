#! ruby -Ku
# -*- coding: utf-8; -*-
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

  mb = Hash.new
  mb[NICK] = "TwYM_tester"
  mb[MESSAGE] = message
  p mb
  $ts.write([IRC, mb], TUPLE_AVAILAVLE_TIME)
  i += 1
  sleep 1
end
