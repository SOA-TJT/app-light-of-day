# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'

module LightofDay
  # Web App
  class App < Roda # rubocop:disable Metrics/ClassLength
    plugin :render, engine: 'slim', views: 'app/presentation/views_html'
    plugin :assets, path: 'app/presentation/assets', css: 'style.css', js: 'main.js'
    plugin :common_logger, $stderr
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :status_handler

    use Rack::MethodOverride
    status_handler(404) do
      view('404')
    end

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      topics_mapper = LightofDay::TopicMapper.new(App.config.UNSPLASH_SECRETS_KEY)

      topics_data = topics_mapper.topics
      view_topic = Views::TopicList.new(topics_data)

      # GET /
      routing.root do
        view 'picktopic', locals: { topics: view_topic }
      end

      # GET /list_topics/{sort_by}
      routing.on 'list_topics', String do |sort_by|
        routing.get do
          topics_data = topics_mapper.created_time if sort_by == 'created_time'
          topics_data = topics_mapper.activeness if sort_by == 'activeness'
          topics_data = topics_mapper.popularity if sort_by == 'popularity'
          view_topic = Views::TopicList.new(topics_data)
          view 'picktopic', locals: { topics: view_topic }
        end
      end

      routing.on 'favorite-list' do
        routing.is do
          session[:watching] ||= []

          # Load previously viewed projects
          result = Service::ListFavorite.new.call(session[:watching])

          if result.failure?
            flash[:error] = result.failure
            view_favorite_list = []
          else
            favorite_list = result.value!
            flash.now[:error] = '  Make some collections to get started' if favorite_list.none?

            session[:watching] = favorite_list.map(&:origin_id)
            view_favorite_list = Views::FavoritecList.new(favorite_list)
          end
          view 'favoritelist', locals: { favoriteList: view_favorite_list }
        end
      end

      routing.on 'light-of-day' do
        routing.is do
          # POST /light-of-day/
          routing.post do
            topic_id = routing.params['topic_id']
            topic_data = topics_data.find { |topic| topic.topic_id == topic_id }
            if topic_data.nil?
              flash[:error] = ' Please pick a topic !'
              routing.redirect '/'
            end
            routing.redirect "light-of-day/topic/#{topic_data.slug}"
          end
        end

        routing.on 'topic', String do |topic_slug|
          # GET /light-of-day/topic/{topic}
          routing.get do
            topic_data = topics_data.find { |topic| topic.slug == topic_slug }
            view_data = Service::FindLightofDay.new.call(topic_data)

            if view_data.failure?
              flash[:error] = view_data.failure
              view_lightofday = []
            else
              view_data = view_data.value!
              view_lightofday = Views::LightofDay.new(view_data)
            end

            view 'view', locals: { view: view_lightofday, is_saved: false }
          end
        end

        routing.on 'favorite' do
          routing.is do
            # POST /light-of-day/favorite/
            routing.post do
              fin = JSON.parse(routing.params['favorite'])
              ins_record = LightofDay::FavQs::Entity::Inspiration.new(
                id: fin['@attributes']['inspiration']['@attributes']['id'],
                origin_id: fin['@attributes']['inspiration']['@attributes']['origin_id'],
                topics: fin['@attributes']['inspiration']['@attributes']['topics'],
                author: fin['@attributes']['inspiration']['@attributes']['author'],
                quote: fin['@attributes']['inspiration']['@attributes']['quote']
              )

              view_record = LightofDay::Unsplash::Entity::View.new(
                id: fin['@attributes']['id'],
                origin_id: fin['@attributes']['origin_id'],
                topics: fin['@attributes']['topics'],
                width: fin['@attributes']['width'],
                height: fin['@attributes']['height'],
                urls: fin['@attributes']['urls'],
                urls_small: fin['@attributes']['urls_small'],
                creator_name: fin['@attributes']['creator_name'],
                creator_bio: fin['@attributes']['creator_bio'],
                creator_image: fin['@attributes']['creator_image'],
                inspiration: ins_record
              )
              session[:watching] ||= []
              session[:watching].insert(0, view_record.origin_id).uniq!

              begin
                Repository::For.entity(view_record).create(view_record)
              rescue StandardError => err # rubocop:disable Lint/UselessAssignment, Naming/RescuedExceptionsVariableName
                logger.error e.backtrace.join("\n")
                flash[:error] = '  Having trouble accessing the database'
              end
              view_id = routing.params['view_data']
              flash[:notice] = ' Add successfully to your favorite !'
              # routing.halt 404 unless view_id
              routing.redirect "favorite/#{view_id}"
            end
          end
          routing.on String do |view_id|
            # test by hsuan
            # Delete /light-of-day/favorite/{view_id}
            routing.delete do
              origin_id = view_id.to_s
              session[:watching].delete(origin_id)
              routing.redirect '/favorite-list'
            end
            # GET /light-of-day/favorite/{view_id}
            routing.get do
              begin
                lightofday_data = Repository::For.klass(Unsplash::Entity::View).find_origin_id(view_id)
                if lightofday_data.nil?
                  flash[:error] = '  Data not found'
                  routing.redirect '/'
                end
              rescue StandardError
                flash[:error] = '  Having trouble accessing the database'
                routing.redirect '/'
              end

              view_lightofday = Views::LightofDay.new(lightofday_data)
              view 'view', locals: { view: view_lightofday, is_saved: true }
            end
          end
        end
      end
    end
  end
end
