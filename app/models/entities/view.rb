# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      class View < Dry::Struct
        include Dry.Types

        attribute :width, Strict::Integer
        attribute :height, Strict::Integer
        attribute :topic, Strict::Array.of(String)
        attribute :urls, Strict::String
        attribute :name, Strict::String
        attribute :bio, Strict::String
        attribute :image, Strict::String
      end
    end
  end
end
