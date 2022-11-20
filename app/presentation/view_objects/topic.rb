# frozen_string_literal: true

module Views
  # View for a single topic entity
  class Topic
    attr_reader :idx, :topic_id, :title, :description, :starts_at, :total_photos, :topic_url

    def initialize(topic, idx = nil)
      @topic = topic
      @idx = idx
      @topic_id = topic.topic_id
      @title = topic.title
      @description = topic.description
      @starts_at = topic.starts_at
      @total_photos = topic.total_photos
      @topic_url = topic.topic_url
    end

    def preview_photos_without_first
      @topic.preview_photos.delete(@topic.preview_photos.first)
    end

    def preview_photos_first_url
      @topic.preview_photos.first['urls']['small']
    end

    def preview_photos_url
      @topic.preview_photos.map{ |photo| photo['urls']['small']}
    end
  end
end
