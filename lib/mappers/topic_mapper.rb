# frozen_string_literal: false

require_relative '../entities/topic'
require_relative '../gateways/unsplash_api'

module LightofDay
  module Unsplash
    # Distribute the Data From the Quote Api
    class TopicMapper
      def initialize(un_token, gateway_class = Unsplash::Api)
        @token = un_token
        @gateway = gateway_class.new('https://api.unsplash.com/topics/?per_page=30')
      end

      def find_all_topics
        @gateway.photo_data.map do |data|
            TopicMapper.build_entity(data)
        end
        # data = @gateway.photo_data
        # build_entity(data)
      end

      def self.build_entity(data)
        DataMapper.new(data, @token).build_entity
      end

      # Distribute the data into Inspiration Entity
      class DataMapper
        def initialize(data, token)
          @data = data
          @topic_mapper = TopicMapper.new(
            token
          )
        end

        def build_entity
          LightofDay::Unsplash::Entity::Topic.new(
            topic_id:,
            title:,
            description:,
            topic_url:
          )
        end

        def topic_id
          @data['id']
        end

        def title
          @data['title']
        end

        def description
          @data['description']
        end

        def topic_url
          @data['links']['html']
        end
      end
    end
  end
end

# test_code

LightofDay::Unsplash::TopicMapper
          .new(UNSPLASH_SECRETS_KEY).find_all_topics

=begin
puts project.topic_id
puts project.title
puts project.description
puts project.topic_url
=end