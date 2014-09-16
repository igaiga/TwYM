# For Ruby 2.0, 2.1
require 'drb'
require_relative 'twym'
load 'config.rb'

class TwymController
  def initialize
    @qc = ToQC.new
    @ts = DRbObject.new_with_uri(TS_URL)
  end

  def run
    loop do
      @qc.display_second = display_second
      if @qc.send # 表示できるか問い合わせ
        # 表示できる
        mb_array = @ts.take([nil, nil])
        label = mb_array[0]
        mb = mb_array[1]
        # [:label, {:message=>"Hello world!", :nick=>"igaiga"}] の形式で取れる。
        puts  qc_str = "#{mb[NICK]}: #{mb[MESSAGE]}"
        @qc.send mb[NICK], mb[MESSAGE], mb[FACE]
      else
        sleep 1
      end
    end
  end

  def display_second
    waitings = @ts.read_all([nil,nil])
    puts "waitings.size = #{waitings.size}"
    case
    when waitings.size < 2
      8
    when waitings.size < 5
      3
    else
      1
    end
  end

end

#main
twym = TwymController.new
twym.run
