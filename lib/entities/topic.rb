# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module Unsplash
    module Entity
      class Topic < Dry::Struct
        include Dry.Types

        attribute :topics_id, Strict::String
        attribute :title, Strict::String
        attribute :description, Strict::String
        attribute :topic_url, Strict::String
      end
    end
  end
end
