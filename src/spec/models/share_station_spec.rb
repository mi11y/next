require 'rails_helper'

RSpec.describe ShareStation, type: :model do
  let(:sample_payload) {
    '{
      "data": {
        "stations": [
          {
            "name": "NE 68th at Sandy",
            "lon": -122.5933109,
            "rack_model": "CITY_PILOT_RACK",
            "legacy_id": "1459024287353491654",
            "address": "3236, Northeast 68th Avenue, Roseway, Portland, Multnomah County, Oregon, 97213, United States of America",
            "capacity": 10,
            "rental_uris": {
              "ios": "https://pdx.lft.to/lastmile_qr_scan",
              "android": "https://pdx.lft.to/lastmile_qr_scan"
            },
            "lat": 45.5464321,
            "external_id": "motivate_PDX_1459024287353491654",
            "eightd_has_key_dispenser": false,
            "dockless_bikes_parking_zone_capacity": 10,
            "eightd_station_services": [],
            "station_type": "lightweight",
            "electric_bike_surcharge_waiver": false,
            "has_kiosk": false,
            "region_code": "PDX",
            "station_id": "1459024287353491654",
            "client_station_id": "motivate_PDX_1459024287353491654"
          },
          {
            "name": "N Russell at Interstate",
            "lon": -122.6769716,
            "rack_model": "CITY_PUBLIC_RACK",
            "legacy_id": "1440913816920179552",
            "address": "Widmer Brothers Brewing, 955, North Russell Street, Albina, Eliot, Portland, Multnomah County, Oregon, 97227, United States of America",
            "capacity": 12,
            "rental_uris": {
              "ios": "https://pdx.lft.to/lastmile_qr_scan",
              "android": "https://pdx.lft.to/lastmile_qr_scan"
            },
            "lat": 45.54107815,
            "external_id": "motivate_PDX_1440913816920179552",
            "eightd_has_key_dispenser": false,
            "dockless_bikes_parking_zone_capacity": 12,
            "eightd_station_services": [],
            "station_type": "lightweight",
            "electric_bike_surcharge_waiver": false,
            "has_kiosk": false,
            "region_code": "PDX",
            "station_id": "1440913816920179552",
            "client_station_id": "motivate_PDX_1440913816920179552"
          },
          {
            "name": "N Failing at Williams",
            "lon": -122.6668663,
            "rack_model": "CITY_PILOT_RACK",
            "legacy_id": "1440913795445343038",
            "address": "North Failing at Williams, North Failing Street, Mississippi, Boise, Portland, Multnomah County, Oregon, 97227, United States of America",
            "capacity": 12,
            "rental_uris": {
              "ios": "https://pdx.lft.to/lastmile_qr_scan",
              "android": "https://pdx.lft.to/lastmile_qr_scan"
            },
            "lat": 45.55076344,
            "external_id": "motivate_PDX_1440913795445343038",
            "eightd_has_key_dispenser": false,
            "dockless_bikes_parking_zone_capacity": 12,
            "eightd_station_services": [],
            "station_type": "lightweight",
            "electric_bike_surcharge_waiver": false,
            "has_kiosk": false,
            "region_code": "PDX",
            "station_id": "1440913795445343038",
            "client_station_id": "motivate_PDX_1440913795445343038"
          }
        ]
      }
    }'
  }

  describe 'validations' do
    subject { described_class.new }

    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
    it { should validate_presence_of(:capacity) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:station_uuid) }
    it { should validate_presence_of(:brand) }
  end

  describe '.for' do
    subject { described_class }

    let(:brand) { Brand.find_by(name: 'Biketown') }

    it 'can initialize from a JSON payload' do
      result = subject.for(sample_payload, brand)
      expect(result.first).to be_a described_class
    end

    it 'can initialize from a hash payload' do
      result = subject.for_hash(JSON.parse(sample_payload).with_indifferent_access, brand)
      expect(result.first).to be_a described_class
    end

    it 'persists bikes in the database' do
      subject.for(sample_payload, brand)
      expect(ShareStation.find_by(station_uuid: "1459024287353491654")).to_not be nil
    end

    it 'initializes to a default brand' do
      result = subject.for(sample_payload)
      expect(result.first.brand.name).to eq('Biketown')
    end

    it 'sets the bike longitude' do
      result = subject.for(sample_payload, brand)
      expect(result.first.lon).to eq("-122.5933109")
    end

    it 'sets the bike lattitude' do
      result = subject.for(sample_payload, brand)
      expect(result.first.lat).to eq("45.5464321")
    end

    it 'sets the bike UUID' do
      result = subject.for(sample_payload, brand)
      expect(result.first.station_uuid).to eq("1459024287353491654")
    end


    context 'when the bike already exists' do
      it 'does not create a new record' do
        subject.for(sample_payload, brand)
        subject.for(sample_payload, brand)

        expect(ShareStation.count).to eq(3)
      end
    end
  end
end
