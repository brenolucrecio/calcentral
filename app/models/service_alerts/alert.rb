module ServiceAlerts
  class Alert < ApplicationRecord
    include DatedFeed
    include HtmlSanitizer
    include OraclePrimaryHelper

    self.table_name = 'PS_UC_CLC_SRVALERT'
    self.primary_key = 'uc_clc_id'

    def self.attributeDefaults
      {uc_alrt_title:' ', uc_alrt_snippt:' ', uc_alrt_body:' ', uc_alrt_display:false, uc_alrt_splash:false, uc_alrt_pubdt:Time.zone.today.in_time_zone.to_datetime}
    end

    alias_attribute :title, :uc_alrt_title
    alias_attribute :display, :uc_alrt_display
    alias_attribute :body, :uc_alrt_body
    alias_attribute :publication_date, :uc_alrt_pubdt
    alias_attribute :snippet, :uc_alrt_snippt

    validates :uc_alrt_title, presence: true
    validates :uc_alrt_body, presence: true

    before_save :set_default_values
    before_create :set_id

    if self.primary_database_is_oracle?
      attribute :uc_alrt_display, :boolean
      attribute :uc_alrt_splash, :boolean
    end

    def self.get_latest
      self.where(uc_alrt_display: true, uc_alrt_splash: false).order(created_at: :desc).first
    end

    def self.get_latest_splash
      self.where(uc_alrt_display: true, uc_alrt_splash: true).order(created_at: :desc).first
    end

    def preview
      body.try :html_safe
    end

    def to_feed
      feed = {
        title: uc_alrt_title,
        timestamp: format_date(uc_alrt_pubdt.to_datetime, '%b %d'),
        body: uc_alrt_body
      }
      feed[:snippet] = uc_alrt_snippt if uc_alrt_snippt.present?
      feed
    end

  end
end
