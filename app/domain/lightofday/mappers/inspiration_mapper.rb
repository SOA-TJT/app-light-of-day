# frozen_string_literal: false

require_relative '../entities/inspiration'
require_relative '../../../infrastructure/gateways/unsplash_api'

module LightofDay
  module FavQs
    # Distribute the Data From the Quote Api
    class InspirationMapper
      def initialize(gateway_class = FavQs::Api)
        @gateway_class = gateway_class.new
      end

      def find_random
        data = @gateway_class.quote_data
        DataMapper.new(data).build_entity
      end

      def count_quote(data)
        data.length < 100 && data.length > 20
      end

      # Distribute the data into Inspiration Entity
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          LightofDay::FavQs::Entity::Inspiration.new(
            id: nil,
            origin_id:,
            topics:,
            author:,
            quote:
          )
        end

        def origin_id
          @data['quote']['id']
        end

        def topics
          @data['quote']['tags'].join(',')
        end

        def author
          @data['quote']['author']
        end

        def quote
          @data['quote']['body']
        end
      end
    end
  end
end
