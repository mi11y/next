require 'rails_helper'

RSpec.describe Conductors::NearbyTransit do
  subject { Conductors::NearbyTransit.new }

  describe '#new' do

    it 'initializes origin to pioneer square by default' do
      expect(subject.origin).to eq({
                                     lat: "45.5189108389813",
                                     lon: "-122.67928167332214"
                                   })
    end

    it 'initializes max distance to 0.19 by default' do
      expect(subject.max_distance_miles).to eq(0.19)
    end
  end

  describe '#run' do

    let(:nearby_shares_double) { instance_double(Conductors::NearbyShares, result: { test: 1 }) }
    let(:nearby_stops_double) { instance_double(Conductors::Trimet::NearbyStopsWithArrivals, response: { potato: 3 }) }
    let(:nearby_share_station_double) { instance_double(Conductors::Biketown::NearbyStations, result: { banana: 2 }) }
    let(:nearby_drive_times_double) { instance_double(Conductors::Odot::NearbyDriveTimes, result: { apple: 4 }) }

    before do
      allow(Conductors::NearbyShares).to receive(:new).and_return(nearby_shares_double)
      allow(nearby_shares_double).to receive(:run).and_return(nearby_shares_double)

      allow(Conductors::Biketown::NearbyStations).to receive(:new).and_return(nearby_share_station_double)
      allow(nearby_share_station_double).to receive(:run).and_return(nearby_share_station_double)

      allow(Conductors::Trimet::NearbyStopsWithArrivals).to receive(:new).and_return(nearby_stops_double)
      allow(nearby_stops_double).to receive(:run).and_return(nearby_stops_double)

      allow(Conductors::Odot::NearbyDriveTimes).to receive(:new).and_return(nearby_drive_times_double)
      allow(nearby_drive_times_double).to receive(:run).and_return(nearby_drive_times_double)
    end

    it 'calls NearbyShares for data' do
      expect(nearby_shares_double).to receive(:run)
      expect(nearby_shares_double).to receive(:result)
      subject.run
    end

    it 'calls NearbyStopsWithArrivals for data' do
      expect(nearby_stops_double).to receive(:run)
      expect(nearby_stops_double).to receive(:response)
      subject.run
    end

    it 'calls NearbyStations for data' do
      expect(nearby_share_station_double).to receive(:run)
      expect(nearby_share_station_double).to receive(:result)
      subject.run
    end

    it 'calls NearbyDriveTimes for data' do
      expect(nearby_drive_times_double).to receive(:run)
      expect(nearby_drive_times_double).to receive(:result)
      subject.run
    end

    it 'returns a hash containing expected data' do
      expect(subject.run).to eq({
                                  bike_shares: { test: 1 },
                                  trimet_stops: { potato: 3 },
                                  share_stations: { banana: 2 },
                                  drive_times: { apple: 4 }
                                })
    end
  end
end