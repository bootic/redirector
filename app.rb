require 'sinatra/base'
require "redis"
require 'uri'

$:<< File.expand_path(File.dirname(__FILE__))

require 'lib/redirect'

Redirect.connect!

class App < Sinatra::Base
  
  get '/*' do
    host = request.env['SERVER_NAME']
    if record = Redirect.get(host)
      redirect record.with_path(request.env['PATH_INFO'], request.env['QUERY_STRING']).to_s, 301
    else
      status 404
      erb :not_found
    end
  end
  
end