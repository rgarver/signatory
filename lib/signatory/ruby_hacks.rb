unless Symbol.public_instance_methods.include?(:<=>)
  class Symbol
    def <=>(rhs)
      to_s <=> rhs.to_s
    end
  end
end