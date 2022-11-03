# frozen_string_literal: true

# Requires all ruby files in specified app folders
def require_app(folders = %w[infrastructure models views controllers])
  app_list = Array(folders).map { |folder| "app/#{folder}" }
  full_list = ['config', app_list].flatten.join(',') # rubocop:disable Lint/UselessAssignment

  Dir.glob('./{config,app}/**/*.rb').each do |file|
    require file
  end
end
