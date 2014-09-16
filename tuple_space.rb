# For Ruby 2.0, 2.1
require 'rinda/tuplespace'
load 'config.rb'

$ts = Rinda::TupleSpace.new
DRb.start_service(TS_URL, $ts)
puts DRb.uri
DRb.thread.join
