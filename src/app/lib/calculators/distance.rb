require 'haversine'

module Calculators
  class Distance
    def initialize(origin)
      puts ":: Origin => #{origin}"
      @origin = origin
    end

    def calculate(share)
      Haversine.distance(@origin[:lat].to_d,
                                @origin[:lon].to_d,
                                share.lat.to_d,
                                share.lon.to_d).to_miles
    end
  end
end
