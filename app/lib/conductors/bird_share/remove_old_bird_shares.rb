module Conductors
  module BirdShare
    class RemoveOldBirdShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBirdShares"
      end

      def query
        brand = Brand.find_by(name: 'Bird')
        Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
      end
    end
  end
end