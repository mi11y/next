module Conductors
  module LimeShare
    class RemoveOldLimeShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldLimeShares"
      end

      def query
        brand = Brand.find_by(name: 'Lime')
        Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
      end
    end
  end
end
