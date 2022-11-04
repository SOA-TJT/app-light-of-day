# frozen_string_literal: true

module LightofDay
  module Repository
    # Distbute mappers into correct mapper
    module For
      ENTITY_REPOSITORY = {
        Entity::View => Views,
        Entity::Inspiration => Inspirations
      }.freeze
      def self.klass(entity_klass)
        ENTITY_REPOSITORY[entity_klass]
      end

      def self.entity(entity_object)
        ENTITY_REPOSITORY[entity_object.class]
      end
    end
  end
end
