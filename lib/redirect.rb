class Redirect
  
  class InvalidURL < StandardError; end
  
  PREFIX = 'btc:rd'.freeze
  
  def self.connect!(opts = {})
    @redis = Redis.new(opts)
  end
  
  def self.connected?
    !!@redis
  end
  
  def self.get(host)
    uri = build_uri(host)
    canonical = redis.get(prefixed(uri.host))
    canonical ? new(canonical) : nil
  end
  
  def self.set(host, canonical)
    uri_host = build_uri(host)
    uri = build_uri(canonical)
    redis.set(prefixed(uri_host.host), "#{uri.scheme}://#{uri.host}")
  end
  
  def initialize(canonical)
    @canonical = URI.parse(canonical)
  end
  
  def with_path(path, query = nil)
    canonical.path = path
    canonical.query = query
    self
  end
  
  def to_s
    canonical.to_s
  end
  
  def self.redis
    @redis
  end
  
  private
  
  attr_reader :canonical
  
  def self.prefixed(string)
    [PREFIX, string].join(':')
  end
  
  def self.build_uri(url)
    if url =~ URI::regexp
      uri = URI.parse(url)
    else
      url = "http://#{url}"
      if url =~ URI::regexp
        uri = URI.parse(url)
      else
        raise InvalidURL, "#{url} is not a valid URL"
      end
    end
    uri
  end
  
end