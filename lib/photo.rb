# frozen_string_literal: true
require_relative 'user'

module CodePraise
  # Model for Photo
  class Photo
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
      @owner ||= User.new(@photo['owner'])
    end
  end
end
