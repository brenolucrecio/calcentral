module Links
  # NOTES:
  # - Navigation consists of Main Categories, Subcategories, and On-page categories
  # - A Section is defined as a unique aggregate of MainCat/SubCat/PageCat
  # - A single Categories table serves all three purposes by being referred to thrice in the Sections model
  # - A Link can belong to multiple Sections; a Section consists of multiple links
  # - Links (or their URLs) are guaranteed unique
  class MyCampusLinks
    def get_feed
      links_json = campus_links_json
      load_cs_link_api_entries(links_json)
    end

    def load_cs_link_api_entries(links_json)
      links_json['links'].each do |link|
        if link_id = link.try(:[], 'cs_link_id')
          if cs_link = LinkFetcher.fetch_link(link_id)
            link['name'] = cs_link[:name]
            link['hoverText'] = cs_link[:title]
            link['url'] = cs_link[:url]
            if cs_link[:linkDescriptionDisplay]
              link['description'] = cs_link[:linkDescription]
            end
            link.merge!(cs_link)
          end
        end
      end
      links_json
    end

    def campus_links_json
      file = File.open("#{Rails.root}/public/json/campuslinks.json")
      contents = File.read(file)
      JSON.parse(contents)
    end

    def get_subsections_for_nav(cat)
      # Given a top-level category, get names and slugs of sub-categories for navigation. Find the unique subsections.
      categories = []
      Links::LinkSection.where('link_root_cat_id = ?', cat.id).select(:link_top_cat_id).uniq.each do |subsection|
        categories.push({
          'id' => subsection.link_top_cat.slug,
          'name' => subsection.link_top_cat.name
        })
      end
      categories.sort_by { |category| category['name'] }
    end
    # Given a link, return an array of the categories it lives in by examining its host sections
    def get_cats_for_link(link)
      categories = []
      link.link_sections.each do |section|
        if section.link_top_cat.present? && section.link_sub_cat.present?
          categories.push({
            'topcategory' => section.link_top_cat.name,
            'subcategory' => section.link_sub_cat.name
          })
        end
      end
      categories.sort_by { |category| [category['topcategory'], category['subcategory']] }
    end

    # Given a link, provide the client side with a list of the user roles who would be interested in it.
    def get_roles_for_link(link)
      roles = {
        'student' => false,
        'applicant' => false,
        'staff' => false,
        'faculty' => false,
        'exStudent' => false,
        'summerVisitor' => false
      }
      link.user_roles.each { |link_role| roles[link_role.slug] = true }
      roles
    end

  end
end
