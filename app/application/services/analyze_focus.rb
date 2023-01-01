# frozen_string_literal: true

require 'dry/monads'

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class AnalyzeFocus
      include Dry::Transaction

      step :get_api_focuses
      step :reify_focuses

      private

      def get_api_focuses
        Gateway::Api.new(LightofDay::App.config)
                    .week_focus
                    .then do |result|
          puts result
          result.success? ? Success(result.payload) : Failure(result.message)
        end
      rescue StandardError
        Failure('Could not access our Focus API')
      end

      def reify_focuses(focuses_json)
        puts focuses_json
        Representer::DailyFocuses.new(OpenStruct.new)
                                 .from_json(focuses_json)
                                 .then { |focuses| Success(focuses) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class AnalyzeFocus
#       include Dry::Monads::Result::Mixin

#       def call
#         puts 'test'
#         focus_list = LightofDay::Mapper::WeeklyFocusMapper.new.day_summary
#         puts 'hhh'
#         Success(focus_list)
#       rescue StandardError
#         Failure('Could not find focus')
#       end
#     end
#   end
# end
