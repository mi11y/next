module Conductors
  module Biketown
    class NearbyStations
      attr_accessor :result

      def initialize(origin = nil, max_distance_miles = 0.19)
        @max_distance_miles = max_distance_miles
        @origin = origin || { lat: "45.5189108389813", lon: "-122.67928167332214" }
        @calculator = Calculators::Distance.new(@origin)
      end

      def run
        @result = {
          biketown: []
        }
        ShareStation.find_each(batch_size: 500) do |station|
          calculated_distance = @calculator.calculate(station)
          if calculated_distance <= @max_distance_miles
            @result[:biketown] << {
              distance: (calculated_distance * 5280).ceil,
              lat: station.lat,
              lon: station.lon,
              station_uuid: station.station_uuid,
              name: station.name,
              capacity: station.capacity,
              station_status: get_station_status(station)
            }
          end
        end
        self
      end

      private

      def get_station_status(station)
        status = station.share_station_status
        {
          num_docks_available: status.num_docks_available,
          is_returning: status.is_returning,
          num_bikes_available: status.num_bikes_available,
          is_renting: status.is_renting
        }
      end
    end
  end
end