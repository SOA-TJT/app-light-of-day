# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Configuration and Utilities
gem 'figaro', '~> 1.2'
gem 'rake'

# Web Application
gem 'json', '~> 2.6.2'
gem 'puma', '~> 5'
gem 'roda', '~> 3'
gem 'slim', '~> 4'

# Networking
gem 'http', '~> 5'

# Database
gem 'hirb', '~> 0'
gem 'hirb-unicode', '~> 0'
gem 'sequel', '~> 5.49'

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3', '~> 1.4'
end

# Coding Style
group :development do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# Testing
group :test do
  gem 'minitest', '~> 5'
  gem 'minitest-rg', '~> 5'
  gem 'simplecov', '~> 0'
  gem 'vcr', '~> 6'
  gem 'webmock', '~> 3'
end

group :development do
  gem 'rerun', '~> 0'
end

# Debugging
gem 'pry'

# Validation
gem 'dry-struct'
gem 'dry-types'
