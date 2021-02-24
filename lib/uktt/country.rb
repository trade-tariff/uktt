module Uktt
  class Country < Base
    def retrieve
      fetch "#{GEOGRAPHICAL_AREAS}/countries"
    end
  end
end
