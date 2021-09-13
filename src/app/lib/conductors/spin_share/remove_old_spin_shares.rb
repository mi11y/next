module Conductors
  module SpinShare
    class RemoveOldSpinShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldSpinShares"
      end

      def brand
        Brand.find_by(name: 'Spin')
      end
    end
  end
end