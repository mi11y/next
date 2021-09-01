require 'rails_helper'

describe Conductors::Biketown::StationStatus do
  subject { Conductors::Biketown::StationStatus.new }

  describe '#run' do
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
    let(:payload_hash) { JSON.parse(sample_payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Biketown::StationStatus,
                                        get_data: payload_hash
    ) }

    let(:brand) { instance_double(Brand, name: 'Excel' )}

    before do
      allow(WebServices::Biketown::StationStatus).to receive(:new).
        and_return(web_service)
      allow(Brand).to receive(:find_by).
        and_return(brand)
      allow(ShareStationStatus).to receive(:for_hash).
        with(payload_hash, brand)
    end


    it 'calls the web service for data' do
      expect(web_service).to receive(:get_data)
      subject.run
    end

    it 'creates models for the data' do
      expect(ShareStationStatus).to receive(:for_hash).with(payload_hash, brand)
      subject.run
    end
  end

  it 'assigns itself a name' do
    expect(subject.name).to eq('Biketown')
  end
end