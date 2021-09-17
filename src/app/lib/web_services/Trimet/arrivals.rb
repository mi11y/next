require 'faraday'

module WebServices
    module Trimet
        class Arrivals
            def initialize(stops=nil, number_of_estimates=nil)
                @stops = stops || []
                @number_of_estimates = number_of_estimates || 2
            end

            def get_data
                return nil if @stops.nil? || @stops.empty?
                connect
                return nil if error?
                puts "[WebServices][Trimet][Arivals] status=#{@response.status}"
                parse_body_as_json
            end

            def connect
                @response = Faraday.get(
                    'http://developer.trimet.org/ws/v2/arrivals',
                    {
                        appID: "#{ENV['TRIMET_API_KEY']}",
                        locIDs: @stops * ',',
                        arrivals: @number_of_estimates
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