# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module FavQs
    # FavQs api to get Data
    class Api < GeneralApi
      def quote_data
        Requset.new(nil).get(@path).parse
      end
    end
  end
end
