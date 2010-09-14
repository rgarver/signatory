require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory do
  describe ".credentials" do
    it "takes a Signatory::Credentials" do
      cred = Signatory::Credentials.new('XXX', 'YYY')
      Signatory.credentials = cred
      Signatory.credentials.key.should == 'XXX'
      Signatory.credentials.secret.should == 'YYY'
    end
    
    it "takes a read-able object" do
      file = StringIO.new("---\nkey: thekey\nsecret: thesecret")
      Signatory.credentials = file
      Signatory.credentials.key.should == 'thekey'
      Signatory.credentials.secret.should == 'thesecret'
    end
    
    it "takes a hash" do
      Signatory.credentials = {:key => 'key1', :secret => 'secret1'}
      Signatory.credentials.key.should == 'key1'
      Signatory.credentials.secret.should == 'secret1'
    end
  end
end