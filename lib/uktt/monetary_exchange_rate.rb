module Uktt
  class MonetaryExchangeRate < Base
    RESOURCE_PATH = 'monetary_exchange_rates'.freeze

    def retrieve_all
      fetch "#{RESOURCE_PATH}.json"
    end

    def latest(currency)
      retrieve_all unless @response

      case @config[:version]
      when 'v1'
        @response.select { |obj| obj.child_monetary_unit_code == currency.upcase }
                 .max_by(&:validity_start_date)
                 .exchange_rate.to_f
      when 'v2'
        @response.data.select { |obj| obj.attributes.child_monetary_unit_code == currency.upcase }
                 .max_by { |obj| obj.attributes.validity_start_date }
                 .attributes.exchange_rate.to_f
      else
        raise StandardError, "`#{@opts[:version]}` is not a supported API version. Supported API versions are: v1 and v2"
      end
    end
  end
end
