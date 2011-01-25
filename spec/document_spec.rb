require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory::Document do
  before(:each) do
    Signatory.credentials = {:key => '123', :secret => '321'}
  end
  
  describe ".all" do
    it "returns a list of documents" do
      stub_documents(:total_documents => 2)
      documents = Signatory::Document.all
      documents.count.should == 2
      documents.each do |doc|
        doc.should be_a(Signatory::Document)
      end
    end
    
    it "returns the right document" do
      stub_documents(:total_documents => 1, :documents => [{:subject => 'This is a test', :guid => 'xxxyyy'}])
      documents = Signatory::Document.all
      documents.count.should == 1
      document = documents.first
      document.subject.should == 'This is a test'
      document.id.should == 'xxxyyy'
    end
  end
  
  describe ".find by id" do
    it "returns the document with the specified id" do
      stub_document('xxxyyy', :subject => 'Test number 2')
      doc = Signatory::Document.find('xxxyyy')
      doc.subject.should == 'Test number 2'
    end
  end

  describe "#extend_expiration" do
    before do
      stub_request(:post, "https://rightsignature.com/api/documents/XXXXX/extend_expiration").
        to_return(:body => "")
    end

    it "should post to the correct action" do
      stub_document('XXXXX')
      doc = Signatory::Document.find('XXXXX')
      Signatory::Document.connection.should_receive(:post).with(:extend_expiration)
      doc.extend_expiration
    end
  end

  describe "#extend_expiration!" do
    before :each do
      stub_document('XXXXX')
      @doc = Signatory::Document.find('XXXXX')
    end

    it "should extend the expiration date" do
      @doc.stub!(:extend_expiration)
      @doc.stub!(:reload)
      @doc.should_receive(:extend_expiration)
      @doc.extend_expiration!
    end

    it "should reload the document" do
      @doc.stub!(:extend_expiration)
      @doc.stub!(:reload)
      @doc.should_receive(:reload)
      @doc.extend_expiration!
    end
  end
end