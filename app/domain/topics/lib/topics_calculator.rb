# frozen_string_literal: true

module LightofDay
  module Mixins
    # topic calculation methods
    module TopicsCalculator
      def created_time
        topics.sort_by(&:starts_at)
      end

      def activeness
        today = Date.today
        topics.sort_by { |topic| topic.total_photos / count_day_pass(topic.starts_at, today) }
      end

      def popularity
        topics.sort_by(&:total_photos).reverse
      end

      private

      def count_day_pass(start_date, end_date)
        (end_date.to_time.to_i - start_date.to_time.to_i) / (60 * 60 * 24)
      end
    end
  end
end
