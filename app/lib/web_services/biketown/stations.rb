module WebServices
  module Biketown
    class Stations < WebServices::GbfsService
      private

      BIKETOWN_STATION_GBFS_API_URL = 'https://gbfs.biketownpdx.com/gbfs/en/station_information.json'

      def gbfs_api_url
        BIKETOWN_STATION_GBFS_API_URL
      end
    end
  end
end
