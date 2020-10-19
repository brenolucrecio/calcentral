class MyRegistrationsController < ApplicationController
  include AllowDelegateViewAs
  before_action :api_authenticate

  def get_feed
    render json: MyRegistrations::Statuses.from_session(session).get_feed_as_json
  end

end
