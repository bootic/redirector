require "rubygems"
require "bundler"
Bundler.setup

ENV['RACK_ENV'] ||= 'test'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'app'))
require 'rspec'

RSpec.configure do |config|
  config.before do
    Redirect.redis.select 3
    Redirect.redis.flushdb
  end
end