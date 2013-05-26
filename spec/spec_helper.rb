require File.join File.dirname(__FILE__), '../lib/twym'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
