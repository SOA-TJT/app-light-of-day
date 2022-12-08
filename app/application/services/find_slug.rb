# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # get all topics
    class FindSlug
      include Dry::Monads::Result::Mixin
      def initialize
        @topics_mapper = LightofDay::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY)
      end

      def call(topic_id)
        chosed_topic_data = @topics_mapper.topics.find { |topic| topic.topic_id == topic_id }
        current_slug = chosed_topic_data.slug
        Success(current_slug)
      rescue StandardError
        Failure('Having trouble accessing the slug')
      end
    end
  end
end
