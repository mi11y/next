module WebServices
  module Biketown
    class StationStatus < WebServices::GbfsService
      private

      BIKETOWN_STATION_STATUS_API_URL = 'https://gbfs.biketownpdx.com/gbfs/en/station_status.json'

      def gbfs_api_url
        BIKETOWN_STATION_STATUS_API_URL
      end
    end
  end
end