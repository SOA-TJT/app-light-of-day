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

        puts "mes:", result.message
        puts "pay:", result.payload
        puts "rs:", result.success?
        result.success? ? Success(result) : Failure(result.message)
      rescue StandardError
        Failure('Cannot store lightofday right now; please try again later')
      end

      def reify_lightofday(input)
        unless input.processing?
          Representer::ViewLightofDay.new(OpenStruct.new)
                                    .from_json(input.payload)
                                    .then { |lightofday| Success(lightofday) }
        end
        Success(input)
      rescue StandardError
        Failure('Error in store lightofday -- please try again')
      end
    end
  end
end
