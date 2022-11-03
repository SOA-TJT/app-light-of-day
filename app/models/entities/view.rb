# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      # entity for image
      class View < Dry::Struct
        include Dry.Types
        attribute :width, Strict::Integer
        attribute :height, Strict::Integer
        attribute :topic, Strict::Array.of(String)
        attribute :urls, Strict::String
        attribute :urls_small, Strict::String
        attribute :creator, Strict::Hash
      end
    end
  end
end
