class CampusRostersController < RostersController
  include ClassLogger
  include DisallowAdvisorViewAs

  before_action :api_authenticate
  before_action :authorize_viewing_rosters
  rescue_from StandardError, with: :handle_api_exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def authorize_viewing_rosters
    raise Errors::BadRequestError, "campus_course_id required" unless params['campus_course_id']
    course = Berkeley::Course.new(:course_id => params['campus_course_id'])
    authorize course, :can_view_roster_photos?
  end

  # GET /api/academics/rosters/campus/:campus_course_id
  def get_feed
    feed = Rosters::Campus.new(session['user_id'], course_id: params['campus_course_id']).get_feed
    render :json => feed.to_json
  end

  # GET /api/academics/rosters/campus/csv/:campus_course_id.csv
  def get_csv
    options = {
      campus_course_id: params['campus_course_id'],
      section_id: params['section_id'],
      enroll_option: params['enroll_option'],
    }
    rosters_feed = Rosters::Campus.new(session['user_id'], course_id: params['campus_course_id']).get_feed
    rosters_csv = Rosters::Csv.new(rosters_feed, options)

    respond_to do |format|
      format.csv { send_data rosters_csv.get_csv.to_s, filename: rosters_csv.get_filename }
    end
  end

  # GET /campus/:campus_course_id/photo/:person_id
  def photo
    course_id = params['campus_course_id']
    course_user_id = Integer(params['person_id'], 10)
    @photo = Rosters::Campus.new(session['user_id'], course_id: course_id).photo_data_or_file(course_user_id)
    serve_photo
  end
end
