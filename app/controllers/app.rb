# frozen_string_literal: true

require 'roda'
require 'slim'

module LightofDay
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets/'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      topics_data = LightofDay::Unsplash::TopicMapper.new(UNSPLAH_TOKEN).find_all_topics
      # GET /
      routing.root do
        view 'picktopic', locals: { topics: topics_data }
      end

      routing.on 'light-of-day' do
        routing.is do
          # POST /light-of-day/
          routing.post do
            topic_id = routing.params['topic_id']
            topic = topics_data.find { |t| t.topic_id == topic_id }
            routing.halt 400 unless topic
            routing.redirect "light-of-day/#{topic.slug}"
          end
        end

        routing.on String do |topic_slug|
          # GET /light-of-day/{topic}
          routing.get do
            topic = topics_data.find { |t| t.slug == topic_slug }
            routing.halt 400 unless topic
            view_data = LightofDay::Unsplash::ViewMapper.new(UNSPLAH_TOKEN, topic.topic_id).find_a_photo
            inspiration_data = LightofDay::FavQs::InspirationMapper.new.find_random
            view 'view', locals: { view: view_data, inspiration: inspiration_data }
          end
        end
      end
    end
  end
end
