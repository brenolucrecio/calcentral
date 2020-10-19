module CampusSolutions
  class TermsAndConditionsController < CampusSolutionsController
    rescue_from Errors::ClientError, with: :handle_client_error

    before_action :exclude_acting_as_users

    def post
      model = CampusSolutions::MyTermsAndConditions.from_session(session)
      render json: model.update(request.request_parameters)
    end

  end
end
