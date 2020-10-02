module User
  module Academics
    class EnrollmentCareer
      include BerkeleyTime

      attr_accessor :acadCareer
      attr_accessor :termMaxUnits
      attr_accessor :sessionDeadlines

      alias :career_code :acadCareer
      alias :term_max_units :termMaxUnits
      alias :session_deadlines :sessionDeadlines

      def initialize(attrs = {})
        attrs.each do |key, value|
          send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

      def as_json(options={})
        {
          maxUnits: term_max_units,
          deadlines: session_deadlines.collect do |deadline|
            {
              session: deadline[:session],
              addDeadlineDatetime: zoned(deadline[:addDeadlineDatetime]),
              optionDeadlineDatetime: zoned(deadline[:optionDeadlineDatetime]),
            }
          end
        }
      end
    end
  end
end
