# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'
require 'rack/session'

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
      use Rack::Session::Cookie, secret: config.SESSION_SECRET
      # configure :development, :test do
      #   ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      # end

      # # Database Setup
      # DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
      # def self.DB = DB
    end
  end
end
