ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler"
Bundler.setup

require File.expand_path(File.join(File.dirname(__FILE__), 'app'))

run App