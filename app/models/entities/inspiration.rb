# frozen_string_literal: false

require 'dry-types'
require 'dry-struct'

module LightofDay
  module FavQs
    module Entity
      # entity for quote
      class Inspiration < Dry::Struct
        include Dry.Types
        attribute :id, Integer.optional
        attribute :origin_id, Strict::Integer
        attribute :topics, Strict::String
        attribute :author, Strict::String
        attribute :quote, Strict::String

        def to_attr_hash
          to_hash.except(:id)
        end

        def to_json(*_args)
          arr = instance_variables.map do |attribute|
            { attribute => instance_variable_get(attribute) }
          end
          arr[0].to_json
        end
      end
    end
  end
end
