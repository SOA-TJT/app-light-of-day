# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class ListFavorite
      include Dry::Monads::Result::Mixin

      def call(favorite)
        favorite_list = Repository::For.klass(Unsplash::Entity::View)
                                       .find_origin_ids(favorite)

        Success(favorite_list)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
