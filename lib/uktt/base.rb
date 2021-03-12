class Base
  attr_accessor :response
  attr_reader :config

  def initialize(opts = {})
    Uktt.configure(opts)
    @config = Uktt.config
  end

  def retrieve
    raise NotImplementedError
  end

  def config=(new_opts = {})
    merged_opts = Uktt.config.merge(new_opts)
    Uktt.configure(merged_opts)
    @config = Uktt.config
  end

  protected

  def fetch(resource)
    @response = client.retrieve(resource, config[:format])
  end

  def client
    Uktt::Http.new(
      config[:host],
      config[:version],
      config[:debug],
    )
  end
end
