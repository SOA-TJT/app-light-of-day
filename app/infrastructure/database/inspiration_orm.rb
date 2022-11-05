# frozen_string_literal: true

require 'sequel'

module LightofDay
  module Database
    # Object Relational Mapper for Inspirations Entity
    class InspirationOrm < Sequel::Model(:inspirations)
      one_to_one :view,
                 class: :'LightofDay::Database::ViewOrm',
                 key: :inspiration_id

      plugin :timestamps, update_on_create: true
      def self.find_or_create(inspiration_info)
        first(origin_id: inspiration_info[:origin_id]) || create(inspiration_info)
      end
    end
  end
end
