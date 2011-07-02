#!ruby -Ku
# -*- coding: utf-8; -*-

# path setting
this_file_s_path = File.expand_path(File.dirname(__FILE__))
twym_path = File.expand_path(this_file_s_path + "/")
$LOAD_PATH.unshift twym_path
$LOAD_PATH.unshift this_file_s_path

require 'socket'
require 'nkf'
require 'pp'
# ruby1.9はUTF-32BEを扱うのに標準ライブラリ kconv を使う
#require 'kconv'

class QC_ports
  attr_accessor :id, :name, :line1, :line2, :line3, :line4, :time
  def initialize(id, name_port, line1_port, line2_port, line3_port, line4_port)
    @id = id
    @name = name_port
    @line1 = line1_port
    @line2 = line2_port
    @line3 = line3_port
    @line4 = line4_port
    @time = nil # 前回送信した時刻
  end
end

class Message
  attr_accessor :name
  attr_reader :line1, :line2, :line3, :line4

  def initialize(name, str)
    @name     = name
    @org_str  = str.clone
    @work_str = str
    init_lines
  end

  def split_to_lines(size)
    return ' ' unless @work_str # 空文字列送信するとQC側で前の文字列が残っちゃうので space 送る
    str = @work_str.slice! /\A(.{#{size}})/
    unless str #全文字処理完了
      str = @work_str
      @work_str = nil
    end
    str = ' ' if str == '' #上記の理由で空文字送信防止
    str
  end

  def init_lines
    @line1 = split_to_lines(20) #文字数
    @line2 = split_to_lines(40)
    @line3 = split_to_lines(40)
    @line4 = split_to_lines(40)
  end

end

class ToQC
  public
  def initialize
    @DISPLAY_SEC = 11 #sec # 表示秒数を変える場合は、QC側も変更する必要がある。
    @address = '225.0.0.0'
    @ports = []
    @ports << QC_ports.new(1, 50100, 50101, 50102, 50103, 50104)
    @ports << QC_ports.new(2, 50200, 50201, 50202, 50203, 50204)
    @ports << QC_ports.new(3, 50300, 50301, 50302, 50303, 50304)
    @port_star =  51001
    @queue = Array.new
  end

  def queue_empty?
    @queue.empty?
  end

  # 未表示文を押し出したいときは引数なしで呼び出し
  # 戻り値 true: 全部表示できました
  #   false: いっぱいで待ち状態です
  def send(name = nil, str = nil)
    @queue.push Message.new(name, str) unless name == nil # 一度queueにいれる
    return true if @queue.empty?
    message = @queue.shift # queue 先頭から取り出し
    result = send_message(message)
    if result == false
      @queue.unshift message # queue の先頭に戻す
      return false # まだ表示したいのだけど、空き無し
    end
    send unless @queue.empty? # もっと表示できるかもの自己問い合わせ
    return true # 全部表示できた
  end

  private

  # 前の送信からX秒経過したportがあれば送信
  def send_message(message)
    @ports.each do | port |  
       now = Time.now
       if port.time == nil || port.time < now - @DISPLAY_SEC # sec
         send_message_every_ports(port, message)
         return true
       end
     end
    return false # 送信できなかったので差し戻し
   end

  def send_message_every_ports(port, message)
    pp message
    send_star('star')               # star
    send_UDP(message.name,  port.name)   # メッセージ name
    send_UDP(message.line1, port.line1)  # メッセージ 1行目
    send_UDP(message.line2, port.line2)  # メッセージ 2行目
    send_UDP(message.line3, port.line3)  # メッセージ 3行目
    send_UDP(message.line4, port.line4)  # メッセージ 4行目
    port.time = Time.now
  end
  
  def send_star(str)
    str_u8 = NKF.nkf('--utf8', str) # out:UTF8(non BOM)
    if str_u8 =~ /\*/ui or str_u8 =~ /★/u or str_u8 =~ /☆/u # u: UTF-8, i: 大文字小文字無視
      send_UDP("star", @port_star)
   end
  end

  def send_UDP(str_u8, port)
    # 改行コード除去
    str_u8.gsub! /\r/,'' # 日本語文字列にchopを使うとエラーになるので gsubで
    str_u8.gsub! /\n/,''

    socket = UDPSocket.open()
    socket.connect(@address, port)
    p "#{port}: #{str_u8}"

    # nkf
    str_u32BE = NKF.nkf('-w32B0 -W',str_u8) # out: UTF-32(non BOM), in: UTF-8(non BOM)
    #ruby1.9.1
    #  str_u32BE = Kconv.kconv(str_u8,  Kconv::UTF32,  Kconv::UTF8)
    
    socket.send(str_u32BE, 0)
  end
end

