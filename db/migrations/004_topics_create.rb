# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:topics) do
      primary_key :id
      String      :topic_id
      String      :title
      String      :slug
      DateTime    :starts_at
      Integer     :total_photos
      String      :description
      String      :topic_url

      DateTime :created_time
      DateTime :updated_time
    end
  end
end
