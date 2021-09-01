module Conductors
    class RemoveOldShareStations < DataCleaner
        private

        def cleaner_name
            "RemoveOldShareStations"
        end

        def query
            ShareStation.where(['updated_at < ?', @max_age_in_minutes.minutes.ago])
        end
    end
end