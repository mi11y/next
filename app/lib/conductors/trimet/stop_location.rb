module Conductors
    module Trimet
        class StopLocation < Conductors::Base
            attr_reader :name
            
            def initialize(origin=nil)
                @name = 'Trimet'
                @origin = origin || {lat: "45.5189108389813", lon: "-122.67928167332214"}
            end

            private

            def web_service_get_data
                WebServices::Trimet::Stops.new(origin: @origin).get_data
            end

            def find_or_create_shares(hash)
                return [] if hash[:resultSet][:location].nil?
                return hash[:resultSet][:location]
            end
        end
    end
end
