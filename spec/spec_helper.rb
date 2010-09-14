require 'stringio'
require 'spec'
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

Spec::Runner.configure do |config|
  config.include WebMock
  config.include RightSignatureStub

  config.before(:each) do
    stub_request(:any, /^https:\/\/rightsignature.com/)
  end
end