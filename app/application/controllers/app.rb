# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require 'json'

module LightofDay
  # Web App
  class App < Roda
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

      # topics_mapper = Service::FindTopics.new
      topics_result = Service::ListTopics.new.call('normal')
      if topics_result.failure?
        flash[:error] = topics_result.failure
        view_topic = []
      else
        topics_result = topics_result.value!
        view_topic = Views::TopicList.new(topics_result.topics)
      end

      # GET /
      routing.root do
        view 'picktopic', locals: { topics: view_topic }
      end

      routing.on 'subscribe' do
        routing.is do
          view 'subscribe', locals: { topics: view_topic }
        end
        routing.on do
          routing.post do
            subscribe_data = Service::Subscribe.new.call(routing.params)
            puts subscribe_data

            if subscribe_data.value!.processing?
              flash[:notice] = 'Email Address Verification Request is sending to your email, ' \
                               'please check your email in a moment.'
              routing.redirect '/'
            end

            if subscribe_data.failure?
              flash[:error] = subscribe_data.failure
            else
              routing.redirect '/'
            end
          end
        end
      end

      # GET /list_topics/{sort_by}
      routing.on 'list_topics', String do |sort_by|
        routing.get do
          topics_result = Service::ListTopics.new.call(sort_by)
          if topics_result.failure?
            flash[:error] = topics_result.failure
            view_topic = []
          else
            topics_result = topics_result.value!
            view_topic = Views::TopicList.new(topics_result.topics)
          end
          view 'picktopic', locals: { topics: view_topic }
        end
      end

      routing.on 'favorite-list' do
        routing.is do
          session[:watching] ||= []
          # Load previously viewed Views
          result = Service::ListFavorite.new.call(session[:watching])
          if result.failure?
            flash[:error] = result.failure
            view_favorite_list = []
          else
            favorite_list = result.value!.lightofdays
            flash.now[:error] = 'Make some collections to get started' if favorite_list.none?

            session[:watching] = favorite_list.map(&:origin_id)
            view_favorite_list = Views::FavoritecList.new(favorite_list)
          end
          view 'favoritelist', locals: { favoriteList: view_favorite_list }
        end
      end

      routing.on 'light-of-day' do
        #   routing.is do
        #     # POST /light-of-day/
        #     routing.post do
        #       topic_id = routing.params['topic_id']
        #       routing.redirect "light-of-day/topic/#{topic_id}"
        #     end
        #   end

        # routing.on 'topic' do
        #   # GET /light-of-day/topic/{topic_id}
        #   routing.post do
        #     # topic_data = Service::FindTopics.new.call(topic_slug)
        #     # topic_data = topic_data.value!
        #     if routing.params['topic_id'].nil?
        #       flash[:error] = 'Could not find light of day'
        #       routing.redirect '/'
        #     end
        #     view_data = Service::FindLightofDay.new.call(routing.params['topic_id'])

        #     if view_data.failure?
        #       flash[:error] = view_data.failure
        #       view_lightofday = []
        #     else
        #       jsondata = view_data.value![0]
        #       view_data = view_data.value![1]
        #       view_lightofday = Views::LightofDay.new(view_data, jsondata)
        #     end

        #     view 'view', locals: { view: view_lightofday, is_saved: false }
        #   end
        # end
        routing.on 'topic', String, String do |rest_time, work_time|
          routing.get do
            puts 'rest_time:', rest_time
            puts 'work_time:', work_time
            focus_made = Service::StoreFocus.new.call(rest_time:, work_time:)
            flash[:error] = focus_made.failure if focus_made.failure?

            if routing.params['topic_id'].nil?
              flash[:error] = 'Could not find light of day'
              routing.redirect '/'
            end
            view_data = Service::FindLightofDay.new.call(routing.params['topic_id'])
            puts view_data
            if view_data.failure?
              flash[:error] = view_data.failure
              view_lightofday = []
            else
              jsondata = view_data.value![0]
              view_data = view_data.value![1]

              view_lightofday = Views::LightofDay.new(view_data, jsondata)
            end

            view 'view', locals: { view: view_lightofday, is_saved: false }
          end
        end

        routing.on 'topic/' do
          # GET /light-of-day/topic/?target={topic_id}

          routing.get do
            # topic_data = Service::FindTopics.new.call(topic_slug)
            # topic_data = topic_data.value!
            if routing.params['topic_id'].nil?
              flash[:error] = 'Could not find light of day'
              routing.redirect '/'
            end
            view_data = Service::FindLightofDay.new.call(routing.params['topic_id'])
            puts view_data
            if view_data.failure?
              flash[:error] = view_data.failure
              view_lightofday = []
            else
              jsondata = view_data.value![0]
              view_data = view_data.value![1]
              # puts '1:', view_data.value![1]
              # lightofday_data = OpenStruct.new(view_data.value![1])

              # if view_data.value!.processing?
              #   flash[:notice] = 'Light of Day is being generated, ' \
              #                    'please check back in a moment.'
              #   routing.redirect '/'
              # end

              # view_data = lightofday_data

              view_lightofday = Views::LightofDay.new(view_data, jsondata)
            end

            view 'view', locals: { view: view_lightofday, is_saved: false }
          end
        end

        routing.on 'favorite' do
          routing.is do
            # POST /light-of-day/favorite/
            routing.post do
              tmpval = JSON.parse(routing.params['favorite'])
              # view_record = Service::ParseLightofday.new.call(routing.params['favorite']).value!
              session[:watching] ||= []
              session[:watching].insert(0, tmpval['origin_id']).uniq!

              # store lightofday to DB
              puts 'tmp:', tmpval
              lightofday_made = Service::StoreLightofDay.new.call(tmpval)
              flash[:error] = lightofday_made.failure if lightofday_made.failure?

              puts 'lightofday_made:', lightofday_made.value!

              flash.now[:notice] = 'Light of Day is being stored' if lightofday_made.value!.processing?

              view_id = tmpval['origin_id']
              # flash[:notice] = 'Add successfully to your favorite !'

              processing = Views::LightofdayProcessing.new(
                App.config, lightofday_made.value!
              )
              view 'loading', locals: { is_saved: true, processing:, view_id: }
              # routing.redirect "favorite/#{view_id}"
            end
          end
          routing.on String, String, String do |view_id, rest_time, work_time|
            # GET /light-of-day/favorite/{view_id}
            routing.get do
              focus_made = Service::StoreFocus.new.call(rest_time:, work_time:)
              lightofday_get = Service::GetLightofDay.new.call(view_id)
              if lightofday_get.failure?
                flash[:error] = lightofday_get.failure
              else
                jsondata = lightofday_get.value![0]
                lightofday_data = lightofday_get.value![1]
                flash.now[:error] = 'Data not found' if lightofday_get.nil?
              end

              view_lightofday = Views::LightofDay.new(lightofday_data, jsondata)

              view 'view', locals: { view: view_lightofday, is_saved: true }
            end
          end
          routing.on String do |view_id|
            # Delete /light-of-day/favorite/{view_id}
            routing.delete do
              origin_id = view_id.to_s
              session[:watching].delete(origin_id)
              routing.redirect '/favorite-list'
            end
            # GET /light-of-day/favorite/{view_id}
            routing.get do
              lightofday_get = Service::GetLightofDay.new.call(view_id)
              if lightofday_get.failure?
                flash[:error] = lightofday_get.failure
              else
                jsondata = lightofday_get.value![0]
                lightofday_data = lightofday_get.value![1]
                flash.now[:error] = 'Data not found' if lightofday_get.nil?
              end

              view_lightofday = Views::LightofDay.new(lightofday_data, jsondata)

              view 'view', locals: { view: view_lightofday, is_saved: true }
            end
          end
        end
      end

      routing.on 'focus' do
        # focus_data = Service::ListFocus.new.call
        focus_data = Service::AnalyzeFocus.new.call
        puts focus_data.failure
        if focus_data.failure?
          flash[:error] = focus_data.failure
          focus_data = []
        else
          focus_data = focus_data.value!
          puts 'focus_data', focus_data
          view_focus = Views::FocusList.new(focus_data.dailyfocuses)
        end
        view 'focus', locals: { view_focus: }
      end
    end
  end
end
