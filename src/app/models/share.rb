class Share < ApplicationRecord
  belongs_to :brand

  validates :brand, :lat, :lon, :bike_uuid, :disabled, :reserved, presence: true

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

  def self.parse_json_payload(payload)
      JSON.parse(payload).with_indifferent_access
  end

  def self.find_or_create_for(hash, brand)
    return nil if hash.nil?
    return nil if brand.nil?

    total_creates = 0
    total_updates = 0

    free_shares_hash = get_free_shares(hash)

    new_or_updated_shares = free_shares_hash.map do |shares_hash| 
      share = find_by(brand: brand, bike_uuid: shares_hash[:bike_id])
      if share.nil?
        share = create!(
          creation_hash(shares_hash, brand)
        )
        total_creates = total_creates + 1
      else
        share.update!(
          creation_hash(shares_hash, brand)
        )
        total_updates = total_updates + 1
      end
      share
    end
    puts "[ShareModel][Totals] creates=#{total_creates} update=#{total_updates}"
    return new_or_updated_shares
  end

  def self.get_free_shares(hash)
    hash[:data][:bikes]
  end

  def self.creation_hash(shares_hash, brand)
    {
      lat: shares_hash[:lat],
      lon: shares_hash[:lon],
      bike_uuid: shares_hash[:bike_id],
      disabled: shares_hash[:is_disabled],
      reserved: shares_hash[:is_reserved],
      brand: brand
    }
  end

  def self.get_default_brand
    Brand.find_by(name: 'Bird')
  end
end
