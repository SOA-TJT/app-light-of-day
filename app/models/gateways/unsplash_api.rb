# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module Unsplash
    # FavQs api to get Data
    class Api < GeneralApi
      PHOTO_PATH = 'https://api.unsplash.com/'
      TOPIC_PATH = 'https://api.unsplash.com/topics/?per_page=30'

      def initialize(token_acces_variable, token)
        super()
        @token_acces_variable = token_acces_variable
        @token = token
      end

      def topic_data
        get(TOPIC_PATH, @token_acces_variable, @token).parse
      end

      def photo_data(topicid)
        # puts topic_photo_path(topicid)
        get(topic_photo_path(topicid), @token_acces_variable, @token).parse
      end

      def topic_photo_path(topicid)
        "#{PHOTO_PATH}photos/random/?topics=#{topicid}&orientation=landscape"
      end

      # def photo_data
      #   get(@token_acces_variable, @token).parse
      # end
    end
  end
end
