# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of a lightofday entitiy
    class GetLightofDay
      include Dry::Transaction

      step :request_get_lightofday
      step :reify_lightofday

      private

      def request_get_lightofday(input)
        result = Gateway::Api.new(LightofDay::App.config)
                             .view(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot get lightofday right now; please try again later')
      end

      def reify_lightofday(lightofday_json)
        Representer::ViewLightofDay.new(OpenStruct.new)
                                   .from_json(lightofday_json)
                                   .then { |lightofday| Success([lightofday_json,lightofday]) }
      rescue StandardError
        Failure('Error in get lightofday -- please try again')
      end
    end
  end
end

# require 'dry/monads'

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class GetLightofDay
#       include Dry::Monads::Result::Mixin

#       def call(view_id)
#         lightofday_data = Repository::For.klass(Unsplash::Entity::View)
#                                          .find_origin_id(view_id)

#         Success(lightofday_data)
#       rescue StandardError
#         Failure('Having trouble accessing the database')
#       end
#     end
#   end
# end
