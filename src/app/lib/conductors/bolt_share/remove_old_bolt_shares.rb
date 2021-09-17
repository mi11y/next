module Conductors
  module BoltShare
    class RemoveOldBoltShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBoltShares"
      end

      def brand
        Brand.find_by(name: 'Bolt')
      end
    end
  end
end