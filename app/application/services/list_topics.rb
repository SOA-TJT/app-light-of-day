# frozen_string_literal: true

require 'dry/transaction'

module LightofDay
  module Service
    # Retrieves array of all listed project entities
    class ListTopics
      include Dry::Transaction

      step :get_api_topics
      step :reify_topics

      private

      def get_api_topics(type)
        Gateway::Api.new(LightofDay::App.config)
                    .topics(type)
                    .then do |result|
          # puts result
          result.success? ? Success(result.payload) : Failure(result.message)
        end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_topics(topics_json)
        Representer::Topics.new(OpenStruct.new)
                           .from_json(topics_json)
                           .then { |topics| Success(topics) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end

# require 'dry/monads'

# module LightofDay
#   module Service
#     # Retrieves array of all listed project entities
#     class ListTopics
#       include Dry::Monads::Result::Mixin
#       def initialize
#         @topics_mapper = LightofDay::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY)
#       end
#       def call(type)
#         data = if type == 'normal'
#                  @topics_mapper.topics
#                elsif type == 'created_time'
#                  @topics_mapper.created_time
#                elsif type == 'activeness'
#                  @topics_mapper.activeness
#                else
#                  @topics_mapper.popularity
#                end
#         Success(data)
#       rescue StandardError
#         Failure('Having trouble accessing the topics data')
#       end
#     end
#   end
# end
