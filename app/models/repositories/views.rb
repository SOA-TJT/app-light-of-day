# frozen_string_literal: true

require_relative 'inspirations'

module LightofDay
  module Repository
    # hhh
    class Views
      def self.all
        Database::Views.all.map { |db_view| rebuild_entity(db_view) }
      end

      def self.find_creator; end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_origin_id(origin_id)
        db_record = Database::ViewsOrm.first(origin_id:)
        rebuild_entity(db_record)
      end

      def self.find_id(id)
        db_record = Database::ViewsOrm.first(id:)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Views has already exists' if find(entity)

        db_view = PersistView.new(entity).create_view
        rebuild_entity(db_view)
      end

      def rebuild_entity(db_record)
        return nil unless db_record

        Entity.view.new(
          id: db_record.id,
          # creator: db_record.creator,
          urls: db_record.urls,
          small_urls: db_record.small_urls,
          topics: db_record.topics.split(','),
          creator_bio: db_record.bio,
          creator_name: db_record.name,
          creator_image: db_record.image,
          height: db_record.height,
          width: db_record.width
        )
      end

      # help to upload the data to the Viewdatabase
      class PersistView
        def initialize(entity)
          @entity = entity
        end

        def create_view
          Database::ViewsOrm.create(@entity.to_attr_hash).merge(
            topic: @entity.topic.join(',')
          )
        end

        # def call
        #   Inspirations.db_find_or_create(@entity.)
        # end
      end
    end
  end
end
