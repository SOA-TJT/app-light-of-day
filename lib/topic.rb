# frozen_string_literal: true

require_relative 'user'

module CodePraise
  # Provides access to contributor data
  class Topic
    attr_reader :title, :description

    def initialize(topic_data)
      @topic = topic_data
    end

    def topic_url
      @topic['links']['html']
    end

    def owner
      @owner ||= User.new(@topic['owners'][0]['name'])
    end
  end
end
