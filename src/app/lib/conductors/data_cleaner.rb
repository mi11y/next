module Conductors
    class DataCleaner
        def initialize(max_age_in_minutes=5)
            @max_age_in_minutes = max_age_in_minutes
            @targets = []
        end

        def run
            clean
        end

        protected

        def cleaner_name
            raise NotImplementedError
        end

        def brand
            raise NotImplementedError
        end

        def clean
            @targets = query
            puts "[#{cleaner_name}] About to delete count=#{@targets.count} records"
            @targets.destroy_all
            puts "[#{cleaner_name}] Done"
        end

        private

        def query
            Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
        end
    end
end