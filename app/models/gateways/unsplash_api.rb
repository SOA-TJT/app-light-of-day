# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module Unsplash
    # FavQs api to get Data
    class Api < GeneralApi
      def initialize(path, token_acces_variable, token)
        super(path)
        @token_acces_variable = token_acces_variable
        @token = token
      end

      def photo_data
        get(@token_acces_variable, @token).parse
      end
    end
  end
end
