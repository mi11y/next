module WebServices
  module Trimet
    class Routes
      def initialize(routes: [12,93,290])
        @routes = routes
      end

      def get_data
        connect
        return nil if error?
        puts "[WebServices][Trimet][Routes] status=#{@response.status}"
        parse_body_as_json
      end

      def connect
        @response = Faraday.get(
          'http://developer.trimet.org/ws/v1/routeConfig',
          {
            appID: "#{ENV['TRIMET_API_KEY']}",
            routes: @routes * ',',
            json: true
          }
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