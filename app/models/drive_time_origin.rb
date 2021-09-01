class DriveTimeOrigin < ApplicationRecord
  validates :origin_id, :location_name, :lat, :lon, presence: true

  has_many :drive_time_destinations

  def self.for(hash)
    total_creates = 0
    total_updates = 0

    drive_times = hash[:features]

    new_or_updated_drive_times = drive_times.map do |drive_time_hash|
      creation_result = find_or_create_origin_for(drive_time_hash)
      total_creates = total_creates + creation_result[:total_creates]
      total_updates = total_updates + creation_result[:total_updates]
      creation_result[:drive_time]
    end
    puts "[DriveTimeOrigin][Totals] creates=#{total_creates} update=#{total_updates}"
    return new_or_updated_drive_times
  end

  private

  def self.find_or_create_origin_for(drive_time_hash)
    total_creates = 0
    total_updates = 0

    drive_time = find_by(origin_id: drive_time_hash[:attributes][:origId])
    if drive_time.nil?
      drive_time = create!(
        creation_hash(drive_time_hash[:attributes])
      )
      total_creates = total_creates + 1
    else
      drive_time.update!(
        creation_hash(drive_time_hash[:attributes])
      )
      total_updates = total_updates + 1
    end
    {
      drive_time: drive_time,
      total_creates: total_creates,
      total_updates: total_updates
    }
  end

  def self.creation_hash(drive_time_hash)
    location_name = drive_time_hash[:locationName]
    {
      origin_id: drive_time_hash[:origId],
      location_name: location_name,
      lat: drive_time_hash[:latitude],
      lon: drive_time_hash[:longitude]
    }
  end
end
