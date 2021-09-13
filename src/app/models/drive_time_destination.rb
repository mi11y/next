class DriveTimeDestination < ApplicationRecord
  belongs_to :drive_time_origin

  validates :destination_id, :route_destination, :min_route_time, :travel_time, :delay, presence: true

  def self.for(hash)
    total_creates = 0
    total_updates = 0

    drive_times = hash[:features]

    destinations = []

    drive_times.each do |drive_time|
      drive_time_origin = DriveTimeOrigin.find_by(
        origin_id: drive_time_origin_id(drive_time))
      if drive_time_origin.present?
        drive_time_routes(drive_time).map do |route|
          creation_result = find_or_create_destination_for(route, drive_time_origin)
          total_creates = total_creates + creation_result[:total_creates]
          total_updates = total_updates + creation_result[:total_updates]
          destinations << creation_result[:destination]
        end
      end
    end
    puts "[DriveTimeDestination][Totals] creates=#{total_creates} update=#{total_updates}"
    destinations
  end

  private

  def self.find_or_create_destination_for(drive_time_destination, drive_time_origin)
    total_creates = 0
    total_updates = 0
    destination = find_by(destination_id: drive_time_destination[:id],
                          drive_time_origin: drive_time_origin)
    if destination.nil?
      destination = create!(
        creation_hash(drive_time_destination, drive_time_origin)
      )
      total_creates = total_creates + 1
    else
      destination.update!(
        creation_hash(drive_time_destination, drive_time_origin)
      )
      total_updates = total_updates + 1
    end
    {
      destination: destination,
      total_creates: total_creates,
      total_updates: total_updates
    }
  end

  def self.drive_time_routes(drive_time)
    drive_time[:attributes][:routes]
  end

  def self.drive_time_origin_id(drive_time)
    drive_time[:attributes][:origId]
  end

  def self.creation_hash(hash, drive_time_origin)
    {
      destination_id: hash[:id],
      route_destination: hash[:routeDest],
      min_route_time: hash[:minRouteTime],
      travel_time: hash[:travelTime],
      delay: hash[:delay],
      drive_time_origin: drive_time_origin
    }
  end
end
