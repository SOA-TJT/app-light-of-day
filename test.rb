# frozen_string_literal: true

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
inspiration = LightofDay::FavQs::InspirationMapper.new.find_random
rebuilt = LightofDay::Repository::For.entity(view).create(view, inspiration)
