require File.dirname(__FILE__) + '/spec_helper.rb'

describe Signatory::DocumentPackage do
  describe "not findable" do # DocumentsSessions are temporary and not searchable
    it "No method for .all" do
      lambda do
        Signatory::DocumentPackage.all
      end.should raise_error(NoMethodError)
    end

    it "No method for .find" do
      lambda do
        Signatory::DocumentPackage.find
      end.should raise_error(NoMethodError)
    end
  end

  describe ".signing_parties" do
    it "returns all of the roles that must sign"
  end

  describe ".sender" do
    it "returns the role who sent the document"
  end

  describe ".prefill_and_send" do
    let(:roles) {[Signatory::Role.new(:name => "Ryan Garver", :role_name => 'Issuer'), Signatory::Role.new(:name => "Cary Dunn", :role_name => 'Investor')]}
    let(:merge_fields) {[Signatory::MergeField.new(:name => 'Company Name', :value => 'ABC Corp')]}

    it "returns the sent document" do
      doc_pkg = Signatory::DocumentPackage.new(:guid => 'templid')

      id, subject = rand.to_s, "Subject #{rand}"
      stub_template_send('templid', id, :roles => roles, :merge_fields => merge_fields)
      stub_document(id, :subject => subject)
      doc = doc_pkg.prefill_and_send(merge_fields, roles)
      doc.guid.should == id
      doc.subject.should == subject
    end

    it "can do a PDF swap" do
      stub_template('123')
      stub_prepackage('123', '321')
      doc_pkg = Signatory::Template.find('123').prepackage
      file = "Lorem ipsum"

      stub_template_send('321', '111', :roles => roles, 
                         :merge_fields => merge_fields, 
                         :match => {
                           'document_data' => {
                             'type' => 'base64',
                             'filename' => 'document.pdf',
                             'value' => Base64.encode64(file)
                           }
                        })
      stub_document(111, :subject => 'blah')

      doc = doc_pkg.prefill_and_send(merge_fields, roles, :document_data => file)
    end
  end
end
