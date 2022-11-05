# frozen_string_literal: true

require 'json'
require 'yaml'
puts 'test'
require_relative 'require_app'
require_app
# require_app(%w[infrastructure models])
TOPIC_ID = 'xjPR4hlkBGA'
key_path = File.expand_path('./config/secrets.yml', __dir__)
CONFIG = YAML.safe_load(File.read(key_path))
puts CONFIG['development']['UNSPLASH_SECRETS_KEY']
UNSPLAH_TOKEN = CONFIG['development']['UNSPLASH_SECRETS_KEY']

view = LightofDay::Unsplash::ViewMapper
       .new(UNSPLAH_TOKEN, TOPIC_ID)
       .find_a_photo
puts view.class.name
hash_object = view.instance_variables_hash
hash_test = view.context
puts hash_test
# puts hash_test[0]
# puts hash_test[0].class
# test_data = hash_test[0].to_json
fin = JSON.parse(hash_test)
# puts JSON.parse(hash_test)
# puts fin['@attributes']
puts fin['@attributes']['inspiration']
puts fin['@attributes']['inspiration'].class.name

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
LightofDay::Repository::For.entity(view_record).create(view_record)
# puts hash_object
# hash_as_string = hash_object.to_json
# puts hash_as_string.class
# raw_data = JSON.parse(hash_object)

# puts raw_data['@attributes']
# puts raw_data['@attributes']['id']
# puts raw_data['@attributes']['origin_id']
# puts raw_data['@attributes']['topics']
# puts raw_data['@attributes']['width']
# puts raw_data['@attributes']['height']
# puts raw_data['@attributes']['urls_small']
# puts raw_data['@attributes']['creator_name']
# puts raw_data['@attributes']['creator_bio']
# puts raw_data['@attributes']['creator_image']
# puts raw_data['@attributes']['creator_name']
# puts JSON.parse(hash_object)
# inspiration = LightofDay::FavQs::InspirationMapper.new.find_random
# rebuilt = LightofDay::Repository::For.entity(view).create(view, inspiration)
