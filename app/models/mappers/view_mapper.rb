# frozen_string_literal: false

require_relative '../entities/view'
require_relative '../gateways/unsplash_api'
require_relative 'topic_mapper'

module LightofDay
  module Unsplash
    # Distribute the Data From the Quote Api
    class ViewMapper
      def initialize(un_token, topicid, gateway_class = Unsplash::Api)
        @token = un_token
        @gateway = gateway_class.new("https://api.unsplash.com/photos/random/?topics=#{topicid}&orientation=landscape", @token)
      end

      def find_a_photo
        data = @gateway.photo_data
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @token).build_entity
      end

      # Distribute the data into View Entity
      class DataMapper
        def initialize(data, token)
          @data = data
          @topic_mapper = TopicMapper.new(
            token
          )
        end

        def build_entity
          LightofDay::Unsplash::Entity::View.new(
            topic:,
            width:,
            height:,
            urls:,
            name:,
            bio:,
            image:
          )
        end

        def width
          @data['width']
        end

        def height
          @data['height']
        end

        def topic
          @data['topic_submissions'].keys
        end

        def urls
          @data['urls']['raw']
        end

        def name
          @data['user']['name']
        end

        def bio
          @data['user']['bio'] ? @data['user']['bio'] : ''
        end

        def image
          @data['user']['profile_image']['large']
        end
      end
    end
  end
end

# test_code

# LightofDay::Unsplash::ViewMapper.new(UNSPLASH_SECRETS_KEY, 'xjPR4hlkBGA')
