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
        @gateway = gateway_class.new("https://api.unsplash.com/photos/random/?topics=#{topicid}&orientation=landscape",
                                     'Client-ID',
                                     @token)
      end

      def find_a_photo
        data = @gateway.photo_data
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
            origin_id:,
            topic:,
            width:,
            height:,
            urls:,
            urls_small:,
            # creator:
            creator_name:,
            creator_bio:,
            creator_image:
          )
        end

        def origin_id
          @data['id']
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
          @data['urls']['full']
        end

        def urls_small
          @data['urls']['small']
        end

        # def creator
        #   @data['user']
        # end

        def creator_name
          @data['user']['name']
        end

        def creator_bio
          @data['user']['bio'] ? @data['user']['bio'] : ''
        end

        def creator_image
          @data['user']['profile_image']['small']
        end
      end
    end
  end
end
