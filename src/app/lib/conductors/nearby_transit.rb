module Conductors
  class NearbyTransit
    attr_accessor :result
    attr_reader :origin, :max_distance_miles

    def initialize(origin: nil, max_distance_miles: 0.19)
      @max_distance_miles = max_distance_miles
      @origin = origin || { lat: "45.5189108389813", lon: "-122.67928167332214" }
    end

    def run
      {
        bike_shares: Conductors::NearbyShares.new(origin: origin,
                                                  max_distance_miles: max_distance_miles).run.result,
        trimet_stops: Conductors::Trimet::NearbyStopsWithArrivals.new(origin: origin).run.response,
        share_stations: Conductors::Biketown::NearbyStations.new(origin: origin,
                                                                 max_distance_miles: max_distance_miles).run.result,
        drive_times: Conductors::Odot::NearbyDriveTimes.new(origin: origin,
                                                            max_distance_miles: 2).run.result
      }
    end
  end
end