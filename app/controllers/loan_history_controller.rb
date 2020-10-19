class LoanHistoryController < ApplicationController
  include AllowDelegateViewAs
  before_action :api_authenticate_401
  before_action :authorize_for_financial

  def get_cumulative_feed
    render json: Financials::LoanHistory::MergedCumulative.from_session(session).get_feed
  end

  def get_aid_years_feed
    render json: Financials::LoanHistory::MergedAidYears.from_session(session).get_feed
  end

  def get_inactive_feed
    render json: Financials::LoanHistory::MergedInactive.from_session(session).get_feed
  end

  def get_summary_feed
    render json: Financials::LoanHistory::LoansSummary.from_session(session).get_feed
  end

end
