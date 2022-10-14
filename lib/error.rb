# frozen_string_literal: true

module CodePraise
  HTTP_ERROR = {
    401 => Errors::Unauthorized,
    404 => Errors::NotFound
  }.freeze
  module Errors
    class NotFound < StandardError; end
    class Unauthorized < StandardError; end
  end
end
