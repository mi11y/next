require 'rails_helper'

RSpec.describe WebServices::Biketown::Bikes do
    subject { described_class.new }

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

    describe '#get_data' do
        let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
        let(:status) { 200 }
        before do
            stub_request(:get, /gbfs.biketownpdx.com/).to_return(
                body: payload,
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