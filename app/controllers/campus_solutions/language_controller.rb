module CampusSolutions
  class LanguageController < CampusSolutionsController

    before_action :exclude_acting_as_users

    def post
      post_passthrough CampusSolutions::MyLanguage
    end

    def delete
      delete_passthrough CampusSolutions::MyLanguage
    end

  end
end
