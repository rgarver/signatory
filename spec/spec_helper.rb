require 'rubygems'
begin
  require 'debugger'
rescue LoadError
  puts "Debugger is disabled"
end
require 'stringio'
require 'rspec'
begin
  require 'webmock/rspec'
rescue LoadError
  require 'rubygems'
  require 'webmock/rspec'
end

Dir[File.join(File.dirname(__FILE__), 'helpers', '*.rb')].each do |f|
  require f
end

require File.dirname(__FILE__) + '/../lib/signatory'

Rspec.configure do |c|
  c.mock_with :rspec
  c.include WebMock
  c.include RightSignatureStub

  c.before(:each) do
    Signatory.credentials = {:key => 'key1', :secret => 'secret1', :access_token => 'accesstoken', :access_secret => 'accesssecret'}
  end
end
