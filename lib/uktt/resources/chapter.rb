module Uktt
  # A Chapter object for dealing with an API resource
  class Chapter < Base
    RESOURCE_PATH = 'chapters'.freeze

    attr_accessor :chapter_id

    def retrieve(chapter_id)
      fetch "#{RESOURCE_PATH}/#{chapter_id}.json"
    end

    def retrieve_all
      fetch "#{RESOURCE_PATH}.json"
    end

    def goods_nomenclatures(chapter_id)
      fetch "goods_nomenclatures/chapter/#{chapter_id}.json"
    end

    def changes(chapter_id)
      fetch "#{RESOURCE_PATH}/#{chapter_id}/changes.json"
    end

    def note(chapter_id)
      fetch "#{RESOURCE_PATH}/#{chapter_id}/chapter_note.json"
    end
  end
end
