require 'multi_json'
class Api < Sinatra::Base
  
  before do
    content_type 'application/json'
  end
  
  get '/?' do
    MultiJson.dump Redirect.all
  end
  
end