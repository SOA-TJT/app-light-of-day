# frozen_string_literal: true

module Views
  # View for a single LightofDay entity
  class LightofDay
    attr_reader :idx, :quote, :quote_author, :creator_name, :topics, :urls, :urls_small, :context, :view_id

    def initialize(lightofday, idx = nil)
      @idx = idx
      @lightofday = lightofday
      @quote = lightofday.inspiration.quote
      @quote_author = lightofday.inspiration.author
      @creator_name = lightofday.creator_name
      @topics = lightofday.topics
      @urls = lightofday.urls
      @urls_small = lightofday.urls_small
      @context = lightofday.to_json
      # @context = lightofday.to_context
      @view_id = lightofday.origin_id
    end
  end
end
