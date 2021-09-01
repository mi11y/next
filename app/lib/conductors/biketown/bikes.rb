module Conductors
    module Biketown
        class Bikes < Conductors::Base
            attr_reader :name

            def initialize
                @name = 'Biketown'
            end

            private

            def web_service_get_data
                WebServices::Biketown::Bikes.new.get_data
            end
        end
    end
end
