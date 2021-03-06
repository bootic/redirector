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
  
  describe '#del' do
    before do
      Redirect.set('www.foo.bar', 'www.bar.foo')
    end
    
    it 'deletes from redis' do
      Redirect.del('www.foo.bar')
      Redirect.get('www.foo.bar').should be_nil
    end
    
    it 'deletes with scheme' do
      Redirect.del('http://www.foo.bar')
      Redirect.get('www.foo.bar').should be_nil
    end
    
    it 'deletes with path' do
      Redirect.del('www.foo.bar/lala/lolo')
      Redirect.get('www.foo.bar').should be_nil
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
  
  describe '#all' do
    before do
      Redirect.set('www.foo.bar', 'www.bar.foo')
      Redirect.set('http://lalala.com', 'http://foobar.cl')
    end
    
    it 'lists all' do
      Redirect.all.should == {'www.foo.bar' => 'http://www.bar.foo', 'lalala.com' => 'http://foobar.cl'}
    end
  end
end