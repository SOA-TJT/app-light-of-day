# frozen_string_literal: true

# require_relative 'list_requset'
# 因為我們沒有用encode 所以應該不用用到
require 'http'
module LightofDay
  module Gateway
    # Infrastructure to call LightofDay API
    class Api
      def initialize(config)
        @config = config
        @request = Requset.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def topics(sort)
        puts 'Test'
        @request.topics(sort)
      end

      def random_view(slug)
        @request.random_view(slug)
      end

      def favorite_list(list)
        @request.favorite_list(list)
      end

      def view(origin_id)
        @request.view(origin_id)
      end

      def view_storage
        @request.view_storage
      end

      # HTTP request transmitter
      class Requset
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + '/api/v1'
        end

        def get_root
          call_api('get')
        end

        def topics(sort)
          call_api('get', ['topics'],
                   'sort' => sort)
        end

        def random_view(slug)
          call_api('get', ['light-of-day', 'random_view', slug])
        end

        def favorite_list(list)
          call_api('get', ['light-of-day'], 'list' => list) # may need to change
        end

        def view(origin_id)
          # light-of-day/view
          call_api('get', ['light-of-day', 'view', origin_id])
        end

        def view_storage
          call_api('post', %w[light-of-day view])
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
                .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          puts url
          HTTP.headers('Accept' => 'application/json').send(method, url)
              .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)
        SUCCESS_CODES = (200..299)

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def message
          payload['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end