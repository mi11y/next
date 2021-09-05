module Conductors
  module LimeShare
    class RemoveOldLimeShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldLimeShares"
      end

      def brand
        Brand.find_by(name: 'Lime')
      end
    end
  end
end
