# frozen_string_literal: true

require_relative 'user'

module CodePraise
  # Provides access to contributor data
  class Topic
    attr_accessor :title, :description

    def initialize(topic_data, data_source)
      @topic = topic_data
      @data_source = data_source
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
