# frozen_string_literal: true

require 'roda'
require 'yaml'

module LightofDay
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    UNSPLAH_TOKEN = CONFIG['UNSPLASH_SECRETS_KEY']
  end
end
