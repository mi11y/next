require 'faraday'

module WebServices
    class Lime < GbfsService
        private

        LIME_GBFS_API_URL = 'https://data.lime.bike/api/partners/v1/gbfs/portland/free_bike_status'

        def gbfs_api_url
            LIME_GBFS_API_URL
        end
    end
end
