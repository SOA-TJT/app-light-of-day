# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module FavQs
    # FavQs api to get Data
    class Api < GeneralApi
      # def initialize(path)
      #   super(path)
      # end
      def quote_data
        Requset.new(nil).get_without_authorized(@path).parse
      end

      def tests
        puts 'hello'
      end
    end
  end
end

# test
# teat_data = LightofDay::FavQs::Api.new('https://favqs.com/api/qotd').quote_data
# puts teat_data
