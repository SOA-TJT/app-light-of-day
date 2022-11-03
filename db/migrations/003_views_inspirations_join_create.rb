# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:views_inspirations) do
      primary_key [:view_id, :inspiration_id] # rubocop:disable Style/SymbolArray
      foreign_key :view_id, :views
      foreign_key :inspiration_id, :inspirations

      index [:view_id, :inspiration_id] # rubocop:disable Style/SymbolArray
    end
  end
end
