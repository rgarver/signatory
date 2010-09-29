require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Signatory::Recipient do
  before(:each) do
    @document = Signatory::Document.new(:guid => 'XXXXX')
    @recipient = Signatory::Recipient.new(
      :name => "Bartholomew Davis McDugalheimer",
      :is_sender => "false",
      :must_sign => "true",
      :role_id => "signer_A",
      :state => "pending",
      :email => "noemail@rightsignature.com"
    )
    @recipient.document = @document
    stub_request(:get, "https://rightsignature.com/api/documents/XXXXX/signer_links.xml?redirect_location=http%3A%2F%2Fexample.com").
      to_return(:body => "
        <document>
          <signer_links>
            <signer_link>
              <role>signer_A</role>
              <signer_token>YYYY</signer_token>
            </signer_link>
          </signer_links>
        </document>
      ")
  end
  
  describe ".embed_url" do
    it "generates the right url" do    
      @recipient.embed_url('http://example.com').should == "https://rightsignature.com/signatures/embedded?rt=YYYY"
    end
    
    it "generates the right url with dimensions" do
      @recipient.embed_url('http://example.com', :height => 500, :width => 600).should == "https://rightsignature.com/signatures/embedded?rt=YYYY&height=500&width=600"
    end
  end
  
  describe ".embed_code" do
    it "generates the right iframe code" do    
      @recipient.embed_code('http://example.com').should == '<iframe src ="https://rightsignature.com/signatures/embedded?rt=YYYY" frameborder="0" scrolling="no"><p>Your browser does not support iframes.</p></iframe>'
    end
    
    it "generates the right iframe code with dimensions" do
      @recipient.embed_code('http://example.com', :height => 500, :width => 600).should == '<iframe src ="https://rightsignature.com/signatures/embedded?rt=YYYY&height=500&width=600" frameborder="0" scrolling="no" width="600px" height="500px"><p>Your browser does not support iframes.</p></iframe>'
    end
  end
end