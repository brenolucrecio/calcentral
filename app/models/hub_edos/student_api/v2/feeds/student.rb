module HubEdos
  module StudentApi
    module V2
      module Feeds
        class Student < ::HubEdos::Proxy
          def url
            # Contact information not currently needed and thus excluded ('&inc-cntc=true')
            "#{@settings.base_url}/v2/students/#{@campus_solutions_id}?inc-acad=true&inc-regs=true"
          end

          def json_filename
            'hub_v2_student.json'
          end
        end
      end
    end
  end
end
