require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

describe Redirect do
  
  describe '.set' do
    it 'sets two bare hosts' do
      Redirect.set('www.foo.bar', 'www.bar.foo')
      Redirect.redis.get('btc:rd:www.foo.bar').should == 'http://www.bar.foo'
    end
    
    it 'sets with scheme in key' do
      Redirect.set('http://www.foo.bar', 'www.bar.foo')
      Redirect.redis.get('btc:rd:www.foo.bar').should == 'http://www.bar.foo'
    end
    
    it 'sets with scheme in host' do
      Redirect.set('www.foo.bar', 'http://www.bar.foo')
      Redirect.redis.get('btc:rd:www.foo.bar').should == 'http://www.bar.foo'
    end
    
    it 'raises if host is invalid' do
      expect {
        Redirect.set('www.foo.bar', 'foo bar')
      }.to raise_error(URI::InvalidURIError)
    end
  end
  
  describe '#get' do
    before do
      Redirect.set('www.foo.bar', 'www.bar.foo')
      @redirect = Redirect.get('www.foo.bar')
    end
    
    it 'is the canonical host with scheme' do
      @redirect.to_s.should == 'http://www.bar.foo'
    end
    
    describe '.with_path' do
      it 'adds path to canonical host' do
        @redirect.with_path('/lala/lele').to_s.should == 'http://www.bar.foo/lala/lele'
      end
      
      it 'adds querystring' do
        @redirect.with_path('/lala/lele', 'la=1').to_s.should == 'http://www.bar.foo/lala/lele?la=1'
      end
    end
  end
end