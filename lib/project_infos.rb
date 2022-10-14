# frozen_string_literal: true

require 'yaml'
require 'http'

key_path = File.expand_path('../config/secrets.yml', __dir__)
config = YAML.safe_load(File.read(key_path))
puts config['UNSPLASH_SECRETS_KEY']

# 'https://api.unsplash.com/photos/DMyTcadDGog/?client_id=key'
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
mushroom_picture_url = unsplash_api_path('photos/DMyTcadDGog')
unsplash_response[mushroom_picture_url] = call_unsplash_url(config, mushroom_picture_url)
mushroom_photo = unsplash_response[mushroom_picture_url].parse

unsplash_results['width'] = mushroom_photo['width']
# width = 5198
unsplash_results['height'] = mushroom_photo['height']
# height = 3465
unsplash_results['urls'] = mushroom_photo['urls']['raw']
# urls = https://images.unsplash.com/photo-1665513325776-c6bbe99b1a79?ixid=MnwzNzE2OTd8MHwxfGFsbHx8fHx8fHx8fDE2NjU3MTIzODk&ixlib=rb-1.2.1
unsplash_results['likes'] = mushroom_photo['likes']
# not sure originals 34 maybe changed
unsplash_results['uesrname'] = mushroom_photo['user']['name']
# Marek Piwnicki
unsplash_results['uesrbio'] = mushroom_photo['user']['bio']
# "If you want to use my pics you need to: a) Respect the nature! b) Become vege! c) Be aware!  d) Stop polluting!\r\n(Just kidding. Thanks for using them in any form 👍) 🐷💰 > PayPal > ❤️🌍🌄🖥️🙌"

unsplash_results['uesr_image'] = mushroom_photo['user']['profile_image']['large']

# https://api.unsplash.com/topics/wallpapers/?client_id=key

topic_wallpapers_url = unsplash_api_path('topics/wallpapers')
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
