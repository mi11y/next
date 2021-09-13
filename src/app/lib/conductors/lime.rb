module Conductors
    class Lime < Base
        attr_reader :name
        
        def initialize
            @name = 'Lime'
        end

        private
        
        def web_service_get_data
            WebServices::Lime.new.get_data
        end
    end
end
