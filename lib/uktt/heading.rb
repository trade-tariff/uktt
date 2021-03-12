module Uktt
  # A Chapter object for dealing with an API resource
  class Heading < Base
    RESOURCE_PATH = 'headings'.freeze

    attr_accessor :heading_id, :response

    def initialize(opts = {})
      @heading_id = opts[:heading_id] || nil
      Uktt.configure(opts)
      @config = Uktt.config
      @response = nil
    end

    def retrieve
      return '@chapter_id cannot be nil' if @heading_id.nil?

      fetch "#{RESOURCE_PATH}/#{@heading_id}.json"
    end

    def goods_nomenclatures
      return '@chapter_id cannot be nil' if @heading_id.nil?

      fetch "goods_nomenclatures/heading/#{@heading_id}.json"
    end

    def note
      'a heading cannot have a note'
    end

    def changes
      return '@chapter_id cannot be nil' if @heading_id.nil?

      fetch "#{RESOURCE_PATH}/#{@heading_id}/changes.json"
    end
  end
end
