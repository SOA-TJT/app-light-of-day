# frozen_string_literal: true

require 'roda'
require 'yaml'
require 'figaro'
require 'sequel'

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
      configure :development, :test do
        ENV['DATABASE_URL'] = "sqlite://#{config.DB_FILENAME}"
      end

      # Database Setup
      DB = Sequel.connect(ENV.fetch('DATABASE_URL')) # rubocop:disable Lint/ConstantDefinitionInBlock
      def self.DB = DB # rubocop:disable Naming/MethodName
    end
  end
end
