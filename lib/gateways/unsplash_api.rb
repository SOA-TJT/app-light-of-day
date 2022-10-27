# frozen_string_literal: true

require_relative './general_api'

module LightofDay
  module Unsplash
    # FavQs api to get Data
    class Api < GeneralApi
      
      # UNSPLAH_TOKEN = 'VJ8XVHxL1FdA_qYgFP2REOu1FBoLnfEeTuaJ3qIGhaE'
      # UNSPLASH_PATH = 'https://api.unsplash.com/'
      # def initialize(path)
      #   super(path)
      # end
      def topic_data
        Requset.new(@token).get_with_authorized(@path, 'Client-ID').parse
      end
      def view_data
        Requset.new(@token).get_with_authorized(@path, 'Client-ID').parse
      end
    end
  end
end

# test
# teat_data = LightofDay::Unsplash::Api.new('https://api.unsplash.com/photos/random/?topics=xjPR4hlkBGA&orientation=landscape').topic_data
# puts teat_data
