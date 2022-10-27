# frozen_string_literal: true

require 'roda'
require 'slim'

module LightofDay
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    topics_data = LightofDay::TopicMapper.new(UNSPLAH_TOKEN).findAll

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home', locals: { topics: topics_data }
      end

      routing.on 'light-of-day' do
        routing.is do
          # POST /light-of-day/
          routing.post do
            topic_id = routing.params['topic_id']
            topic = topics_data.find { |t| t.id == topic_id }.name
            routing.halt 400 unless topic
            routing.redirect "light-of-day/#{topic}"
          end
        end

        routing.on 'light-of-day', String do |topic|
          # GET /light-of-day/{topic}
          routing.get do
            topic_id = topics_data.find { |t| t.title == topic }.id
            routing.halt 400 unless topic_id
            view_data = LightofDay::ViewMapper.new(UNSPLAH_TOKEN).find(topic_id)
            quote_data = LightofDay::QuoteMapper.new.find
            view 'light-of-day', locals: { view: view_data, quote: quote_data }
          end
        end
      end
    end
  end
end
