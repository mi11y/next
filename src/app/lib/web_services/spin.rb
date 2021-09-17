require 'faraday'

module WebServices
    class Spin < GbfsService
        private

        SPIN_GBFS_API_URL = 'https://gbfs.spin.pm/api/gbfs/v1/portland/free_bike_status.json'

        def gbfs_api_url
            SPIN_GBFS_API_URL
        end
    end
end
