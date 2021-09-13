module Conductors
  module Biketown
    class RemoveOldBiketownShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBiketownShares"
      end

      def brand
        Brand.find_by(name: 'Biketown')
      end
    end
  end
end