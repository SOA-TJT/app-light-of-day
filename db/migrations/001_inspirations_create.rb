# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:inspirations) do
      primary_key :id

      Integer     :origin_id, unique: true
      String      :topics
      String      :author
      String      :quote

      DateTime :created_time
      DateTime :updated_time
    end
  end
end
