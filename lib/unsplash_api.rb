# frozen_string_literal: true

require 'http'
require_relative 'photo'
require_relative 'topic'

module CodePraise
  # Library for Unsplash API
  class UnsplashApi
    def initialize(token)
      @unsplash_token = token
    end

    def photo(id)
      unsplash_picture_url = unsplash_api_path("photos/#{id}")
      photo_data = call_unsplash_url(unsplash_picture_url).parse
      Photo.new(photo_data, self)
    end

    def topic(slug)
      unsplash_topic_url = unsplash_api_path("topics/#{slug}")
      topic_data = call_unsplash_url(unsplash_topic_url).parse
      Photo.new(topic_data, self)
    end

    def unsplash_api_path(path)
      "https://api.unsplash.com/#{path}"
    end

    def call_unsplash_url(url)
      result = HTTP.headers(
        'Accept' => 'application/json',
        'Authorization' => "Client-ID #{@unsplash_token}"
      ).get(url)
      successful?(result) ? result : raise(HTTP_ERROR[result.code])
    end

    def successful?(result)
      !HTTP_ERROR.keys.include?(result.code)
    end
  end
end
