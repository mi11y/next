module Conductors
  module Trimet
    class RouteFeatureFinder
      def initialize(routes: )
        @routes = routes || []
        @results = {}
      end

      def run
        return self unless @routes.present?

        Route.where(route_number: @routes).each do |r|
          @results[r.route_number] = r.to_hash
        end
        self
      end

      def response
        @results
      end
    end
  end
end
