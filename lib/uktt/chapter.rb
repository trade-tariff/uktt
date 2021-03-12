module Uktt
  # A Chapter object for dealing with an API resource
  class Chapter < Base
    RESOURCE_PATH = 'chapters'.freeze

    attr_accessor :chapter_id

    def initialize(opts = {})
      @chapter_id = opts[:chapter_id] || nil
      Uktt.configure(opts)
      @config = Uktt.config
    end

    def retrieve
      return '@chapter_id cannot be nil' if @chapter_id.nil?

      fetch "#{RESOURCE_PATH}/#{@chapter_id}.json"
    end

    def retrieve_all
      fetch "#{RESOURCE_PATH}.json"
    end

    def goods_nomenclatures
      return '@chapter_id cannot be nil' if @chapter_id.nil?

      fetch "goods_nomenclatures/chapter/#{@chapter_id}.json"
    end

    def changes
      return '@chapter_id cannot be nil' if @chapter_id.nil?

      fetch "#{RESOURCE_PATH}/#{@chapter_id}/changes.json"
    end

    def note
      return '@chapter_id cannot be nil' if @chapter_id.nil?

      fetch "#{RESOURCE_PATH}/#{@chapter_id}/chapter_note.json"
    end
  end
end
