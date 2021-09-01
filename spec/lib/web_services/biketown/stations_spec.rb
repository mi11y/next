require 'rails_helper'

RSpec.describe WebServices::Biketown::Stations do
  subject { described_class.new }

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

  describe '#get_data' do
    let(:payload_hash) { JSON.parse(sample_payload).with_indifferent_access }
    let(:status) { 200 }
    before do
      stub_request(:get, /gbfs.biketownpdx.com/).to_return(
        body: sample_payload,
        status: status
      )
    end

    it 'parses the payload as JSON' do
      expect(subject.get_data).to eq(payload_hash)
    end

    context 'when the server returns 5XX' do
      let(:status) { 500 }

      it 'returns nill' do
        expect(subject.get_data).to eq(nil)
      end
    end
  end
end