# frozen_string_literal: true

module LightofDay
  module Repository
    # mapping from Dbs Data from orms
    class Inspirations
      def self.find_id(id)
        rebuild_entity Database::InspirationOrm.first(id:)
      end

      def self.find_quote(quote)
        rebuild_entity Database::InspirationOrm.first(quote:)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Inspiration.new(
          id: db_record.id,
          topics: db_record.topics.split(','),
          quote: db_record.quote,
          author: db_record.author
        )
      end

      # not sure this function is required
      def self.db_find_or_create(entity)
        Database::InspirationOrm.find_or_create(entity)
      end

      def self.db_create(entity)
        PersistInspiration.create_inspiration(entity)
      end

      # help to upload the data to the Inspirationdatabase
      class PersistInspiration
        def initialize(entity)
          @entity = entity
        end

        def create_inspiration
          Database::InspirationOrm.create(@entity.to_attr_hash).merge(
            topics: @entity.topics.join(',')
          )
        end
      end
    end
  end
end
