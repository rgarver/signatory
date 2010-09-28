module Signatory
  module API
    class Connection < ActiveResource::Connection
      private
      def new_http
        Signatory.credentials.token
      end

      def apply_ssl_options(http)
        http #noop
      end
    end
  end
end