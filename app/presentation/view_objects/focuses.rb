# frozen_string_literal: true

require_relative 'focus'

module Views
  # View for a a list of topic entities
  class FocusList
    def initialize(focuses)
      @focuses = focuses.map.with_index { |focus, i| Focus.new(focus, i) }
    end

    def each(&)
      @focuses.each(&)
    end
  end
end
