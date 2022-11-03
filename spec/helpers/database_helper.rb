# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    LightofDay::App.DB.run('PRAGMA foreign_keys = OFF')
    LightofDay::Database::MemberOrm.map(&:destroy)
    LightofDay::Database::ProjectOrm.map(&:destroy)
    LightofDay::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
