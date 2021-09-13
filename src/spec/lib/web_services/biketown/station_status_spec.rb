require 'rails_helper'

RSpec.describe WebServices::Biketown::StationStatus do
  subject { described_class.new }

  let(:sample_payload) {
    '{
      "data": {
        "stations": [
          {
            "is_returning": 1,
            "station_id": "1459024287353491654",
            "is_renting": 1,
            "num_bikes_available": 2,
            "eightd_has_available_keys": false,
            "station_status": "active",
            "is_installed": 1,
            "num_ebikes_available": 2,
            "num_docks_available": 7,
            "legacy_id": "1459024287353491654",
            "num_docks_disabled": 0,
            "last_reported": 1602863916,
            "num_bikes_disabled": 1
          },
          {
            "is_returning": 1,
            "station_id": "1440913816920179552",
            "is_renting": 1,
            "num_bikes_available": 1,
            "eightd_has_available_keys": false,
            "station_status": "active",
            "is_installed": 1,
            "num_ebikes_available": 1,
            "num_docks_available": 11,
            "legacy_id": "1440913816920179552",
            "num_docks_disabled": 0,
            "last_reported": 1599612006,
            "num_bikes_disabled": 0
          },
          {
            "is_returning": 1,
            "station_id": "1440913795445343038",
            "is_renting": 1,
            "num_bikes_available": 2,
            "eightd_has_available_keys": false,
            "station_status": "active",
            "is_installed": 1,
            "num_ebikes_available": 2,
            "num_docks_available": 9,
            "legacy_id": "1440913795445343038",
            "num_docks_disabled": 0,
            "last_reported": 1599610238,
            "num_bikes_disabled": 1
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