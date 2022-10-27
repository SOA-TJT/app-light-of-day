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
        attribute :topic, Strict::Arrsay.of(String)
        attribute :urls, Strict::String
      end
    end
  end
end
