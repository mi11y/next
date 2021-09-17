module WebServices
  module Odot
    class DriveTimes
      def get_data
        connect
        return nil if error?
        puts "[WebServices][ODOT][DriveTimes] status=#{@response.status}"
        parse_body_as_json
      end

      def connect
        @response = Faraday.get(
          'https://tripcheck.com/Scripts/map/data/traveltime.js'
        )
      end

      def error?
        @response.status != 200
      end

      def parse_body_as_json
        JSON.parse(@response.body).with_indifferent_access
      end
    end
  end
end
