module MyCommittees::CommitteesModule
  extend self
  include ClassLogger

  COMMITTEE_TYPES = {
    QE: {
      code: 'QE',
      label: 'Qualifying Exam Committee'
    },
    PLN1MASTER: {
      code: 'PLN1MASTER',
      label: 'Master\'s Thesis Committee'
    },
    DOCTORAL: {
      code: 'DOCTORAL',
      label: 'Dissertation Committee'
    }
  }
  DATE_FORMAT = '%b %d, %Y'
  STATUS_ICON_SUCCESS = 'check'
  STATUS_ICON_WARN = 'exclamation-triangle'
  STATUS_ICON_FAIL = 'exclamation-circle'

  def initialize(uid)
    @uid = uid
  end

  def get_empty_committee_members
    {
      chair: [],
      coChair: [],
      insideMembers: [],
      outsideMembers: [],
      additionalReps: [],
      academicSenate: []
    }
  end

  def parse_cs_committee (cs_committee)
    return nil unless cs_committee.present?
    committee = {
      committeeType:  translate_committee_type(cs_committee),
      program:        cs_committee[:studentAcadPlan],
      committeeMembers: parse_cs_committee_members(cs_committee)
    }
    set_committee_status(cs_committee, committee)
    committee
  end

  def translate_committee_type(cs_committee)
    committee_type_code = cs_committee[:committeeType].try(:intern)
    COMMITTEE_TYPES[committee_type_code].try(:[], :label)
  end

  def qualifying_exam?(cs_committee)
    cs_committee[:committeeType].to_s.strip.upcase === COMMITTEE_TYPES[:QE][:code]
  end

  def determine_qualifying_exam_status_message(cs_committee)
    if cs_committee[:studentApprovalMilestoneAttempts].blank?
      proposed_exam_date = cs_committee.try(:[], :studentQeExamProposedDate)
      "Proposed Exam Date: #{format_date(proposed_exam_date)}" unless proposed_exam_date.blank?
    end
  end

  def format_member_service_dates(committee_member)
    start_date = format_date committee_member.try(:[], :memberStartDate)
    end_date = format_date(committee_member.try(:[], :memberEndDate), true)
    service_range = "#{ start_date } - #{ end_date }" if start_date.present? && end_date.present?
    service_range
  end

  def member_active?(committee_member)
    active = false
    begin
      active = Time.zone.parse(committee_member[:csMemberEndDate].to_s).to_datetime.try(:future?)
    rescue
      logger.error "Bad Format for committee member end date; uid = #{@uid}"
    end
    active
  end

  def committee_member_photo_url (cs_committee_member)
    empl_id = cs_committee_member[:memberEmplid]
    return nil if is_non_berkeley_committee_member? empl_id
    user_id = cs_committee_member[:memberUid]
    "/api/my/committees/photo/member/#{user_id}"
  end

  def committee_student_photo_url (cs_committee)
    user_id = cs_committee[:studentUid]
    "/api/my/committees/photo/student/#{user_id}"
  end

  def parse_cs_committee_members (cs_committee)
    committee_members_result = get_empty_committee_members
    cs_committee_members = cs_committee.try(:[], :committeeMembers)
    cs_sorted_members = cs_committee_members.try(:sort_by) { |member| [ member[:memberNameLast] || '', member[:memberNameFirst] || ''] }
    cs_sorted_members.try(:each) do |cs_committee_member|
      assign_member_role(committee_members_result, cs_committee_member)
    end
    committee_members_result
  end

  def assign_member_role(committee_members, committee_member)
    if committee_member && committee_member[:memberRole]
      role_key = get_cs_committee_role_key(committee_member[:memberRole])
      committee_members[role_key] << parse_cs_committee_member(committee_member)
    end
  end

  def get_cs_committee_role_key (role_name)
    case role_name
      when 'CHAI'
        :chair
      when 'COCH'
        :coChair
      when 'INSD'
        :insideMembers
      when 'OUTS'
        :outsideMembers
      when 'ACSN', 'ACAD'
        :academicSenate
      when 'ADDL'
        :additionalReps
      else
        :additionalReps
    end
  end

  def is_non_berkeley_committee_member?(empl_id)
    empl_id.to_s.include? 'GCMT'
  end

  def is_active?(cs_committee)
    cs_committee.try(:[], :committeeFinishingMilestoneComplete) != 'Y'
  end

  def to_display(date)
    if date === '2999-01-01'
      'Present'
    else
      format_date date
    end
  end

  def format_date(unformatted_date, replace_future = false)
    formatted_date = ''
    begin
      date = DateTime.parse(unformatted_date.to_s)
      if replace_future && date.try(:future?)
        formatted_date = 'Present'
      elsif
        formatted_date = date.strftime(DATE_FORMAT)
      end
    rescue
      logger.error "Bad Format For Committees Date for Class #{self.class.name} feed, uid = #{@uid}"
    end
    formatted_date
  end
end
