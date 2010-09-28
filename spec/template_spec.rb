require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory::Template do
  describe ".all" do
    it "returns a list of templates" do
      stub_templates([{:subject => "Template Subject"}, {:subject => "Template Subject 2"}])
      templates = Signatory::Template.all
      templates.count.should == 2
      templates.each do |temp|
        temp.should be_a(Signatory::Template)
      end
      subjects = templates.map{|t| t.subject}
      subjects.should include("Template Subject")
      subjects.should include("Template Subject 2")
    end
  end
  
  describe ".find by id" do
    it "returns the template with the specified id" do
      stub_template('xxxyyy', :subject => 'Blah blah')
      temp = Signatory::Template.find('xxxyyy')
      temp.subject.should == 'Blah blah'
    end
  end
  
  describe ".prepackage" do
    it "should have roles and merge fields" do
      temp = Signatory::Template.new(:guid => 'xxxyyy', :subject => 'Blah blah')
      stub_prepackage('xxxyyy', 'yyyxxx')
      packaged_temp = temp.prepackage
      
      packaged_temp.roles.map(&:role).should include('Employer')
      packaged_temp.merge_fields.map(&:name).should include('Company Name')
      packaged_temp.id.should == 'yyyxxx'
    end
  end
  
  describe ".build_document" do
    it "returns a new document" do
      temp = Signatory::Template.new(:guid => 'xxxyyy', :subject => 'Blah blah')
      doc_pkg = Signatory::Template.new(:guid => 'abcabc', :type => 'DocumentPackage')
      doc = Signatory::Document.new
      
      roles = [{:name => "Ryan Garver"}, {:name => "Cary Dunn"}]
      merge_fields = {'Company Name' => 'ABC Corp'}
      
      temp.should_receive(:prepackage).and_return(doc_pkg)
      doc_pkg.should_receive(:prefill_and_send).with(merge_fields, roles).and_return(doc)
      
      result = temp.build_document(merge_fields, roles)
      result.should == doc
    end
  end
  
  context "type = DocumentPackage" do
    describe ".signing_parties" do
      it "returns all of the roles that must sign"
    end

    describe ".sender" do
      it "returns the role who sent the document"
    end

    describe ".prefill_and_send" do
      it "returns the sent document" do
        doc_pkg = Signatory::Template.new(:guid => 'templid')
        roles = [{:name => "Ryan Garver"}, {:name => "Cary Dunn"}]
        merge_fields = {'Company Name' => 'ABC Corp'}

        id, subject = rand.to_s, "Subject #{rand}"
        stub_template_send('templid', id, :roles => roles, :merge_fields => merge_fields)
        stub_document(id, :subject => subject)
        doc = doc_pkg.prefill_and_send(merge_fields, roles)
        doc.guid.should == id
        doc.subject.should == subject
      end
    end
  end
end