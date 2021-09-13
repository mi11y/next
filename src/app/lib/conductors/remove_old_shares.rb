module Conductors
    class RemoveOldShares < DataCleaner

        private

        def cleaner_name
            "RemoveOldShares"
        end

        def query
            Share.where(['updated_at < ?', @max_age_in_minutes.minutes.ago])
        end
    end
end
