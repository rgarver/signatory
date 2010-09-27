require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Signatory::DocumentPackage do
  describe ".signing_parties" do
    it "returns all of the roles that must sign"
  end
  
  describe ".sender" do
    it "returns the role who sent the document"
  end
end