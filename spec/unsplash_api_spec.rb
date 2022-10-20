# frozen_string_literal: true

require_relative 'spec_helper'

describe 'Tests Unsplash API library' do
  describe 'Photos information' do
    it 'HAPPY: should provide correct photo attributes' do
      photo = LightofDay::UnsplashApi.new(UNSPLAH_TOKEN)
                                     .photo(ID)
      _(photo.width).must_equal CORRECT['width']
      _(photo.height).must_equal CORRECT['height']
    end

    it 'SAD: should raise exception on incorrect photo' do
      _(proc do
        LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).photo('anyID')
      end).must_raise LightofDay::UnsplashApi::Errors::NotFound
    end

    it 'SAD: should raise exception when unauthorized' do
      _(proc do
        LightofDay::UnsplashApi.new('BAD_TOKEN').photo('anyID')
      end).must_raise LightofDay::UnsplashApi::Errors::Unauthorized
    end
  end

  describe 'Topics information' do
    before do
      @photo = LightofDay::UnsplashApi.new(UNSPLAH_TOKEN)
                                      .photo(ID)
    end

    it 'HAPPY: should recognize owner' do
      _(@photo.owner).must_be_kind_of LightofDay::Creator
    end

    it 'HAPPY: should identify owner' do
      _(@photo.owner.name).wont_be_nil
      _(@photo.owner.name).must_equal CORRECT['name']
    end
    it 'HAPPY: should provide correct topic attributes' do
      topic = @photo.topic
      _(topic.title).must_equal CORRECT['title']
      _(topic.description).must_equal CORRECT['description']
    end
    it 'SAD: should raise exception on incorrect photo' do
      _(proc do
        LightofDay::UnsplashApi.new(UNSPLAH_TOKEN).topic('anyCATEGORY')
      end).must_raise LightofDay::UnsplashApi::Errors::NotFound
    end
  end
end
