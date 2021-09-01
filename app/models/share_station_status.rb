class ShareStationStatus < ApplicationRecord
  belongs_to :share_station
  belongs_to :brand

  validates :station_id,
            :num_docks_available,
            :is_returning,
            :is_installed,
            :num_bikes_available,
            :is_renting,
            presence: true

  def self.for(payload, brand=nil)
    brand = brand || get_default_brand
    payload_hash = parse_json_payload(payload)
    return find_or_create_for(payload_hash, brand)
  end

  def self.for_hash(hash, brand=nil)
    brand = brand || get_default_brand
    return find_or_create_for(hash, brand)
  end

  def self.find_or_create_for(hash, brand)
    return nil if hash.nil?
    return nil if brand.nil?

    total_creates = 0
    total_updates = 0

    stations_hash = get_stations(hash)

    new_or_updated_stations = stations_hash.map do |station_hash|
      station = ShareStation.find_by(brand: brand, station_uuid: station_hash[:station_id])
      if station.present?
        station_status = find_by(brand: brand, station_id: station_hash[:station_id])
        if station_status.nil?
          station_status = create!(
            creation_hash(station_hash, brand, station)
          )
          total_creates = total_creates + 1
        else
          station_status.update!(
            creation_hash(station_hash, brand, station)
          )
          total_updates = total_updates + 1
        end
        station_status
      end
    end
    puts "[ShareStationStatusModel][Totals] creates=#{total_creates} update=#{total_updates}"
    new_or_updated_stations.compact
  end

  def self.creation_hash(station_hash, brand, share_station)
    {
      station_id: station_hash[:station_id],
      num_docks_available: station_hash[:num_docks_available],
      is_returning: station_hash[:is_returning],
      is_installed: station_hash[:is_installed],
      num_bikes_available: station_hash[:num_bikes_available],
      is_renting: station_hash[:is_renting],
      share_station: share_station,
      brand: brand
    }
  end

  def self.get_stations(hash)
    hash[:data][:stations]
  end

  def self.parse_json_payload(payload)
    JSON.parse(payload).with_indifferent_access
  end

  def self.get_default_brand
    Brand.find_by(name: 'Biketown')
  end
end
