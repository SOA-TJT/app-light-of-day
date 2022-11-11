# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      # entity for image topic
      class Topic < Dry::Struct
        include Dry.Types
        attribute :topic_id, Strict::String
        attribute :title, Strict::String
        attribute :slug, Strict::String
        attribute :starts_at, Strict::Date
        attribute :total_photos, Strict::Integer
        attribute :description, Strict::String
        attribute :topic_url, Strict::String
      end
    end
  end
end
