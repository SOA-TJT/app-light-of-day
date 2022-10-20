# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Unsplash API library' do
  VCR.configure do |c|
    c.cassette_library_dir = CASSETTES_FOLDER
    c.hook_into :webmock

    c.filter_sensitive_data('<UNSPLAH_TOKEN>') { UNSPLAH_TOKEN }
    c.filter_sensitive_data('<UNSPLAH_TOKEN_ESC>') { CGI.escape(UNSPLAH_TOKEN) }
  end

  before do
    VCR.insert_cassette CASSETTE_FILE,
                        record: :new_episodes,
                        match_requests_on: %i[method uri headers]
  end

  after do
    VCR.eject_cassette
  end

  describe 'Photos information' do
    it '😃: should provide correct view attributes' do
      view = LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).view(ID)
      _(view.width).must_equal CORRECT['view']['width']
      _(view.height).must_equal CORRECT['view']['height']
      _(view.urls).must_equal CORRECT['view']['urls']
    end

    it '😭: should raise exception on incorrect view ID' do
      _(proc do
        LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).view('anyID')
      end).must_raise LightofDay::UnsplashApi::Response::NotFound
    end

    it '😭: should raise exception when unauthorized' do
      _(proc do
        LightofDay::UnsplashApi.new('BAD_TOKEN').view(ID)
      end).must_raise LightofDay::UnsplashApi::Response::Unauthorized
    end
  end

  describe 'Creater information' do
    before do
      @view = LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).view(ID)
    end

    it '😃: should get creator' do
      _(@view.creator).must_be_kind_of LightofDay::Creator
    end

    it '😃: should identify creator' do
      _(@view.creator.name).must_equal CORRECT['view']['creator'][:name]
      _(@view.creator.bio).must_equal CORRECT['view']['creator'][:bio]
      _(@view.creator.uesr_image).must_equal CORRECT['view']['creator'][:photo]
    end
  end

  describe 'Topics information' do
    before do
      @view = LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).view(ID)
    end

    it '😃: should identify topics' do
      topics = @view.topics
      _(topics.count).must_equal CORRECT['view']['topics'].count

      keys = %w[title description topic_url]
      keys.each do |key|
        titles = topics.map(&key.to_sym)
        # correct_titles = join_value(CORRECT['view']['topics'], key)
        correct_titles = CORRECT['view']['topics'].map { |item| item[key] }
        _(titles).must_equal correct_titles
      end
    end
  end
end
