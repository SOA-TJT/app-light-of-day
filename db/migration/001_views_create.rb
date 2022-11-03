# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:projects) do
      primary_key :id
      foreign_key :inspiration_id, :inspirations

      Integer     :origin_id, unique: true
      Integer     :height
      String      :width
      String      :topics
      String      :urls
      String      :name
      String      :bio
      String      :image

      DateTime :created_time
      DateTime :updated_time
    end
  end
end
