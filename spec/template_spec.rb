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
      stub_template('xxxyyy', :subject => 'Blah blah')
      temp = Signatory::Template.find('xxxyyy')
      stub_prepackage('xxxyyy', 'yyyxxx')
      packaged_temp = temp.prepackage
      
      packaged_temp.roles.map(&:role).should include('Employer')
      packaged_temp.merge_fields.map(&:name).should include('Company Name')
      packaged_temp.id.should == 'yyyxxx'
    end
  end
  
  describe ".build_document" do
    it "returns a new document" do
      pending
      roles = [{:name => "Ryan Garver"}, {:name => "Cary Dunn"}]
      merge_fields = {'Company Name' => 'ABC Corp'}
      stub_template('xxxyyy', :subject => 'Blah blah')
      temp = Signatory::Template.find('xxxyyy')
      
      stub_prepackage('xxxyyy', 'yyyxxx')
      stub_template_send('yyyxxx')
      stub_document('yyyxxx', :subject => 'Test number 2')
      doc = temp.build_document(merge_fields, roles)
    end
  end
end