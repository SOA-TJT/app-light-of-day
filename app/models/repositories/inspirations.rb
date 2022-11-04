# frozen_string_literal: true

module LightofDay
  module Repository
    # mapping from Dbs Data from orms
    class Inspiration
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

      def self.db_find_or_create(entity)
        Database::InspirationOrm.find_or_create(entity)
      end
    end
  end
end
