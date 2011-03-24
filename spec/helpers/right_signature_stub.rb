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

  def stub_template_send(id, doc_id, options = {})
    options = {
      :guid => doc_id
    }.merge(options)

    stub_request(:post, "https://rightsignature.com/api/templates.xml").with do |req|
      sent = Hash.from_xml(req.body)['template']
      deep_match(sent, options[:match]) if options[:match].present?

      sent['guid'] == id &&
      sent['action'] == 'send' &&
      options[:roles].all? { |role|
        sent['roles']['role'].map{|r|
          "#{r['name']}:#{r['email']}"
        }.include?("#{role.name}:#{role.email}")
      } &&
      options[:merge_fields].all? {|field|
        [sent['merge_fields']['merge_field']].flatten.map{|mf|
          mf['value']
        }.include?(field.value)
      }
    end.to_return(:body => ERB.new(fixture('template_sent.xml.erb')).result(binding))
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

  def deep_match(source, matching)
    matching.each do |k, v|
      source.should have_key(k)
      if v.is_a?(String)
        source[k].should include(v)
      elsif v.is_a?(Hash)
        deep_match(source[k], v)
      end
    end
  end
end
