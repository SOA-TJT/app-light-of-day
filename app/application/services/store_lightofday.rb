# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class StoreLightofDay
      include Dry::Monads::Result::Mixin

      def call(input)
        lightofday =
          Repository::For.entity(input).create(input)

        Success(lightofday)
      rescue StandardError => error
        App.logger.error error.backtrace.join("\n")
        Failure('Having trouble accessing the database')
      end
    end
  end
end
