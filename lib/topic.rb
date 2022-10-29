# frozen_string_literal: true

require_relative 'creator'

module LightofDay
  # Provides access to Topic data
  class Topic
    attr_reader :title, :description

    def initialize(topic_data)
      @topic = topic_data
      @title = @topic['title']
      @description = @topic['description']
    end

    def topic_url
      @topic['links']['html']
    end
  end
end
