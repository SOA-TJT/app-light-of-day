# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module FavQs
    # FavQs api to get Data
    class Api < GeneralApi
      QUOTE_PATH = 'https://favqs.com/api/qotd'
      def quote_data
        get(QUOTE_PATH, '', '').parse
      end
    end
  end
end
