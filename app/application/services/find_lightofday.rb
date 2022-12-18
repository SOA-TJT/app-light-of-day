# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of a lightofday entitiy
    class FindLightofDay
      include Dry::Transaction

      step :request_lightofday
      step :reify_lightofday

      private

      def request_lightofday(input)
        result = Gateway::Api.new(LightofDay::App.config)
                             .random_view(input)
        puts 'result =', result

        result.success? ? Success(result) : Failure(result.message)
      rescue StandardError
        Failure('Cannot find lightofday right now; please try again later')
      end

      def reify_lightofday(result)
        unless result.processing?
          Representer::ViewLightofDay.new(OpenStruct.new)
                                    .from_json(result.payload)
                                    .then { |lightofday| Success([result.payload, lightofday]) }
        end
        Success(result)
      rescue StandardError
        Failure('Error in the lightofday -- please try again')
      end
    end
  end
end
