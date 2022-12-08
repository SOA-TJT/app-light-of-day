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

      # def call(type)
      #   data = if type == 'normal'
      #            @topics_mapper.topics
      #          elsif type == 'created_time'
      #            @topics_mapper.created_time
      #          elsif type == 'activeness'
      #            @topics_mapper.activeness
      #          else
      #            @topics_mapper.popularity
      #          end
      #   Success(data)
      # rescue StandardError
      #   Failure('Having trouble accessing the topics data')
      # end

      def call(slug)
        chosed_topic_data = @topics_mapper.topics.find { |topic| topic.slug == slug }
        Success(chosed_topic_data)
      rescue StandardError
        Failure('Having trouble accessing the topics data')
      end

      # def find_slug(topic_id)
      #   chosed_topic_data = @topics_mapper.topics.find { |topic| topic.topic_id == topic_id }
      #   current_slug = chosed_topic_data.slug
      #   Success(current_slug)
      # rescue StandardError
      #   Failure('Having trouble accessing the slug')
      # end
    end
  end
end
