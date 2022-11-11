# frozen_string_literal: true

require 'sequel'

module LightofDay
  module Database
    # Object Relational Mapper for View Entity
    class TopicOrm < Sequel::Model(:topics)
      def self.find_or_create(topic_info)
        first(topic_id: topic_info[:topic_id]) || create(topic_info)
      end
    end
  end
end
