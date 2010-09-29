require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Signatory::MergeField do
  describe ".to_xml" do
    it "converts name specified merge field to xml" do
      mf = Signatory::MergeField.new(:name=>"Company Name", :value=>"Double Rainbow, Inc.")
      xml = mf.to_xml

      xml.should =~ /<merge-field merge_field_name="Company Name">/
      hash = Hash.from_xml(xml)
      hash['merge_field']['value'].should == "Double Rainbow, Inc."
      hash['merge_field']['locked'].should == "true"
    end
    
    it "converts id specified merge field to xml" do
      mf = Signatory::MergeField.new(:id=>"a_233_f309f82jklnm_232", :value=>"Double Rainbow, Inc.")
      xml = mf.to_xml

      xml.should =~ /<merge-field merge_field_id="a_233_f309f82jklnm_232">/
      hash = Hash.from_xml(xml)
      hash['merge_field']['value'].should == "Double Rainbow, Inc."
      hash['merge_field']['locked'].should == "true"
    end
  end
end