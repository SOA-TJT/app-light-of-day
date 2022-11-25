# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class GetLightofDay
      include Dry::Monads::Result::Mixin

      def call(view_id)
        lightofday_data = Repository::For.klass(Unsplash::Entity::View)
                                         .find_origin_id(view_id)

        Success(lightofday_data)
      rescue StandardError
        Failure('Having trouble accessing the database')
      end
    end
  end
end
