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
        # puts 'result =', result

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot find lightofday right now; please try again later')
      end

      def reify_lightofday(lightofday_json)
        Representer::ViewLightofDay.new(OpenStruct.new)
                                   .from_json(lightofday_json)
                                   .then { |lightofday| Success([lightofday_json, lightofday]) }
      rescue StandardError
        Failure('Error in the lightofday -- please try again')
      end
    end
  end
end
# require 'dry/monads'

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class FindLightofDay
#       include Dry::Monads::Result::Mixin
#       def call(topic_data)
#         lightofday = LightofDay::Unsplash::ViewMapper
#                      .new(App.config.UNSPLASH_SECRETS_KEY,
#                           topic_data.topic_id).find_a_photo

#         Success(lightofday)
#       rescue StandardError
#         Failure('Could not find light of day')
#       end
#     end
#   end
# end
