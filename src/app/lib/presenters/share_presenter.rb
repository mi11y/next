module Presenters
  class SharePresenter
    def self.to_hash(distance:, brand:, share:)
      {
        distance: (distance * 5280).ceil,
        lat: share.lat,
        lon: share.lon,
        brand: brand.name,
        bike_uuid: share.bike_uuid
      }
    end
  end
end