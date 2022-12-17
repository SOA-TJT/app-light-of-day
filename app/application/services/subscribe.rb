# frozen_string_literal: true

require 'dry/monads'

module LightofDay
  module Service
    # get all topics
    class Subscribe
      include Dry::Monads::Result::Mixin

      def call(params)
        result = Gateway::Api.new(LightofDay::App.config)
                             .subscribe(params['email_input'], params['topic_input'])
        result.success? ? Success(result) : Failure(result)
      # rescue StandardError
      #   Failure('Having trouble when subscribing')
      end
    end
  end
end
