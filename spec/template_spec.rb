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
end