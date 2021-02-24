class Base
  attr_accessor :config, :response

  def initialize(opts = {})
    Uktt.configure(opts)
    @config = Uktt.config
  end

  def retrieve
    raise NotImplementedError
  end

  protected

  def fetch(resource)
    @response = client.retrieve(resource, config[:format])
  end

  def client
    Uktt::Http.new(
      config[:host], 
      config[:version], 
      config[:debug]
    )
  end
end
