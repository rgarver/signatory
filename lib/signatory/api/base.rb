module Signatory
  module API
    class Base < ActiveResource::Base
      self.site = 'https://rightsignature.com/api/'
      self.format = :xml
      self.headers["User-Agent"] = "Ruby/Signatory #{Signatory::VERSION}"
      set_primary_key :guid
      class_attribute :__has_many if respond_to?(:class_attribute)

      def id
        guid
      end

      def persisted?
        attributes[:guid].present?
      end

      class << self
        def escape_url_attrs(*attrs)
          attrs.each do |attr|
            define_method attr do
              if Signatory.credentials.api_version == '1.0' || attributes[attr].blank?
                attributes[attr]
              else
                CGI::unescape(attributes[attr])
              end
            end
          end
        end

        if respond_to?(:class_attribute)
          def has_many(sym)
            self.__has_many = (self.__has_many || []) + [sym]
          end

          def instantiate_record(record, opts={})
            (self.__has_many||[]).each do |sym|
              record[sym.to_s] = [record[sym.to_s].try(:[],sym.to_s.singularize)].flatten.compact unless record[sym.to_s].is_a?(Array)
            end

            super(record, opts)
          end
        else
          def has_many(sym)
            self.write_inheritable_attribute(:__has_many, (read_inheritable_attribute(:__has_many)||[])+[sym])
          end

          def instantiate_record(record, opts={})
            (self.read_inheritable_attribute(:__has_many)||[]).each do |sym|
              record[sym.to_s] = [record[sym.to_s].try(:[],sym.to_s.singularize)].flatten.compact unless record[sym.to_s].is_a?(Array)
            end

            super(record, opts)
          end
        end

        def instantiate_collection(collection, opts)
          if collection.has_key?(formatted_collection_name)
            collection = collection[formatted_collection_name]
          end
          super([collection[formatted_name]].flatten, opts)
        end

        def formatted_name
          self.name.split('::').last.downcase
        end

        def formatted_collection_name
          self.name.split('::').last.downcase.pluralize
        end

        def connection(refresh = false)
          if defined?(@connection) || superclass == Object
            @connection = Signatory::API::Connection.new(site, format) if !@_signatory_connection || refresh || @connection.nil?
            @_signatory_connection = true
            @connection.proxy = proxy if proxy
            @connection.user = user if user
            @connection.password = password if password
            @connection.auth_type = auth_type if auth_type
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
