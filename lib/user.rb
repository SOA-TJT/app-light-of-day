# frozen_string_literal: true

module CodePraise
  # Provides access to User data
  class User
    attr_reader :name, :bio

    def initialize(user_data)
      @user = user_data
      @name = @user['name']
      @bio = @user['bio']
    end

    def uesr_image
      @user['profile_image']['large']
    end
  end
end
