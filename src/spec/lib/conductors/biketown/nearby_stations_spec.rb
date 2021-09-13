require 'rails_helper'

RSpec.describe Conductors::Biketown::NearbyStations do
  subject { Conductors::Biketown::NearbyStations.new }

  let(:brand) { instance_double(Brand, id: 1, name: 'Bogie') }
  let(:station_1) { instance_double(ShareStation,
                                    id: 13,
                                    lat: 1,
                                    lon: 2,
                                    capacity: 12,
                                    name: "Test Station @ Main St",
                                    station_uuid: "1234",
                                    brand: brand,
  ) }
  let(:station_2) { instance_double(ShareStation,
                                    id: 14,
                                    lat: 20,
                                    lon: 30,
                                    capacity: 12,
                                    name: "Test Station 2 @ John St",
                                    station_uuid: "5432",
                                    brand: brand,
  ) }
  let(:share_station_1_status) { instance_double(ShareStationStatus,
                                                 share_station: station_1,
                                                 num_docks_available: 5,
                                                 is_returning: 1,
                                                 num_bikes_available: 1,
                                                 is_renting: 1,
                                                 brand: brand,
                                                 ) }
  let(:share_station_2_status) { instance_double(ShareStationStatus,
                                                 share_station: station_2,
                                                 num_docks_available: 10,
                                                 is_returning: 1,
                                                 num_bikes_available: 2,
                                                 is_renting: 1,
                                                 brand: brand,
                                                 ) }
  let(:distance_calculator)  { instance_double(Calculators::Distance) }

  before do
    allow(Brand).to receive(:all).and_return([brand])
    allow(ShareStation).to receive(:find_each).
      and_yield(station_1).
      and_yield(station_2)

    allow(Calculators::Distance).to receive(:new).and_return(distance_calculator)

    allow(distance_calculator).to receive(:calculate).
      with(station_1).and_return(0.09)
    allow(distance_calculator).to receive(:calculate).
      with(station_2).and_return(0.32)

    allow(station_1).to receive(:share_station_status).and_return(share_station_1_status)
    allow(station_2).to receive(:share_station_status).and_return(share_station_2_status)
  end


  it 'returns stations within the max distance' do
    result = subject.run.result

    expect(result[:biketown].first[:station_uuid]).to eq("1234")
    expect(result[:biketown].first[:station_status][:num_docks_available]).to eq(5)
  end

  it 'excludes stations outside the max distance' do
    result = subject.run.result
    expect(result[:biketown].count).to eq(1)
  end
end
