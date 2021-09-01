require 'rails_helper'

RSpec.describe Conductors::Biketown::Bikes do
  subject { Conductors::Biketown::Bikes.new }
  describe '#run' do
    let(:payload) {
      '{
                "data": {
                    "bikes": [
                        {
                            "type": "electric_bike",
                            "name": "301ebee173d2fb9944e2662d9282578a",
                            "lat": 45.49747416666666,
                            "is_reserved": 0,
                            "rental_uris": {
                                "ios": "https://pdx.lft.to/lastmile_qr_scan",
                                "android": "https://pdx.lft.to/lastmile_qr_scan"
                            },
                            "lon": -122.65680566666667,
                            "is_disabled": 0,
                            "bike_id": "301ebee173d2fb9944e2662d9282578a"
                        },
                        {
                            "type": "electric_bike",
                            "name": "ee69e1aa1af981ffcbed69a2a426f5b8",
                            "lat": 45.483429666666666,
                            "is_reserved": 0,
                            "rental_uris": {
                                "ios": "https://pdx.lft.to/lastmile_qr_scan",
                                "android": "https://pdx.lft.to/lastmile_qr_scan"
                            },
                            "lon": -122.577715,
                            "is_disabled": 0,
                            "bike_id": "ee69e1aa1af981ffcbed69a2a426f5b8"
                        },
                        {
                            "type": "electric_bike",
                            "name": "542353426f8f0567643682125b48ef62",
                            "lat": 45.522752,
                            "is_reserved": 0,
                            "rental_uris": {
                                "ios": "https://pdx.lft.to/lastmile_qr_scan",
                                "android": "https://pdx.lft.to/lastmile_qr_scan"
                            },
                            "lon": -122.64749216666667,
                            "is_disabled": 0,
                            "bike_id": "542353426f8f0567643682125b48ef62"
                        }
                    ]
                }
            }'
    }
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Biketown::Bikes,
                                        get_data: payload_hash
    ) }

    let(:brand) { instance_double(Brand, name: 'Piggie') }

    before do
      allow(WebServices::Biketown::Bikes).to receive(:new).
        and_return(web_service)
      allow(Brand).to receive(:find_by).
        and_return(brand)
      allow(Share).to receive(:for_hash).
        with(payload_hash, brand).and_return([
                                               instance_double(Share),
                                               instance_double(Share),
                                               instance_double(Share)
                                             ])
    end

    it 'calls the web service for data' do
      expect(web_service).to receive(:get_data)
      subject.run
    end

    it 'creates models for the data' do
      expect(Share).to receive(:for_hash).with(payload_hash, brand)
      subject.run
    end

    it 'returns a count of records created or update' do
      expect(subject.run.create_or_update_count).to eq(3)
    end
  end

  it 'assigns itself a name' do
    expect(subject.name).to eq('Biketown')
  end
end