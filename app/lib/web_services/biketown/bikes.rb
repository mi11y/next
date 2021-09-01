module WebServices
  module Biketown
    class Bikes < WebServices::GbfsService
      private

      BIKETOWN_GBFS_API_URL = 'https://gbfs.biketownpdx.com/gbfs/en/free_bike_status.json'

      def gbfs_api_url
        BIKETOWN_GBFS_API_URL
      end
    end
  end
end
