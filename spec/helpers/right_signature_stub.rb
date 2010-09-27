require 'erb'

module RightSignatureStub
  def stub_documents(options={})
    options = {
      :total_documents => 2,
      :documents => []
    }.merge(options)

    stub_request(:get, 'https://rightsignature.com/api/documents.xml').to_return(
      :body => ERB.new(fixture('documents.xml.erb')).result(binding)
    )
  end

  def stub_document(id, options={})
    options = {
      :guid => id
    }.merge(options)

    stub_request(:get, "https://rightsignature.com/api/documents/#{id}.xml").to_return(
      :body => ERB.new(fixture('document.xml.erb')).result(binding)
    )
  end

  def stub_templates(templates=[])
    options = {
      :templates => templates
    }

    stub_request(:get, "https://rightsignature.com/api/templates.xml").to_return(
      :body => ERB.new(fixture('templates.xml.erb')).result(binding)
    )
  end

  def stub_template(id, options={})
    options = {
      :guid => id
    }.merge(options)

    stub_request(:get, "https://rightsignature.com/api/templates/#{id}.xml").to_return(
      :body => ERB.new(fixture('template.xml.erb')).result(binding)
    )
  end

  def stub_prepackage(tid, id, options = {})
    options = {
      :guid => id
    }.merge(options)

    stub_request(:post, "https://rightsignature.com/api/templates/#{tid}/prepackage.xml").to_return(
      :body => ERB.new(fixture('template_prepackage.xml.erb')).result(binding)
    )
  end

  def fixture(name)
    File.read(File.join(File.dirname(__FILE__), '..', 'fixtures', name))
  end
end