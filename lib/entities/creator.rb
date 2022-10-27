# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      class Creator < Dry::Struct
        include Dry.Types

        attribute :name, Strict::String
        attribute :bio, Strict::String
        attribute :image, Strict::String
      end
    end
  end
end
