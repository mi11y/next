require 'faraday'

module WebServices
    module Trimet
        class Stops
            def initialize(origin: nil, max_distance_feet: nil)
                @origin = origin || {lat: "45.5189108389813", lon: "-122.67928167332214"}
                @max_distance_feet = max_distance_feet || 1000
            end

            def get_data
                connect
                return nil if error?
                puts "[WebServices][Trimet][Stops] status=#{@response.status}"
                parse_body_as_json
            end

            def connect
               @response = Faraday.get(
                    'http://developer.trimet.org/ws/v1/stops',
                    {
                        appID: "#{ENV['TRIMET_API_KEY']}",
                        ll: "#{@origin[:lat]}, #{@origin[:lon]}",
                        feet: @max_distance_feet,
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