# frozen_string_literal: true

require 'yaml'
require 'http'

key_path = File.expand_path('../config/secrets.yml', __dir__)
config = YAML.safe_load(File.read(key_path))
puts config['UNSPLASH_SECRETS_KEY']

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
mushroom_picture_url = unsplash_api_path('photos/WPXxp36tkHQ')
unsplash_response[mushroom_picture_url] = call_unsplash_url(config, mushroom_picture_url)
mushroom_photo = unsplash_response[mushroom_picture_url].parse

unsplash_results['width'] = mushroom_photo['width']
# width= 4021

unsplash_results['height'] = mushroom_photo['height']
# height= 2262
unsplash_results['urls'] = mushroom_photo['urls']['raw']
# urls = https://images.unsplash.com/photo-1617925109341-2b99305cdee2?ixid=MnwzNzE2OTd8MHwxfGFsbHx8fHx8fHx8fDE2NjU3MzU5NjU&ixlib=rb-1.2.1
unsplash_results['likes'] = mushroom_photo['likes']
# not sure originals 439 maybe changed
unsplash_results['uesrname'] = mushroom_photo['user']['name']
# Gabriel Dizzi
unsplash_results['uesr_bio'] = mushroom_photo['user']['bio']
# "Hello, my name is Gabriel Vinicius and I'm a Brazilian photographer. I'm seventeen years old and for more images of my work you can see it on my instagram @ogabrieldizzi"

unsplash_results['uesr_photo'] = mushroom_photo['user']['profile_image']['large']

unsplash_results['topics'] = mushroom_photo['topic_submissions'].keys.first
# topics wallpapers

# https://api.unsplash.com/topics/wallpapers/?client_id=key

topic_wallpapers_url = unsplash_api_path("topics/#{unsplash_results['topics']}")
unsplash_response[topic_wallpapers_url] = call_unsplash_url(config, topic_wallpapers_url)

topic_wallpapers = unsplash_response[topic_wallpapers_url].parse

unsplash_results['title'] = topic_wallpapers['title']
# Wallpapers
unsplash_results['description'] = topic_wallpapers['description']
# From epic drone shots to inspiring moments in nature — submit your best desktop and mobile backgrounds.\r\n\r\n
unsplash_results['topic_url'] = topic_wallpapers['links']['html']
# https://unsplash.com/t/wallpapers
unsplash_results['owner_name'] = topic_wallpapers['owners'][0]['name']
# Unsplash

unsplash_bad_url = unsplash_api_path('people/000')
unsplash_response[unsplash_bad_url] = call_unsplash_url(config, unsplash_bad_url)
unsplash_response[unsplash_bad_url].parse

output_path = File.expand_path('../spec/fixtures/unsplash_results.yml', __dir__)
File.write(output_path, unsplash_results.to_yaml)
