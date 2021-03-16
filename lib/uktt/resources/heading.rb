module Uktt
  # A Chapter object for dealing with an API resource
  class Heading < Base
    RESOURCE_PATH = 'headings'.freeze

    def changes(heading_id)
      fetch "#{RESOURCE_PATH}/#{heading_id}/changes.json"
    end

    def goods_nomenclatures(heading_id)
      fetch "goods_nomenclatures/heading/#{heading_id}.json"
    end
  end
end
