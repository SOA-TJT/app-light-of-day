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
    plugin :status_handler

    status_handler(404) do
      view('404')
    end

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      topics_data = LightofDay::Unsplash::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY).find_all_topics
      # GET /
      routing.root do
        view 'picktopic', locals: { topics: topics_data }
      end

      routing.on 'favorite-list' do
        routing.is do
          favorite_list = Repository::For.klass(Unsplash::Entity::View).all
          view 'favoritelist', locals: { favoriteList: favorite_list }
        end
      end

      routing.on 'light-of-day' do
        routing.is do
          # POST /light-of-day/
          routing.post do
            topic_id = routing.params['topic_id']
            topic_data = topics_data.find { |topic| topic.topic_id == topic_id }
            routing.halt 404 unless topic_data
            routing.redirect "light-of-day/topic/#{topic_data.slug}"
          end
        end

        routing.on 'topic', String do |topic_slug|
          # GET /light-of-day/topic/{topic}
          routing.get do
            topic_data = topics_data.find { |topic| topic.slug == topic_slug }
            routing.halt 404 unless topic_data
            view_data = LightofDay::Unsplash::ViewMapper.new(App.config.UNSPLASH_SECRETS_KEY, topic_data.topic_id).find_a_photo
            Repository::For.entity(view_data).create(view_data)
            view 'view', locals: { view: view_data, is_saved: false }
          end
        end

        routing.on 'favorite' do
          routing.is do
            # POST /light-of-day/favorite/
            routing.post do
              # view_id = routing.params['view_id']
              # puts view_data
              # puts 'store view & quote data' # TODO: Jerry
              # # Add project to database
              # Repository::For.entity(view_data).create(view_data)

              # Redirect viewer to favorite page
              routing.halt 404 unless view_id
              routing.redirect "favorite/#{view_id}"
            end
          end
          routing.on String do |view_id|
            # GET /light-of-day/favorite/{view_id}
            routing.get do
              lightofday_data = Repository::For.klass(Unsplash::Entity::View).find_origin_id(view_id)
              # routing.halt 404 unless view_data && inspiration_data
              view 'view', locals: { view: lightofday_data, inspiration: lightofday_data.inspiration, is_saved: true }
            end
          end
        end
      end
    end
  end
end
