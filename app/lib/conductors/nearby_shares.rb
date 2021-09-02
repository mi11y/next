module Conductors
    class NearbyShares

        attr_accessor :result

        def initialize(origin: nil, max_distance_miles: 0.19)
            @max_distance_miles = max_distance_miles
            @origin = origin || {lat: "45.5189108389813", lon: "-122.67928167332214"}
            @calculator = Calculators::Distance.new(@origin)
        end

        def run
            @result = {
                Spin: [],
                Lime: [],
                Bird: []
            }
            all_brands = {}
            Brand.all.each do |brand|
                if all_brands[brand.id].nil?
                    all_brands[brand.id] = brand
                end
            end
            Share.find_each(batch_size: 500) do |share|
                distance = @calculator.calculate(share)
                matching_brand = all_brands[share.brand_id]
                if @result[matching_brand.name.to_sym].nil?
                    @result[matching_brand.name.to_sym] = []
                end
                if distance <= @max_distance_miles
                    @result[matching_brand.name.to_sym] << {
                        distance: (distance * 5280).ceil,
                        lat: share.lat,
                        lon: share.lon,
                        brand: matching_brand.name,
                        bike_uuid: share.bike_uuid
                    }
                end
            end
            return self
        end
    end
end
