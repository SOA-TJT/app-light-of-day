# frozen_string_literal: false

require_relative '../entities/topic'
require_relative '../gateways/unsplash_api'

module LightofDay
  module Unsplash
    # Distribute the Data From the Quote Api
    class TopicMapper
      def initialize(un_token, gateway_class = Unsplash::Api)
        @token = un_token
        @gateway_class = gateway_class.new('https://api.unsplash.com/topics/?per_page=30')
      end

      def find_all_topics
        data = @gateway_class.photo_data
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
      end

      # Distribute the data into Inspiration Entity
      class DataMapper
        def initialize(data, token, gateway_class)
          @data = data
          @view_mapper = ViewMapper.new(
            token, gateway_class
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
project = LightofDay::Unsplash::TopicnMapper
          .new.find_all_topics
puts project.topic_id
puts project.title
puts project.description
puts project.topic_url