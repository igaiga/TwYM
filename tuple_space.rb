#! ruby -Ku
# -*- coding: utf-8; -*-

require 'rinda/tuplespace'
load 'config.rb'

$ts = Rinda::TupleSpace.new
DRb.start_service(TS_URL, $ts)
puts DRb.uri
DRb.thread.join

