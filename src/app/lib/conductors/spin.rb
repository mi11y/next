module Conductors
    class Spin < Base
        attr_reader :name
        
        def initialize
            @name = 'Spin'
        end
        
        private 

        def web_service_get_data
            WebServices::Spin.new.get_data
        end
    end
end
