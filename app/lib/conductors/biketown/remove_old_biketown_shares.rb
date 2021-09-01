module Conductors
  module Biketown
    class RemoveOldBiketownShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBiketownShares"
      end

      def query
        brand = Brand.find_by(name: 'Biketown')
        Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
      end
    end
  end
end