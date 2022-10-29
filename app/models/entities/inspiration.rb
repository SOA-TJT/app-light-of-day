# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module FavQs
    module Entity
      # entity for quote
      class Inspiration < Dry::Struct
        include Dry.Types
        attribute :topics, Strict::Array.of(String)
        attribute :author, Strict::String
        attribute :quote, Strict::String
      end
    end
  end
end
