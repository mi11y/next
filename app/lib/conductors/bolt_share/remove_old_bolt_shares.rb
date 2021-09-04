module Conductors
  module BoltShare
    class RemoveOldBoltShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBoltShares"
      end

      def query
        brand = Brand.find_by(name: 'Bolt')
        Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
      end
    end
  end
end