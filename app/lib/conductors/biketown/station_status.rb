module Conductors
  module Biketown
    class StationStatus < Conductors::Base
      attr_reader :name

      def initialize
        @name = 'Biketown'
      end

      private

      def web_service_get_data
        WebServices::Biketown::StationStatus.new.get_data
      end

      def find_or_create_shares(hash)
        raise ConductorNameNotDefinedError if @name.nil?
        brand = Brand.find_by(name: @name)
        ShareStationStatus.for_hash(hash, brand)
      end
    end
  end
end
