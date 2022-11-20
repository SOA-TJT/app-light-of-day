# frozen_string_literal: true

require_relative 'lightofday'

module Views
  # View for a a list of lightofday entities
  class FavoritecList
    def initialize(lightofdays)
      @lightofdays = lightofdays.map.with_index { |lightofday, i| LightofDay.new(lightofday, i) }
    end

    def each
      @lightofdays.each do |lightofday|
        yield lightofday
      end
    end
  end
end
