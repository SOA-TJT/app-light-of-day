# frozen_string_literal: true

require_relative 'helpers/vcr_helper'
require_relative 'helpers/database_helper'
require_relative 'helpers/spec_helper'

describe 'Test Topic Mapper and Gateway' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_unsplash
    DatabaseHelper.wipe_database

    # unsplash_topic = LightofDay::Unsplash::TopicMapper
    #                  .new(UNSPLAH_TOKEN)
    #                  .find_all_topics
    unsplash_topic = LightofDay::TopicMapper
                     .new(UNSPLAH_TOKEN)
                     .find_all_topics
    puts unsplash_topic

    topic = LightofDay::Repository::For.entity(unsplash_topic)
                                       .create(unsplash_topic)

    puts topic
  end

  after do
    VcrHelper.eject_vcr
  end

  it 'HAPPY: should get topics' do
    topic = LightofDay::TopicMapper
            .new(UNSPLAH_TOKEN)
            .find_all_topics
    rebuilt = LightofDay::Repository::For.entity(topic)
                                         .create(topic)
    puts rebuilt
    # _(rebuilt).must_equal(view.width)
  end
end
