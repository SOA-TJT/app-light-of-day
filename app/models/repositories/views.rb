# frozen_string_literal: true

require_relative 'quotes'

module LightofDay
  module Repository
    # hhh
    class Views
      def self.all
        Database::Views.all.map { |db_view| rebuild_entity(db_view) }
      end

      def self.find_creator; end

      def self.find(entity)
        find_origin_id(entity.origin_id)
      end

      def self.find_origin_id(origin_id)
        db_record = Database::ViewsOrm.first(origin_id:)
        rebuild_entity(db_record)
      end
    end
  end
end
