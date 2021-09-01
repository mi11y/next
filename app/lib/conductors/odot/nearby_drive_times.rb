module Conductors
  module Odot
    class NearbyDriveTimes
      attr_accessor :result

      def initialize(origin = nil, max_distance_miles = 0.19)
        @max_distance_miles = max_distance_miles
        @origin = origin || { lat: "45.5189108389813", lon: "-122.67928167332214" }
        @calculator = Calculators::Distance.new(@origin)
      end

      def run
        @result = []
        DriveTimeOrigin.find_each(batch_size: 100) do |drive_time|
          calculated_distance = @calculator.calculate(drive_time)
          if calculated_distance <= @max_distance_miles
            destinations = drive_time.drive_time_destinations.map do |destination|
              parser = TextUtils::Odot::NameParser.new(destination.route_destination)
              drive_time_destination_for(destination, parser)
            end
            parser = TextUtils::Odot::NameParser.new(drive_time.location_name)
            @result << drive_time_origin_for(destinations, drive_time, parser)
          end
        end
        self
      end

      private

      def drive_time_destination_for(destination, parser)
        {
          destination_id: destination.destination_id,
          route_destination: parser.name,
          direction: parser.direction,
          cross_street: parser.cross_street,
          highway_type: parser.highway_type,
          min_route_time: destination.min_route_time,
          travel_time: destination.travel_time,
          delay: destination.delay
        }
      end

      def drive_time_origin_for(destinations, drive_time, parser)
        {
          origin_id: drive_time.origin_id,
          location_name: parser.name,
          direction: parser.direction,
          cross_street: parser.cross_street,
          highway_type: parser.highway_type,
          lat: drive_time.lat,
          lon: drive_time.lon,
          destinations: destinations
        }
      end
    end
  end
end
