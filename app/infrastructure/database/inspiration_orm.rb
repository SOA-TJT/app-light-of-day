# frozen_string_literal: true

require 'sequel'

module LightofDay
  module Database
    # Object Relational Mapper for Inspirations Entity
    class InspirationOrm < Sequel::Model(:inspirations)
      one_to_one :view,
                 class: :'LightofDay::Database::ViewOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
