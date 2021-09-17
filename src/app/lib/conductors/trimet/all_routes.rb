module Conductors
  module Trimet
    class AllRoutes < Conductors::Base
      attr_reader :name

      def initialize(routes: [])
        @name = 'Trimet'
        @routes = routes
      end

      private

      def web_service_get_data
        return [] if @routes.nil?
        WebServices::Trimet::Routes.new(routes: @routes).get_data
      end

      def find_or_create_shares(hash)
        raise ConductorNameNotDefinedError if @name.nil?
        brand = Brand.find_by(name: @name)
        Route.for_hash(hash, brand)
      end
    end
  end
end
