module Uktt
  class Quota < Base
    RESOURCE_PATH = 'quotas'.freeze

    def search(params)
      fetch "#{RESOURCE_PATH}/search.json?#{URI.encode_www_form(params)}"
    end
  end
end
