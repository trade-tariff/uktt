module Uktt
  class ExchangeRate < Base
    EXCHANGE_RATES = 'exchange_rates'.freeze

    def retrieve
      fetch "#{EXCHANGE_RATES}"
    end
  end
end
