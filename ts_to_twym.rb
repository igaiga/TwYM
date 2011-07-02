#! ruby -Ku
# -*- coding: utf-8; -*-

require 'twym'
require 'drb'
load 'config.rb'

class TwymController
  def initialize
    @qc = ToQC.new
    @ts = DRbObject.new_with_uri(TS_URL)
  end

  def run
    loop do
      if @qc.send # 表示できるか問い合わせ
        # 表示できる
        mb_array = @ts.take([nil, nil])
        label = mb_array[0]
        mb = mb_array[1]
        # [:label, {:message=>"Hello world!", :nick=>"igaiga"}] の形式で取れる。
        puts  qc_str = "#{mb[NICK]}: #{mb[MESSAGE]}"
        @qc.send mb[NICK], mb[MESSAGE]
      else
        sleep 1
      end
    end
  end
end

#main
twym = TwymController.new
twym.run
