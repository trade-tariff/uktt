module Uktt
  class Country < Base
    RESOURCE_PATH = 'geographical_areas'.freeze

    def retrieve
      fetch "#{RESOURCE_PATH}/countries"
    end
  end
end
