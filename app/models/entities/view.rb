# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      # entity for image
      class View < Dry::Struct
        include Dry.Types
        attribute :id, Integer.optional
        attribute :width, Strict::Integer
        attribute :height, Strict::Integer
        attribute :topic, Strict::Array.of(String)
        attribute :urls, Strict::String
        attribute :urls_small, Strict::String
        attribute :creator_name, Strict::String
        attribute :creator_bio, Strict::String
        attribute :creator_image, Strict::String
        attribute :inspiration, LightofDay::FavQs::Entity::Inspiration
        # attribute :creator, Strict::Hash
        def to_attr_hash
          to_hash.except(:topic, :inspiration)
        end
      end
    end
  end
end
