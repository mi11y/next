module Conductors
  module BirdShare
    class RemoveOldBirdShares < DataCleaner
      private

      def cleaner_name
        "RemoveOldBirdShares"
      end

      def brand
        Brand.find_by(name: 'Bird')
      end
    end
  end
end