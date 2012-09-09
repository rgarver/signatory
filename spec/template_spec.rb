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
      doc_pkg = Signatory::DocumentPackage.new(:guid => 'abcabc', :type => 'DocumentPackage')
      doc = Signatory::Document.new

      roles = [{:name => "Ryan Garver"}, {:name => "Cary Dunn"}]
      merge_fields = {'Company Name' => 'ABC Corp'}

      temp.should_receive(:prepackage).and_return(doc_pkg)
      doc_pkg.should_receive(:prefill_and_send).with(merge_fields, roles).and_return(doc)

      result = temp.build_document(merge_fields, roles)
      result.should == doc
    end
  end

  describe "#merge_fields" do
    it "returns empty array when there are none" do
      stub_template('123', :no_merge_fields => true)
      templ = Signatory::Template.find('123')

      templ.merge_fields.should be_a(Array)
      templ.merge_fields.should be_empty
    end

    it "returns array with one merge field when there is one" do
      stub_template('123', :one_merge_field => true)
      templ = Signatory::Template.find('123')

      templ.merge_fields.should be_a(Array)
      templ.merge_fields.should_not be_empty
      templ.merge_fields[0].should be_a(Signatory::MergeField)
    end
  end
end
