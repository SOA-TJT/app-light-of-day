# frozen_string_literal: true

require_relative 'creator'
require_relative 'topic'

module LightofDay
  # Model for Photo
  class View
    attr_reader :width, :height

    def initialize(view_data, data_source)
      @view = view_data
      @data_source = data_source
      @width = @view['width']
      @height = @view['height']
      @topic_keys = @view['topic_submissions'].keys
    end

    def urls
      @view['urls']['raw']
    end

    def creator
      @creator = Creator.new(@view['user'])
    end

    def topics
      @topics ||= @data_source.topics(@topic_keys)
    end
  end
end
