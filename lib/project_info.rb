# frozen_string_literal: true

require 'yaml'
require 'http'

key_path = File.expand_path('../config/secrets.yml', __dir__)
config = YAML.safe_load(File.read(key_path))
# puts config['UNSPLASH_SECRETS_KEY']

# 'https://api.unsplash.com/photos/WPXxp36tkHQ/?client_id=key'
def unsplash_api_path(path)
  "https://api.unsplash.com/#{path}"
end

def call_unsplash_url(config, url)
  HTTP.headers(
    'Accept' => 'application/json',
    'Authorization' => "Client-ID #{config['UNSPLASH_SECRETS_KEY']}"
  ).get(url)
end

unsplash_response = {}
unsplash_results = {}

def call_unsplash_topic(config)
  topic_wallpapers_url = unsplash_api_path('topics/?per_page=30')
  topic_wallpapers = call_unsplash_url(config, topic_wallpapers_url).parse

  topic_results = {}
  for i in 0..23
    per_topic_results = {}
    per_topic_results['topic_id'] = topic_wallpapers[i]['id']
    per_topic_results['title'] = topic_wallpapers[i]['title']
    # Wallpapers
    per_topic_results['description'] = topic_wallpapers[i]['description']
    # From epic drone shots to inspiring moments in nature — submit your best desktop and mobile backgrounds.\r\n\r\n
    per_topic_results['topic_url'] = topic_wallpapers[i]['links']['html']
    # https://unsplash.com/t/wallpapers
    topic_results[i+1] = per_topic_results
  end
  topic_results
end

topic_results = call_unsplash_topic(config)

mushroom_picture_url = unsplash_api_path("photos/random/?topics=#{topic_results[1]['topic_id']}&orientation=landscape")
unsplash_response[mushroom_picture_url] = call_unsplash_url(config, mushroom_picture_url)
mushroom_photo = unsplash_response[mushroom_picture_url].parse

photo_results = {}
photo_results['width'] = mushroom_photo['width']
# width= 4021
photo_results['height'] = mushroom_photo['height']
# height= 2262
photo_results['urls'] = mushroom_photo['urls']['raw']
# urls = https://images.unsplash.com/photo-1617925109341-2b99305cdee2?ixid=MnwzNzE2OTd8MHwxfGFsbHx8fHx8fHx8fDE2NjU3MzU5NjU&ixlib=rb-1.2.1
photo_results['creator'] = {
  name: mushroom_photo['user']['name'], # Gabriel Dizzi
  bio: mushroom_photo['user']['bio'], # "Hello, my name is Gabriel Vinicius and I'm a Brazilian photographer.
  # I'm seventeen years old and for more images of my work you can see it on my instagram @ogabrieldizzi"
  photo: mushroom_photo['user']['profile_image']['large'] # https://images.unsplash.com/profile-1649848634149-2787772c4ae8?ixlib=rb-4.0.3&crop=faces&fit=crop&w=128&h=128
}
photo_results['topics'] = mushroom_photo['topic_submissions']
#photo_results['topics'] = mushroom_photo['topic_submissions'].keys.map { |topic| call_unsplash_topic(config, topic) }

# topics wallpapers
unsplash_results['view'] = photo_results
unsplash_results['topics'] = topic_results

unsplash_bad_url = unsplash_api_path('people/000')
unsplash_response[unsplash_bad_url] = call_unsplash_url(config, unsplash_bad_url)
unsplash_response[unsplash_bad_url].parse


output_path = File.expand_path('../spec/fixtures/unsplash_results.yml', __dir__)
File.write(output_path, unsplash_results.to_yaml)


# puts call_unsplash_topic(config)
