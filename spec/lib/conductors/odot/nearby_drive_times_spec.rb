require 'rails_helper'

RSpec.describe Conductors::Odot::NearbyDriveTimes do
  subject { Conductors::Odot::NearbyDriveTimes.new }

  let(:drive_time_origin_1) { instance_double(DriveTimeOrigin,
                                              origin_id: 1,
                                              location_name: "[I-205|sign-i-205.png] NB; SE Gladstone",
                                              lat: "1234",
                                              lon: "2345") }
  let(:drive_time_origin_2) { instance_double(DriveTimeOrigin,
                                              origin_id: 1,
                                              location_name: "[I-5|sign-i-5.png] SB; Carman Dr",
                                              lat: "4567",
                                              lon: "5678") }
  let(:drive_time_destination_1) { instance_double(DriveTimeDestination,
                                                   drive_time_origin: drive_time_origin_1,
                                                   destination_id: 1,
                                                   route_destination: "[I-205|sign-i-205.png]",
                                                   min_route_time: 10,
                                                   travel_time: 12,
                                                   delay: 2) }
  let(:drive_time_destination_2) { instance_double(DriveTimeDestination,
                                                   drive_time_origin: drive_time_origin_2,
                                                   destination_id: 2,
                                                   route_destination: "[I-84|sign-i-84.png]",
                                                   min_route_time: 25,
                                                   travel_time: 45,
                                                   delay: 20) }
  let(:drive_time_destination_3) { instance_double(DriveTimeDestination,
                                                   drive_time_origin: drive_time_origin_2,
                                                   destination_id: 3,
                                                   route_destination: "SE Powell Blvd",
                                                   min_route_time: 15,
                                                   travel_time: 20,
                                                   delay: 5) }
  let(:distance_calculator)  { instance_double(Calculators::Distance) }

  before do
    allow(DriveTimeOrigin).to receive(:find_each).
      and_yield(drive_time_origin_1).
      and_yield(drive_time_origin_2)

    allow(Calculators::Distance).to receive(:new).and_return(distance_calculator)
    allow(distance_calculator).to receive(:calculate).
      with(drive_time_origin_1).and_return(0.09)
    allow(distance_calculator).to receive(:calculate).
      with(drive_time_origin_2).and_return(0.32)
    allow(drive_time_origin_1).to receive(:drive_time_destinations).and_return([drive_time_destination_1])
    allow(drive_time_origin_2).to receive(:drive_time_destinations).and_return([drive_time_destination_2, drive_time_destination_3])
  end

  it 'returns drive times within the max distance' do
    result = subject.run.result
    expect(result.first[:origin_id]).to eq(1)
    expect(result.first[:location_name]).to eq("205")
  end

  it 'excludes drive times outside the max distance' do
    result = subject.run.result
    expect(result.count).to eq(1)
  end
end