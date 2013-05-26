#! ruby -Ku
# -*- coding: utf-8; -*-

require 'socket'
require 'nkf'
load 'config.rb'

IMAGE_DIR = RUBYISTS_DIR
DISPLAY_SECOND = 30
URL_PORT = 60101
DISPLAY_SECOND_PORT = 60110

def send_UDP(str_u8, port)
  # 改行コード除去
  str_u8.gsub! /\r/,'' # 日本語文字列にchopを使うとエラーになるので gsubで
  str_u8.gsub! /\n/,''

  socket = UDPSocket.open()
  socket.connect(@address, port)
  p "#{port}: #{str_u8}"

  # nkf
  str_u32BE = NKF.nkf('-w32B0 -W',str_u8) # out: UTF-32(non BOM), in: UTF-8(non BOM)
  
  socket.send(str_u32BE, 0)
end

files = Dir.glob("#{IMAGE_DIR}/**")

while true
  p rubyist = files.sample
  send_UDP(rubyist, URL_PORT)
#  send_UDP(DISPLAY_SECOND.to_s, DISPLAY_SECOND_PORT) # disable now
#  次の画像が送信されたら切り替わる
  sleep DISPLAY_SECOND
end
