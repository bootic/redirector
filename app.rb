require 'sinatra/base'

APP_ROOT = File.expand_path(File.dirname(__FILE__))
$:<< APP_ROOT

require 'lib/redirect'
require 'lib/api'
require 'lib/redirector'

Redirect.connect!

App = Rack::Builder.new {
  map "/api" do
    run Api
  end
  
  map '/' do
    run Redirector
  end
}