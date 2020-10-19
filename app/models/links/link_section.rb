module Links
  class LinkSection < ApplicationRecord
    has_and_belongs_to_many :links

    # This class is related to another class via three different names
    belongs_to :link_root_cat, :foreign_key => "link_root_cat_id", :class_name => "Links::LinkCategory"
    belongs_to :link_top_cat, :foreign_key => "link_top_cat_id", :class_name => "Links::LinkCategory"
    belongs_to :link_sub_cat, :foreign_key => "link_sub_cat_id", :class_name => "Links::LinkCategory"

    validates :link_root_cat, :presence => true
    validates :link_top_cat, :presence => true
    validates :link_sub_cat, :presence => true

  end
end
