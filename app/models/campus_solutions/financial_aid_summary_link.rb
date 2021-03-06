module CampusSolutions
  class FinancialAidSummaryLink

    def get_feed
      get_financial_aid_summary_link
    end

    def get_financial_aid_summary_link
      link = LinkFetcher.fetch_link('UC_FA_FINRES_FA_SUMMARY', {INSTITUTION: 'UCB01'})
      { financialAidSummaryLink: link }
    end

  end
end
