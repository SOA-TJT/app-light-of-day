# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class FindLightofDay
      include Dry::Monads::Result::Mixin
      def call(topic_data)
        lightofday = LightofDay::Unsplash::ViewMapper
                     .new(App.config.UNSPLASH_SECRETS_KEY,
                          topic_data.topic_id).find_a_photo

        Success(lightofday)
      rescue StandardError
        Failure('Could not find light of day')
      end
    end
  end
end
