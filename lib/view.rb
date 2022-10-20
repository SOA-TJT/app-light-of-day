# frozen_string_literal: true

require_relative 'creator'
require_relative 'topic'

module LightofDay
  # Model for Photo
  class View
    attr_accessor :width, :height, :likes

    def initialize(photo_data, data_source)
      @photo = photo_data
      @data_source = data_source
      @width = @photo['width']
      @height = @photo['height']
      @likes = @photo['likes']
    end

    def urls
      @photo['urls']['raw']
    end

    def owner
      @owner = Creator.new(@photo['user'])
    end

    def topic
      @topics ||= @data_source.topic(@photo['topic_submissions'].keys.join(','))
    end
  end
end
