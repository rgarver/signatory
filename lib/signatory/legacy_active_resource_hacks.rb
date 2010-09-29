module Signatory
  module API
    class Base < ActiveResource::Base

      class << self
        # This implementation is pulled directly from ActiveResource 3.0.0
        # http://apidock.com/rails/ActiveResource/Base/all/class
        def all(*args)
          find(:all, *args)
        end

        # ActiveResource < 3.0.0 does not support auth_type
        def connection(refresh = false)
          if defined?(@connection) || superclass == Object
            @connection = Signatory::API::Connection.new(site, format) if refresh || @connection.nil?
            @connection.proxy = proxy if proxy
            @connection.user = user if user
            @connection.password = password if password
            @connection.timeout = timeout if timeout
            @connection.ssl_options = ssl_options if ssl_options
            @connection
          else
            superclass.connection
          end
        end
      end

    end
  end
end
