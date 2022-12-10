# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of a lightofday entitiy
    class StoreLightofDay
      include Dry::Transaction

      step :request_store_lightofday
      step :reify_lightofday

      private

      def request_store_lightofday(input)
        url = input.map { |key, value| "#{key}=#{value}" }.join('&')
                   .then { |str| str ? '?' + str : '' }
        puts 'test url:', url
        result = Gateway::Api.new(LightofDay::App.config)
                             .view_storage(input)

        puts result.message
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot store lightofday right now; please try again later')
      end

      def reify_lightofday(lightofday_json)
        Representer::ViewLightofDay.new(OpenStruct.new)
                                   .from_json(lightofday_json)
                                   .then { |lightofday| Success(lightofday) }
      rescue StandardError
        Failure('Error in store lightofday -- please try again')
      end
    end
  end
end
