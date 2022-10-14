# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'
require_relative '../lib/unslapsh_api'

RESOURCE_ONE = 'photos'
ID = 'DMyTcadDGog'
RESOURCE_TWO = 'topics'
CATEGORY = 'wallpapers'
CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
UNSPLAH_TOKEN = CONFIG['UNSPLASH_SECRETS_KEY']
CORRECT = YAML.safe_load(File.read('spec/fixtures/unslapsh_results.yml'))

describe 'Tests Unsplash API library' do
  describe 'Photos information' do
    it 'HAPPY: should provide correct photo attributes' do
      photo = CodePraise::UnsplashApi.new(UNSPLAH_TOKEN)
                                     .photo(RESOURCE_ONE, ID)
      _(photo.witdh).must_equal CORRECT['width']
      _(photo.height).must_equal CORRECT['height']
      _(photo.urls).must_equal CORRECT['urls']
    end

    it 'SAD: should raise exception on incorrect photo' do
      _(proc do
        CodePraise::UnsplashApi.new(UNSPLAH_TOKEN).photo('photos', 'anyID') # can change foobar to another name?
      end).must_raise CodePraise::UnsplashApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        CodePraise::UnsplashApi.new('BAD_TOKEN').photo('photos', 'anyID') # 'BAD_TOKEN'??
      end).must_raise CodePraise::UnsplashApi::Errors::Unauthorized
    end
  end

  describe 'Topics information' do
    it 'HAPPY: should provide correct topic attributes' do
      topic = CodePraise::UnsplashApi.new(UNSPLAH_TOKEN)
                                     .topic(RESOURCE_TWO, CATEGORY)
      _(topic.title).must_equal CORRECT['title']
      _(topic.description).must_equal CORRECT['description']
    end
    it 'SAD: should raise exception on incorrect photo' do
      _(proc do
        CodePraise::UnsplashApi.new(UNSPLAH_TOKEN).topic('topics', 'anyCATEGORY') # can change foobar to another name?
      end).must_raise CodePraise::UnsplashApi::Errors::NotFound
    end
  end
end
