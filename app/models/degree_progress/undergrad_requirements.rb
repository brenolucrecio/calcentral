module DegreeProgress
  class UndergradRequirements < UserSpecificModel
    # This model provides an advisor-specific version of milestone data for UGRD career.
    include Cache::CachedFeed
    include Cache::JsonifiedFeed
    include Cache::UserCacheExpiry
    include RequirementsModule

    LINK_ID = 'UC_CX_APR_RPT_STDNT'

    def get_feed_internal
      return {} unless is_feature_enabled?
      response = CampusSolutions::DegreeProgress::UndergradRequirements.new(user_id: @uid).get
      if response[:errored] || response[:noStudentId]
        response[:feed] = {}
      else
        response[:feed] = HashConverter.camelize({
          degree_progress: process(response),
          links: get_links
        })
      end
      response
    end

    def is_feature_enabled?
      Settings.features.cs_degree_progress_ugrd_advising
    end
  end
end
