require 'multi_json'
class Api < Sinatra::Base
  
  use Rack::Auth::Basic, "Protected Area" do |username, password|
    username == 'x' && password == ENV['REDIRECTOR_API_TOKEN']
  end
    
  before do
    content_type 'application/json'
  end
  
  get '/?' do
    MultiJson.dump Redirect.all
  end
  
  post '/redirects' do
    if payload['from'].nil? || payload['to'].nil?
      invalid "JSON payload must have :from and :to URLs"
    else
      Redirect.set payload['from'], payload['to']
      MultiJson.dump message: 'done'
    end
  end
  
  delete '/redirects' do
    host = payload['from']
    if host.nil?
      invalid "JSON payload must include :from URL"
    else
      Redirect.del host
      status 204
      ''
    end
  end
  
  helpers do
    
    def payload
      @payload ||= MultiJson.load(request.body.read)
    end
    
    def invalid(msg)
      status 422
      MultiJson.dump message: msg
    end
  end
  
end