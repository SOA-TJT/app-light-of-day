# frozen_string_literal: true

module Views
  # View for a single LightofDay entity
  class Focus
    attr_reader :daily_date, :daily_work, :daily_rest,:idx

    def initialize(focus, idx = nil)
      @idx = idx
      @daily_date = focus.daily_date
      @daily_work = focus.daily_work
      @daily_rest = focus.daily_rest
    end
  end
end
