module Conductors
    module Trimet
        class ArrivalTimes < Conductors::Base
            attr_reader :name

            def initialize(stops=nil)
                @name = 'Trimet'
                @stops = stops
            end

            private

            def web_service_get_data
                return [] unless @stops.present?
                WebServices::Trimet::Arrivals.new(@stops).get_data
            end

            def find_or_create_shares(hash)
                result = {}

                return result unless hash.present?

                if hash[:resultSet][:detour].present?
                    result[:detour] = hash[:resultSet][:detour]
                end

                result[:arrival]  = hash[:resultSet][:arrival]
                result[:location] = hash[:resultSet][:location]
                return result
            end
        end
    end    
end