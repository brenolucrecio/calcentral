module Links
  class Link < ApplicationRecord
    has_and_belongs_to_many :link_sections
    has_and_belongs_to_many :user_roles

    validates :name, :presence => true
    validates :url, :presence => true
    # This URL validator is quite primitive but probably sufficient for our needs
    validates :url, :format => URI::regexp(%w(http https))
    validates :link_sections, :presence => true
    validates :user_roles, :presence => true

  end
end
