# frozen_string_literal: true
require_relative 'user'

module CodePraise
  # Model for Photo
  class Photo
    attr_reader :width, :height, :likes

    def initialize(photo_data, data_source)
      @photo = photo_data
      @data_source = data_source
    end

    def urls
      @photo['urls']['raw']
    end

    def owner
      @owner ||= User.new(@photo['owner'])
    end
  end
end
