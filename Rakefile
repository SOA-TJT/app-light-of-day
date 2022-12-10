# frozen_string_literal: true

require 'rake/testtask'
require_relative 'require_app'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'run test'
task :spec do
  sh 'ruby spec/unsplash_api_spec.rb'
end

desc 'run testdb'
task :specdb do
  sh 'ruby spec/gateway_database_spec.rb'
end

desc 'run testdomain'
task :specdomain do
  sh 'ruby spec/domain_topics_spec.rb'
end

desc 'Generate Base64 for secret used in Rack :session'
task :new_session_secret do
  require 'Base64'
  require 'SecureRandom'
  secret = SecureRandom.random_bytes(64).then { Base64.urlsafe_encode64(_1) }
  puts "SESSION_SECRET:#{secret}"
end

task :run do
  sh 'bundle exec puma -p 9000'
end

task :rerun do
  sh "rerun -c --ignore 'coverage/*' -- bundle exec puma -p 9000"
end

desc 'Run application console'
task :console do
  sh 'pry -r ./load_all'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop -a'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog #{CODE}"
  end
end
