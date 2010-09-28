require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory::Credentials do
  it "loads credentials from yaml" do
    file = StringIO.new("---\nkey: thekey\nsecret: thesecret\naccess_token: accesstoken\naccess_secret: accesssecret")
    creds = Signatory::Credentials.load(file)
    creds.key.should == 'thekey'
    creds.secret.should == 'thesecret'
    creds.access_token.should == 'accesstoken'
    creds.access_secret.should == 'accesssecret'
  end
  
  it "loads credentials from hash" do
    hash = {:key => 'thekey', :secret => 'thesecret', :access_token => 'accesstoken', :access_secret => 'accesssecret'}
    creds = Signatory::Credentials.load(hash)
    creds.key.should == 'thekey'
    creds.secret.should == 'thesecret'
    creds.access_token.should == 'accesstoken'
    creds.access_secret.should == 'accesssecret'
  end
  
  it "generates an access token from the credentials" do
    consumer = stub!(:consumer)
    OAuth::Consumer.should_receive(:new).with('thekey', 'thesecret', {
      :site => 'https://rightsignature.com',
      :scheme => :header,
      :http_method => :post,
      :request_token_path => "/oauth/request_token",
      :access_token_path  => "/oauth/access_token",
      :authorize_path     => "/oauth/authorize"
    }).and_return(consumer)
    access_token = stub!('access_token')
    OAuth::AccessToken.should_receive(:new).with(consumer, 'accesstoken', 'accesssecret').and_return(access_token)
    
    hash = {:key => 'thekey', :secret => 'thesecret', :access_token => 'accesstoken', :access_secret => 'accesssecret'}
    creds = Signatory::Credentials.load(hash)
    creds.token.should be(access_token)
  end
end