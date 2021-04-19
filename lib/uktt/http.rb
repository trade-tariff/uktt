require 'net/http'
require 'uri'

module Uktt
  class Http
    def initialize(connection, service, version, format)
      @connection = connection
      @service = service
      @version = version
      @format = format
    end

    def retrieve(resource, query_config = {})
      resource = "/#{resource}#{query_params(query_config)}"

      response = do_fetch(resource)

      Parser.new(response.body, @format).parse
    end

    def self.build(host, version, format)
      uri = URI(host)
      connection = Net::HTTP.new(uri.host, uri.port)
      connection.use_ssl = uri.scheme.include?('https')
      service = uri.path

      new(connection, service, version, format)
    end

    private

    def do_fetch(resource, redirect_limit = 2)
      request = Net::HTTP::Get.new(resource)
      request['Accept'] = "application/vnd.uktt.#{@version}"
      request['Content-Type'] = 'application/json'
      response = @connection.request(request)

      case response
      when Net::HTTPSuccess     then response
      when Net::HTTPRedirection then do_fetch(response['location'], redirect_limit - 1)
      else
        response.error!
      end
    end

    def query_params(query_config)
      return '' if query_config.empty?

      query = query_config.map do |key, value|
        "#{key}=#{value}"
      end

      "?#{query.join('&')}"
    end
  end
end
