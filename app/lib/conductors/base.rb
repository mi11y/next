module Conductors
    class Base

        attr_accessor :results

        class ConductorNameNotDefinedError < StandardError
        end

        def run
            result_hash = web_service_get_data
            @results = find_or_create_shares(result_hash)
            self
        end

        def create_or_update_count
            return 0 if @results.nil?
            @results.length
        end

        protected


        def web_service_get_data
            raise NotImplementedError
        end

        def find_or_create_shares(hash)
            raise ConductorNameNotDefinedError if @name.nil?
            brand = Brand.find_by(name: @name)
            Share.for_hash(hash, brand)
        end
    end
end
