# frozen_string_literal: true

require 'http'

module LightofDay
  # Create general Purpose API Connection
  class GeneralApi
    def initialize(path)
      @path = path
    end

    private

    def get(token_acces_variable = '', token = '')
      http_response = HTTP.headers(
        'Accept' => 'application/json',
        'Authorization' => "#{token_acces_variable} #{token}"
      ).get(@path)
      Response.new(http_response).tap do |response|
        raise(response.error) unless response.successful?
      end
    end

    # Receive response from url
    class Response < SimpleDelegator
      # Unauthorized StandardError
      Unauthorized = Class.new(StandardError)
      # NotFound StandardError
      NotFound = Class.new(StandardError)

      HTTP_ERROR = {
        401 => Unauthorized,
        404 => NotFound
      }.freeze

      def successful?
        HTTP_ERROR.keys.none?(code)
      end

      def error
        HTTP_ERROR[code]
      end
    end
  end
end
