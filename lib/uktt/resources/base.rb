class Base
  attr_accessor :response

  def initialize(http)
    @http = http
  end

  def retrieve(id, query_config = {})
    fetch "#{self.class::RESOURCE_PATH}/#{id}.json", query_config
  end

  def retrieve_all(query_config = {})
    fetch "#{self.class::RESOURCE_PATH}.json", query_config
  end

protected

  attr_reader :http

  def fetch(resource, query_config = {})
    @response = http.retrieve(resource, query_config)
  end
end
