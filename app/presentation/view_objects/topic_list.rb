# frozen_string_literal: true

require_relative 'topic'

module Views
  # View for a a list of topic entities
  class TopicList
    def initialize(topics)
      @topics = topics.map.with_index { |topic, i| Topic.new(topic, i) }
    end

    def each
      @topics.each do |topic|
        yield topic
      end
    end
  end
end
