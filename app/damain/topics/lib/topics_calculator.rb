# frozen_string_literal: true

module LightofDay
  module Unsplash
    module Mixins
      # topic calculation methods
      module TopicsCalculator
        def created_time_ascending
          topics.sort_by { |topic| -topic.starts_at }
        end

        def created_time_descending
          topics.sort_by(&:starts_at)
        end

        def activeness
          topics.sort_by { |topic| topic.total_photos / topic.starts_at }
        end

        def popularity
          topics.sort_by(&:total_photos)
        end
      end
    end
  end
end
