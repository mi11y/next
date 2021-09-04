require 'faraday'

module WebServices
  class Bolt < GbfsService
    private

    BOLT_GBFS_API_URL = 'https://api-lb.micromobility.com/ptl/gbfs/en/free_bike_status.json'

    def gbfs_api_url
      BOLT_GBFS_API_URL
    end
  end
end