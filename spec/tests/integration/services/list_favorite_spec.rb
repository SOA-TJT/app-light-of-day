# frozen_string_literal: true

require_relative '../../../helpers/spec_helper.rb'
require_relative '../../../helpers/vcr_helper.rb'
require_relative '../../../helpers/database_helper.rb'

require 'ostruct'

describe 'LightofDay Service Integration Test' do
  VcrHelper.setup_vcr

  before do
    VcrHelper.configure_vcr_for_unsplash(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'List Favorite' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should return lightofday that are being watched' do
      # GIVEN: a valid project exists locally and is being watched
      view_lightofday = LightofDay::Unsplash::ViewMapper
        .new(UNSPLAH_TOKEN, TOPIC_ID)
        .find_a_photo
      db_lightofday = LightofDay::Repository::For.entity(view_lightofday)
        .create(view_lightofday)

      watched_list = [VIEW_ID]

      # WHEN: we request a list of all watched projects
      result = LightofDay::Service::ListFavorite.new.call(watched_list)

      # THEN: we should see our project in the resulting list
      _(result.success?).must_equal true
      lightofday = result.value!
      _(lightofday).must_include db_lightofday
    end

    it 'HAPPY: should not return projects that are not being watched' do
      # GIVEN: a valid project exists locally but is not being watched
      view_lightofday = LightofDay::Unsplash::ViewMapper
        .new(UNSPLAH_TOKEN, TOPIC_ID)
        .find_a_photo
      LightofDay::Repository::For.entity(view_lightofday)
        .create(view_lightofday)

      watched_list = []

      # WHEN: we request a list of all watched projects
      result = LightofDay::Service::ListFavorite.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      lightofday = result.value!
      _(lightofday).must_equal []
    end

    it 'SAD: should not watched projects if they are not loaded' do
      # GIVEN: we are watching a project that does not exist locally
      watched_list = []

      # WHEN: we request a list of all watched projects
      result = LightofDay::Service::ListFavorite.new.call(watched_list)

      # THEN: it should return an empty list
      _(result.success?).must_equal true
      lightofday = result.value!
      _(lightofday).must_equal []
    end
  end
end
