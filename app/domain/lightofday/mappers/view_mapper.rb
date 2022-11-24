# frozen_string_literal: false

require_relative '../entities/view'
require_relative '../../../infrastructure/gateways/unsplash_api'
require_relative 'inspiration_mapper'

module LightofDay
  module Unsplash
    # Distribute the Data From the Quote Api
    class ViewMapper
      def initialize(un_token, topicid, gateway_class = Unsplash::Api)
        @token = un_token
        @topicid = topicid
        @gateway = gateway_class.new(
          'Client-ID',
          @token
        )
      end

      def find_a_photo
        data = @gateway.photo_data(@topicid)
        DataMapper.new(data, @token).build_entity
      end

      # Distribute the data into View Entity
      class DataMapper
        def initialize(data, _token)
          @data = data
          @inspiration_mapper = FavQs::InspirationMapper.new
        end

        def build_entity
          LightofDay::Unsplash::Entity::View.new(
            id: nil,
            origin_id:,
            topics:,
            width:,
            height:,
            urls:,
            urls_small:,
            creator_name:,
            creator_bio:,
            creator_image:,
            inspiration:
          )
        end

        private

        def origin_id
          @data['id']
        end

        def width
          @data['width']
        end

        def height
          @data['height']
        end

        def topics
          @data['topic_submissions'] ? @data['topic_submissions'].keys.join(',') : ''
        end

        def urls
          @data['urls']['full']
        end

        def urls_small
          @data['urls']['small']
        end

        def creator_name
          @data['user']['name']
        end

        def creator_bio
          @data['user']['bio'] || ''
        end

        def creator_image
          @data['user']['profile_image']['small']
        end

        def inspiration
          inspiration = @inspiration_mapper.find_random
          inspiration = @inspiration_mapper.find_random while @inspiration_mapper.count_quote(inspiration.quote) == false # rubocop:disable Layout/LineLength
          inspiration
          # InspirationMapper.build_entity
        end
      end
    end
  end
end
