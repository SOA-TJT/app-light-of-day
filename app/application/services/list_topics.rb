# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class ListTopics
      include Dry::Monads::Result::Mixin
      def initialize
        @topics_mapper = LightofDay::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY)
      end
      def call(type)
        data = if type == 'normal'
                 @topics_mapper.topics
               elsif type == 'created_time'
                 @topics_mapper.created_time
               elsif type == 'activeness'
                 @topics_mapper.activeness
               else
                 @topics_mapper.popularity
               end
        Success(data)
      rescue StandardError
        Failure('Having trouble accessing the topics data')
      end
    end
  end
end
