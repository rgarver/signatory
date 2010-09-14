require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory::Credentials do
  it "loads credentials from yaml" do
    file = StringIO.new("---\nkey: thekey\nsecret: thesecret")
    creds = Signatory::Credentials.load(file)
    creds.key.should == 'thekey'
    creds.secret.should == 'thesecret'
  end
  
  it "loads credentials from hash" do
    hash = {:key => 'thekey', :secret => 'thesecret'}
    creds = Signatory::Credentials.load(hash)
    creds.key.should == 'thekey'
    creds.secret.should == 'thesecret'
  end
end