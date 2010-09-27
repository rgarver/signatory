module Signatory
  class DocumentPackage < Template
    def signing_parties
      raise NotImplementedError, "Pending"
      roles.select{|r| r.must_sign?}
    end
  end
end