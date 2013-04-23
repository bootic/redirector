class Redirector < Sinatra::Base
  
  set :root, APP_ROOT
  
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