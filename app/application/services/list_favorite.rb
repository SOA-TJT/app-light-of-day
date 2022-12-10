# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class ListFavorite
      include Dry::Transaction

      step :get_api_favorite
      step :reify_favorite

      private

      def get_api_favorite(favorite_list)
        Gateway::Api.new(LightofDay::App.config)
                    .favorite_list(favorite_list)
                    .then do |result|
          # puts result
          result.success? ? Success(result.payload) : Failure(result.message)
        end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_favorite(input_json)
        Representer::FavoriteList.new(OpenStruct.new)
                           .from_json(input_json)
                           .then { |favorite| Success(favorite) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end

