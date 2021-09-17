class ShareStation < ApplicationRecord
  belongs_to :brand
  has_one :share_station_status, dependent: :destroy

  validates :lat, :lon, :capacity, :name, :station_uuid, :brand,  presence: true

  def self.for(payload, brand=nil)
    brand = brand || get_default_brand
    payload_hash = parse_json_payload(payload)
    return find_or_create_for(payload_hash, brand)
  end

  def self.for_hash(hash, brand=nil)
    brand = brand || get_default_brand
    return find_or_create_for(hash, brand)
  end

  private

  def self.find_or_create_for(hash, brand)
    return nil if hash.nil?
    return nil if brand.nil?

    total_creates = 0
    total_updates = 0

    stations_hash = get_stations(hash)

    new_or_updated_stations = stations_hash.map do |station_hash|
      station = find_by(brand: brand, station_uuid: station_hash[:station_id])
      if station.nil?
        station = create!(
          creation_hash(station_hash, brand)
        )
        total_creates = total_creates + 1
      else
        station.update!(
          creation_hash(station_hash, brand)
        )
        total_updates = total_updates + 1
      end
      station
    end
    puts "[ShareStationsModel][Totals] creates=#{total_creates} update=#{total_updates}"
    return new_or_updated_stations
  end

  def self.creation_hash(station_hash, brand)
    {
      lat: station_hash[:lat],
      lon: station_hash[:lon],
      capacity: station_hash[:capacity],
      name: station_hash[:name],
      station_uuid: station_hash[:station_id],
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
