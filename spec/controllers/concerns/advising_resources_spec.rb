describe AdvisingResources do
  let(:empl_id) { 123 }
  let(:mock_link) { 'here is your link' }
  let(:academic_statuses) do
    [
      {
        'studentCareer' => {
          'academicCareer' => {'code' => 'LAW', 'description' => 'Law'},
          'fromDate' => '2017-08-09'
        }
      },
      {
        'studentCareer' => {
          'academicCareer' => {'code' => 'UGRD', 'description' => 'Undergraduate'},
          'fromDate' => '2011-01-12'
        }
      },
      {
        'studentCareer' => {
          'academicCareer' => {'code' => 'GRAD', 'description' => 'Graduate'},
          'fromDate' => '2015-02-24'
        }
      },
    ]
  end

  let(:term_cpp) do
    [
      {"term_id"=>"2192", "acad_career"=>"UGRD", "acad_program"=>"UCOE", "acad_plan"=>"162B0U"},
      {"term_id"=>"2188", "acad_career"=>"UCBX", "acad_program"=>"XCCRT", "acad_plan"=>"30XCECCENX"},
    ]
  end

  let(:term_plans) { double(latest_career_code: 'UGRD') }
  before do
    allow(User::Identifiers).to receive(:lookup_campus_solutions_id).and_return empl_id
    allow_any_instance_of(MyAcademics::MyAcademicStatus).to receive(:get_feed).and_return({:feed=> { 'student'=> { 'academicStatuses'=> academic_statuses } } })
    allow(LinkFetcher).to receive(:fetch_link).and_return mock_link
    allow(User::Academics::TermPlans::TermPlans).to receive(:new).and_return(term_plans)
  end

  describe '#empl_id' do
    subject { described_class.empl_id random_id }
    it 'returns the EMPLID' do
      expect(subject).to eq empl_id
    end
  end

  describe '#lookup_student_career' do
    subject { described_class.lookup_student_career random_id }
    it 'returns the career code' do
      expect(subject).to eq 'UGRD'
    end
  end

  describe '#fetch_links' do
    subject { described_class.fetch_links link_config }

    context 'when link config is nil' do
      let(:link_config) { nil }
      it 'returns no links' do
        expect(subject.count).to eq 0
      end
    end
    context 'when link config is empty' do
      let(:link_config) { [] }
      it 'returns no links' do
        expect(subject.count).to eq 0
      end
    end
    context 'when link config contains invalid configurations' do
      let(:link_config) do
        [
          { status: 'bad' }
        ]
      end
      it 'returns no links' do
        expect(subject.count).to eq 0
      end
    end
    context 'when link config contains valid configurations' do
      let(:link_config) do
        [
          { feed_key: :myspace_hyper_portal, cs_link_key: 'MYSPACE_HYPER_PORTAL'},
          { feed_key: :backstreet_boys_viral_videos, cs_link_key: 'BACKSTREET_BOYS_VIRAL_VIDEOS'}
        ]
      end
      it 'returns links' do
        expect(subject.count).to eq 2
      end
    end
  end

  describe '#generic_links' do
    subject { described_class.generic_links }

    it 'uses the generic link config to fetch links and return them in a list' do
      expect(subject[:feed].count).to eq 19
      expect(subject[:feed][:ucAcademicProgressReport]).to eq mock_link
      expect(subject[:feed][:webNowDocuments]).to eq mock_link
      expect(subject[:feed][:ucAdministrativeTranscript]).to eq mock_link
      expect(subject[:feed][:ucAdministrativeTranscriptBatch]).to eq mock_link
      expect(subject[:feed][:ucAdvisingAssignments]).to eq mock_link
      expect(subject[:feed][:ucAppointmentSystem]).to eq mock_link
      expect(subject[:feed][:ucClassSearch]).to eq mock_link
      expect(subject[:feed][:ucEformsActionCenter]).to eq mock_link
      expect(subject[:feed][:ucEformsWorkCenter]).to eq mock_link
      expect(subject[:feed][:ucMilestones]).to eq mock_link
      expect(subject[:feed][:ucMultiYearAcademicPlannerGeneric]).to eq mock_link
      expect(subject[:feed][:ucReportingCenter]).to eq mock_link
      expect(subject[:feed][:ucServiceIndicators]).to eq mock_link
      expect(subject[:feed][:ucTransferCreditReport]).to eq mock_link
      expect(subject[:feed][:ucWhatIfReports]).to eq mock_link
      expect(subject[:feed][:ucArchivedTranscripts]).to eq mock_link
      expect(subject[:feed][:ucChangeCourseLoad]).to eq mock_link
      expect(subject[:feed][:ucCrossCampusEnrollApproval]).to eq mock_link
      expect(subject[:feed][:acadAccomodationsHubAdvisor]).to eq mock_link
    end
  end

  describe '#student_specific_links' do
    subject { described_class.student_specific_links user_id }

    context 'when no user id is provided' do
      let(:user_id) { nil }
      it 'returns an empty hash' do
        expect(subject).to be {}
      end
    end
    context 'when user id is provided' do
      let(:user_id) { random_id }
      it 'uses the student-specific link config to fetch links and return them in a list' do
        expect(subject[:feed].count).to eq 9
        expect(subject[:feed][:studentAcademicProgressReport]).to eq mock_link
        expect(subject[:feed][:studentAdministrativeTranscripts]).to eq mock_link
        expect(subject[:feed][:studentAdvisingAssignments]).to eq mock_link
        expect(subject[:feed][:studentAdvisorNotes]).to eq mock_link
        expect(subject[:feed][:studentManageMilestones]).to eq mock_link
        expect(subject[:feed][:studentMultiYearAcademicPlanner]).to eq mock_link
        expect(subject[:feed][:studentServiceIndicators]).to eq mock_link
        expect(subject[:feed][:studentWebnowDocuments]).to eq mock_link
        expect(subject[:feed][:studentWhatIfReport]).to eq mock_link
      end
    end
  end
end
