require 'faraday'

module WebServices
    class Bird < GbfsService
        private 

        BIRD_GBFS_API_URL = 'https://mds.bird.co/gbfs/portland/free_bike_status.json'

        def gbfs_api_url
            BIRD_GBFS_API_URL
        end
    end
end
