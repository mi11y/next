module TextUtils
  module Odot
    class NameParser
      def initialize(origin_name)
        @location_name = origin_name
        parse
      end

      def name
        highway_name = @location_name[0]
        highway_name = highway_name.split[0].strip if (is_oregon_highway? ||
          is_us_highway? ||
          is_interstate_highway? ||
          is_washington_highway?)
        highway_name = highway_name.gsub(/ORE/, "") if is_oregon_highway?
        highway_name = highway_name.gsub(/I-/, "") if is_interstate_highway?
        highway_name = highway_name.gsub(/US/, "") if is_us_highway?
        highway_name = highway_name.gsub(/SR/, "") if is_washington_highway?
        highway_name
      end

      def direction
        return "NB" if northbound?
        return "WB" if westbound?
        return "SB" if southbound?
        return "EB" if eastbound?
        ""
      end

      def cross_street
        return "" if @location_name[1].nil?
        @location_name[1].strip
      end

      def highway_type
        return "Interstate" if is_interstate_highway?
        return "US" if is_us_highway?
        return "SR" if is_washington_highway?
        return "Oregon" if is_oregon_highway?
        "Road"
      end

      private

      def northbound?
        @location_name[0].include? "NB"
      end

      def southbound?
        @location_name[0].include? "SB"
      end

      def westbound?
        @location_name[0].include? "WB"
      end

      def eastbound?
        @location_name[0].include? "EB"
      end

      def is_oregon_highway?
        @location_name[0].strip.include? "ORE"
      end

      def is_interstate_highway?
        @location_name[0].strip.include? "I-"
      end

      def is_us_highway?
        @location_name[0].strip.include? "US"
      end

      def is_washington_highway?
        @location_name[0].strip.include? "SR"
      end

      def parse
        remove_image
        remove_special_characters
        split_origin_cross_street
      end

      def remove_image
        @location_name = @location_name.gsub(/(\|.+.png)/,"")
      end

      def remove_special_characters
        @location_name = @location_name.gsub(/(\[|\])/,"")
      end

      def split_origin_cross_street
        @location_name = @location_name.split(";")
      end
    end
  end
end