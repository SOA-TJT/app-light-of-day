# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # get all topics
    class FindTopics
      include Dry::Monads::Result::Mixin
      def initialize
        @topics_mapper = LightofDay::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY)
      end

      def call(slug)
        chosed_topic_data = @topics_mapper.topics.find { |topic| topic.slug == slug }
        Success(chosed_topic_data)
      rescue StandardError
        Failure('Having trouble accessing the topics data')
      end
    end
  end
end
