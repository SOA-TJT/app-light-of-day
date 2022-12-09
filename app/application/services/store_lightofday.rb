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

# require 'dry/monads'

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class StoreLightofDay
#       include Dry::Monads::Result::Mixin

#       def call(input)
#         lightofday =
#           Repository::For.entity(input).create(input)

#         Success(lightofday)
#       rescue StandardError => error
#         App.logger.error error.backtrace.join("\n")
#         Failure('Having trouble accessing the database')
#       end
#     end
#   end
# end
