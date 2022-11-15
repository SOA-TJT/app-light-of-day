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

        FavQs::Entity::Inspiration.new(
          id: db_record.id,
          origin_id: db_record.origin_id,
          topics: db_record.topics,
          quote: db_record.quote,
          author: db_record.author
        )
      end

      def self.db_find_or_create(entity)
        Database::InspirationOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
