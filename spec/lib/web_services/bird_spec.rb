require 'rails_helper'

RSpec.describe WebServices::Bird do
    subject { described_class.new }

    let(:payload) {
        '{
            "last_updated": 1627195678,
            "ttl": 30,
            "data": {
                "bikes": [
                    {
                        "bike_id": "77ba1a36-5f87-4654-95b6-ae40775d73ff",
                        "lat": 45.55912,
                        "lon": -122.63693,
                        "vehicle_type": "scooter",
                        "is_reserved": 0,
                        "is_disabled": 0
                    },
                    {
                        "bike_id": "b7d5bafa-0670-4d37-adf1-8c9e7dff7630",
                        "lat": 45.4742,
                        "lon": -122.63973,
                        "vehicle_type": "scooter",
                        "is_reserved": 0,
                        "is_disabled": 0
                    },
                    {
                        "bike_id": "13e89a9c-51f1-4e3c-982e-32dc2f3f1c4b",
                        "lat": 45.52284,
                        "lon": -122.65841,
                        "vehicle_type": "scooter",
                        "is_reserved": 0,
                        "is_disabled": 0
                    }
                ]
            }
        }'
    }

    describe '#get_data' do
        let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
        let(:status) { 200 }
        before do
            stub_request(:get, /mds.bird.co/).to_return(
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