module MyAcademics
  class AdvisorLinks < UserSpecificModel
    include ClassLogger
    include LinkFetcher

    def merge(data)
      data[:advisorLinks] = links
    end

    def links
      {
        tcReportLink: LinkFetcher.fetch_link('UC_CX_XFER_CREDIT_REPORT_ADVSR', { :EMPLID => campus_solutions_id }),
        degreePlannerLink: LinkFetcher.fetch_link('UC_AA_DEGREE_PLANNER_STDNT', {:EMPLID => campus_solutions_id}),
      }
    end

    def campus_solutions_id
      @campus_solutions_id ||= User::Identifiers.lookup_campus_solutions_id(@uid)
    end
  end
end
