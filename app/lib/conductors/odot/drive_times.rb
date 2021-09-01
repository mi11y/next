module Conductors
  module Odot
    class DriveTimes < Conductors::Base
      attr_reader :name

      def initialize()
        @name = 'DriveTimes'
      end

      private

      def web_service_get_data
        WebServices::Odot::DriveTimes.new.get_data
      end

      def find_or_create_shares(hash)
        raise ConductorNameNotDefinedError if @name.nil?
        origins = DriveTimeOrigin.for(hash)
        destinations = DriveTimeDestination.for(hash)
        origins + destinations
      end
    end
  end
end