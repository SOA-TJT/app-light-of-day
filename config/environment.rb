# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'

module LightofDay
  # Configuration for the App
  class App < Roda
    # CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    # UNSPLAH_TOKEN = CONFIG['UNSPLASH_SECRETS_KEY']
    plugin :environments

    configure do
      # Environment variables setup
      Figaro.application = Figaro::Application.new(
        environment:,
        path: File.expand_path('config/secrets.yml')
      )
      Figaro.load

      def self.config = Figaro.env
    end
  end
end
