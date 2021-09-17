module Conductors
    class Bird < Base
        attr_reader :name

        def initialize
            @name = 'Bird'
        end

        private

        def web_service_get_data
            WebServices::Bird.new.get_data
        end
    end
end