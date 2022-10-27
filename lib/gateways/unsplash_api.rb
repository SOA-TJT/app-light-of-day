# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module Unsplash
    # FavQs api to get Data
    class Api < GeneralApi
      
      # def initialize(path)
      #   super(path)
      # end
      def photo_data
        Requset.new(@token).get_with_authorized(@path, 'Client-ID').parse
      end
=begin
      def topic_data
        Requset.new(@token).get_with_authorized(@path, 'Client-ID').parse
      end
      def view_data
        Requset.new(@token).get_with_authorized(@path, 'Client-ID').parse
      end
=end
    end
  end
end

# test
# teat_data = LightofDay::Unsplash::Api.new('https://api.unsplash.com/photos/random/?topics=xjPR4hlkBGA&orientation=landscape').topic_data
# puts teat_data
