module Conductors
  module SpinShare
    class RemoveOldSpinShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldSpinShares"
      end

      def query
        brand = Brand.find_by(name: 'Spin')
        Share.where(["brand_id = ? AND updated_at < ?", brand, @max_age_in_minutes.minutes.ago])
      end
    end
  end
end