require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Signatory::Recipient do
  describe ".embed_url" do
    it "generates the right url" do
      doc = Signatory::Document.new(:guid => 'XXXXX')
      recipient = Signatory::Recipient.new(
        :name => "Bartholomew Davis McDugalheimer",
        :is_sender => "false",
        :must_sign => "true",
        :role_id => "signer_A",
        :state => "pending",
        :email => "noemail@rightsignature.com"
      )
      recipient.document = doc
      stub_request(:get, "https://rightsignature.com/api/documents/XXXXX/signer_links.xml?redirect_location=http%253A%252F%252Fexample.com").
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
      recipient.embed_url('http://example.com').should == "https://rightsignature.com/signatures/embedded?rt=YYYY"
    end
  end
end