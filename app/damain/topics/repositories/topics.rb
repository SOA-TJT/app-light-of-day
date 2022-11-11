# frozen_string_literal: true

module LightofDay
  # Repository for Topics
  class TopicRepo
    def self.all
      Database::TopicOrm.all.map { |db_topic| rebuild_entity(db_topic) }
    end

    def self.find(entity)
      find_topic_id(entity.topic_id)
    end

    def self.find_topic_id(topic_id)
      db_record = Database::TopicOrm.first(topic_id:)
      rebuild_entity(db_record)
    end

    def self.find_id(id)
      db_record = Database::TopicOrm.first(id:)
      rebuild_entity(db_record)
    end

    def self.create(entity)
      raise 'Topics has already exists' if find(entity)

      rebuild_entity(db_topic)
    end

    def self.rebuild_entity(db_record)
      return nil unless db_record

      Entity::Topic.new(
        topic_id: db_record.topic_id,
        title: db_record.title,
        slug: db_record.slug,
        starts_at: db_record.starts_at,
        total_photos: db_record.total_photos,
        description: db_record.description,
        topic_url: db_record.total_photos
      )
    end
  end
end
