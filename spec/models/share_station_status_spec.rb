require 'rails_helper'

RSpec.describe ShareStationStatus, type: :model do
  let(:sample_payload) {
    '{
      "data": {
        "stations": [
          {
            "station_id": "1440914047883886936",
            "num_docks_available": 7,
            "is_returning": 1,
            "eightd_has_available_keys": false,
            "num_docks_disabled": 0,
            "num_ebikes_available": 10,
            "num_bikes_disabled": 1,
            "is_installed": 1,
            "legacy_id": "1440914047883886936",
            "num_bikes_available": 10,
            "is_renting": 1,
            "last_reported": 1599623637,
            "station_status": "active"
          },
          {
            "station_id": "1440913894229590996",
            "num_docks_available": 4,
            "is_returning": 1,
            "eightd_has_available_keys": false,
            "num_docks_disabled": 0,
            "num_ebikes_available": 2,
            "num_bikes_disabled": 2,
            "is_installed": 1,
            "legacy_id": "1440913894229590996",
            "num_bikes_available": 2,
            "is_renting": 1,
            "last_reported": 1602009900,
            "station_status": "active"
          },
          {
            "station_id": "1440914086764514614",
            "num_docks_available": 18,
            "is_returning": 0,
            "eightd_has_available_keys": false,
            "num_docks_disabled": 0,
            "num_ebikes_available": 0,
            "num_bikes_disabled": 0,
            "is_installed": 1,
            "legacy_id": "1440914086764514614",
            "num_bikes_available": 0,
            "is_renting": 0,
            "last_reported": 1626714815,
            "station_status": "out_of_service"
          }
        ]
      }
    }'
  }

  describe 'validations' do
    subject { described_class.new }

    it { should validate_presence_of(:station_id) }
    it { should validate_presence_of(:num_docks_available) }
    it { should validate_presence_of(:is_returning) }
    it { should validate_presence_of(:is_installed) }
    it { should validate_presence_of(:num_bikes_available) }
    it { should validate_presence_of(:is_renting) }
  end

  let(:brand) { Brand.find_by(name: 'Biketown' )}

  before do
    ShareStation.create!(
      lat: 1,
      lon: 2,
      capacity: 12,
      name: "test",
      station_uuid: "1440914047883886936",
      brand: brand
    )
    ShareStation.create!(
      lat: 1,
      lon: 2,
      capacity: 12,
      name: "test",
      station_uuid: "1440913894229590996",
      brand: brand
    )
    ShareStation.create!(
      lat: 1,
      lon: 2,
      capacity: 12,
      name: "test",
      station_uuid: "1440914086764514614",
      brand: brand
    )
  end

  describe '.for' do
    subject { described_class }

    it 'can initialize from a JSON payload' do
      result = subject.for(sample_payload, brand)
      expect(result.first).to be_a described_class
    end

    it 'persists share station status in the database' do
      subject.for(sample_payload, brand)
      expect(ShareStationStatus.find_by(station_id: "1440914047883886936")).to_not be nil
    end

    it 'initializes to a default brand' do
      result = subject.for(sample_payload)
      expect(result.first.brand.name).to eq('Biketown')
    end

    it 'sets the number of docks available' do
      result = subject.for(sample_payload, brand)
      expect(result.first.num_docks_available).to eq(7)
    end

    it 'sets whether the station accepts returns' do
      result = subject.for(sample_payload, brand)
      expect(result.first.is_returning).to eq(1)
    end

    it 'sets whether the station is installed' do
      result = subject.for(sample_payload, brand)
      expect(result.first.is_installed).to eq(1)
    end

    it 'sets the number of bikes available' do
      result = subject.for(sample_payload, brand)
      expect(result.first.num_bikes_available)
    end

    it 'sets whether the station is renting' do
      result = subject.for(sample_payload, brand)
      expect(result.first.is_renting)
    end

    context 'when the bike already exists' do
      it 'does not create a new record' do
        subject.for(sample_payload, brand)
        subject.for(sample_payload, brand)

        expect(ShareStationStatus.count).to eq(3)
      end
    end
  end

  describe '.for_hash' do
    subject { described_class }

    it 'can initialize from a hash payload' do
      result = subject.for_hash(JSON.parse(sample_payload).with_indifferent_access, brand)
      expect(result.first).to be_a described_class
    end
  end
end
