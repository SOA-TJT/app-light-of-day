# frozen_string_literal: true

require 'sequel'

module LightofDay
  module Database
    # Object Relational Mapper for View Entity
    class ViewOrm < Sequel::Model(:views)
      one_to_one :inspiration,
                  class: :'LightofDay::Database::InspirationOrm'

      plugin :timestamps, update_on_create: true
    end
  end
end
