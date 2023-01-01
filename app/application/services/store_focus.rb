# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Store array of a focus entitiy
    class StoreFocus
      include Dry::Transaction

      step :request_store_focus
      step :reify_focus

      private

      def request_store_focus(input)
        result = Gateway::Api.new(LightofDay::App.config)
                             .focus_storage(input[:rest_time], input[:work_time])

        puts result.message
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Cannot store lightofday right now; please try again later')
      end

      def reify_focus(focus_json)
        Representer::Focus.new(OpenStruct.new)
                          .from_json(focus_json)
                          .then { |focus| Success(focus) }
      rescue StandardError
        Failure('Error in store focus -- please try again')
      end
    end
  end
end

# require 'securerandom'
# require 'dry/monads'

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class StoreFocus
#       include Dry::Monads::Result::Mixin

#       def call(work_time, rest_time)
#         puts Time.now.strftime('%Y-%m-%d %H:%M:%S').split(' ').first
#         puts SecureRandom.uuid
#         focus = create_focus(work_time.to_i, rest_time.to_i)
#         puts 'ddd'
#         focus_time =
#           Repository::For.entity(focus).create(focus)
#         puts 'fff'
#         Success(focus_time)
#       rescue StandardError => e
#         # App.logger.error e.backtrace.join("\n")
#         Failure('Having trouble accessing the database')
#       end

#       def create_focus(work_time, rest_time)
#         LightofDay::OwnDb::Entity::Focus.new(
#           id: nil,
#           ssid: SecureRandom.uuid,
#           uuid: SecureRandom.uuid,
#           rest_time:,
#           work_time:,
#           date: Date.today
#           # Time.now.strftime('%Y-%m-%d %H:%M:%S').split(' ').first
#         )
#       end
#     end
#   end
# end
