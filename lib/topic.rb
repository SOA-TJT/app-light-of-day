# frozen_string_literal: true

require_relative 'user'

module CodePraise
  # Provides access to Topic data
  class Topic
    attr_accessor :title, :description

    def initialize(topic_data)
      @topic = topic_data
      @title = @topic['title']
      @description = @topic['description']
    end

    def topic_url
      @topic['links']['html']
    end

    def owner
      @owner ||= User.new(@topic['owners'][0]['name'])
    end
  end
end
