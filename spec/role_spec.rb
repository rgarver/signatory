require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Signatory::Role do
  describe ".to_xml" do
    it "converts name specified roles to xml" do
      role = Signatory::Role.new(:name=>"RyGar", :role_name=>"Issuer", :email=>"noemail@rightsignature.com")
      xml = role.to_xml

      xml.should =~ /<role role_name="Issuer">/
      hash = Hash.from_xml(xml)
      hash['role']['name'].should == "RyGar"
      hash['role']['email'].should == "noemail@rightsignature.com"
    end
    
    it "converts id specified roles to xml" do
      role = Signatory::Role.new(:name=>"RyGar", :role_id=>"signer_A", :email=>"noemail@rightsignature.com")
      xml = role.to_xml

      xml.should =~ /<role role_id="signer_A">/
      hash = Hash.from_xml(xml)
      hash['role']['name'].should == "RyGar"
      hash['role']['email'].should == "noemail@rightsignature.com"
    end
  end
end