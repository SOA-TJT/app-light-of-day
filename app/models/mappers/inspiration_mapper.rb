# frozen_string_literal: false

require_relative '../entities/inspiration'
require_relative '../gateways/favqs_api'

module LightofDay
  module FavQs
    # Distribute the Data From the Quote Api
    class InspirationMapper
      def initialize(gateway_class = FavQs::Api)
        @token = nil
        @gateway_class = gateway_class.new('https://favqs.com/api/qotd')
      end

      def find_random
        data = @gateway_class.quote_data
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Distribute the data into Inspiration Entity
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          LightofDay::FavQs::Entity::Inspiration.new(
            topics:,
            author:,
            quote:
          )
        end

        def topics
          @data['quote']['tags']
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

# test_code
project = LightofDay::FavQs::InspirationMapper
          .new.find_random
# puts project.topics
# puts project.author
# puts project.quote
