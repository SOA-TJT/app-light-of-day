# frozen_string_literal: false

require_relative '../entities/topic'
require_relative '../../../infrastructure/gateways/unsplash_api'

module LightofDay
  # Topic parse
  class TopicMapper
    def initialize(un_token, gateway_class = Unsplash::Api)
      @token = un_token
      @gateway = gateway_class.new('Client-ID', @token)
    end

    def find_all_topics
      @gateway.topic_data.map do |data|
        TopicMapper.build_entity(data)
      end
    end

    def self.build_entity(data)
      DataMapper.new(data).build_entity
    end

    # Distribute the data into Topic Entity
    class DataMapper
      def initialize(data)
        @data = data
      end

      def build_entity
        LightofDay::Entity::Topic.new(
          topic_id:,
          title:,
          slug:,
          starts_at:,
          total_photos:,
          description:,
          topic_url:
        )
      end

      private

      def topic_id
        @data['id']
      end

      def title
        @data['title']
      end

      def slug
        @data['slug']
      end

      def starts_at
        Date.parse @data['starts_at']
      end

      def total_photos
        @data['total_photos']
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
