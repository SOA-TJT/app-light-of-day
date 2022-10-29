# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module Unsplash
    # FavQs api to get Data
    class Api < GeneralApi
      def photo_data
        Requset.new(@token).get(@path, 'Client-ID').parse
      end
    end
  end
end
