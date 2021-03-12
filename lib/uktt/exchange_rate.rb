module Uktt
  class ExchangeRate < Base
    RESOURCE_PATH = 'exchange_rates'.freeze

    def retrieve
      fetch RESOURCE_PATH
    end
  end
end
