# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:views) do
      primary_key :id
      foreign_key :inspiration_id, :inspirations
      String      :origin_id
      Integer     :height
      Integer     :width
      String      :topics
      String      :urls
      String      :creator_name
      String      :creator_bio
      String      :creator_image
      String      :urls_small

      DateTime :created_time
      DateTime :updated_time
    end
  end
end
