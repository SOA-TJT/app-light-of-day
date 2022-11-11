# frozen_string_literal: true

folders = %w[lightofday topics]
folders.each do |folder|
  require_relative "#{folder}/init"
end
