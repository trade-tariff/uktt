class Base
  attr_accessor :response

  def initialize(http)
    @http = http
  end

  def retrieve
    raise NotImplementedError
  end

  protected

  attr_reader :http

  def fetch(resource, query_config = {})
    @response = http.retrieve(resource, query_config)
  end
end
