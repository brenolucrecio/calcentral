class MyHoldsController < ApplicationController
  include AllowDelegateViewAs
  before_action :api_authenticate_401

  def get_feed
    if params[:expireCache]
      MyAcademics::MyHolds.expire session['user_id']
      MyAcademics::MyAcademicStatus.expire session['user_id']
    end

    render json: MyAcademics::MyHolds.from_session(session).get_feed_as_json
  end
end
