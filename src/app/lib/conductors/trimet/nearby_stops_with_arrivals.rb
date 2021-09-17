module Conductors
    module Trimet
        class NearbyStopsWithArrivals
            attr_reader :name, :stops

            def initialize(origin: nil)
                @name = 'Trimet'
                @origin = origin
            end

            def run
                @stops_payload = Conductors::Trimet::StopLocation.new(@origin).run.results
                stop_locids = get_stop_locids
                @arrivals_payload = Conductors::Trimet::ArrivalTimes.new(stop_locids[0..9]).run.results
                route_numbers = collect_routes
                @route_numbers_hash = Conductors::Trimet::RouteFeatureFinder.new(routes: route_numbers).run.response
                self
            end

            def response
                @stops = {}

                if @arrivals_payload.present?
                    collect_stops
                end

                @stops
            end

            private

            def collect_routes
                route_numbers = []
                return route_numbers unless @arrivals_payload[:arrival].present?
                @arrivals_payload[:arrival].each do |arrival|
                    route_numbers << get_route(arrival)
                end
                route_numbers
            end

            def collect_stops
                @arrivals_payload[:location].each do |location|
                    @stops[get_arrival_locations_locid(location)] = create_stop(location)
                end

                @arrivals_payload[:arrival].each do |arrival|
                    arrival_stop_id = arrival_stop_locid(arrival)
                    @stops[arrival_stop_id][:arrivals] << create_arrival(arrival)
                end
            end
            
            def create_arrival(arrival)
                result = {}
                result[:route]          = get_route(arrival)
                result[:departed]       = departed?(arrival) if arrival[:departed].present?
                result[:scheduled]      = get_scheduled_arrival(arrival) if arrival[:scheduled].present?
                result[:est_arrival]    = get_estimated_arrival(arrival) if arrival[:estimated].present?
                result[:full_sign]      = get_full_sign(arrival) if arrival[:fullSign].present?
                result[:short_sign]     = get_short_sign(arrival) if arrival[:shortSign].present?
                result[:route_info]     = @route_numbers_hash[get_route(arrival)]
                return result
            end

            def get_full_sign(arrival)
                arrival[:fullSign]
            end

            def get_short_sign(arrival)
                arrival[:shortSign]
            end

            def get_route(arrival)
                arrival[:route]
            end

            def departed?(arrival)
                arrival[:departed]
            end

            def get_scheduled_arrival(arrival)
                DateTime.strptime(arrival[:scheduled].to_s, '%Q').
                    in_time_zone("Pacific Time (US & Canada)").iso8601
            end

            def get_estimated_arrival(arrival)
                DateTime.strptime(arrival[:estimated].to_s, '%Q').
                    in_time_zone("Pacific Time (US & Canada)").iso8601
            end

            def arrival_stop_locid(arrival)
                arrival[:locid]
            end

            def create_stop(location)
                {
                    dir: location[:dir],
                    desc: location[:desc],
                    arrivals: []
                }
            end

            def get_arrival_locations_locid(location)
                location[:id]
            end

            def get_stop_locids
                @stops_payload.map do |stop|
                    stop[:locid]
                end
            end
        end
    end
end