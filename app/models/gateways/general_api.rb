# frozen_string_literal: true

require 'http'

module LightofDay
  # Create general Purpose API Connection
  class GeneralApi
    def initialize(path, token = '')
      @path = path
      @token = token
      # @token = access_token
    end
    # def initialize(path, access_token = nil)
    #   @path = path
    #   @token = access_token
    # end

    # Send request to url
    class Requset
      def initialize(token)
        @token = token
      end

      def get_with_authorized(url, token_acces_variable)
        http_response = HTTP.headers(
          'Accept' => 'application/json',
          'Authorization' => "#{token_acces_variable} #{@token}"
        ).get(url)
        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end

      def get_without_authorized(url)
        http_response = HTTP.headers(
          'Accept' => 'application/json'
        ).get(url)
        Response.new(http_response).tap do |response|
          raise(response.error) unless response.successful?
        end
      end

      # def get(url, token_acces_variable)
      #   http_response = if @token.nil?
      #                     HTTP.headers(
      #                       'Accept' => 'application/json'
      #                     ).get(url)
      #                   else
      #                     HTTP.headers(
      #                       'Accept' => 'application/json',
      #                       'Authorization' => "#{token_acces_variable} #{@token}"
      #                     ).get(url)
      #                   end
      #   Response.new(http_response).tap do |response|
      #     raise(response.error) unless response.successful?
      #   end
      # end
    end

    # Receive response from url
    class Response < SimpleDelegator
      Unauthorized = Class.new(StandardError)
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
