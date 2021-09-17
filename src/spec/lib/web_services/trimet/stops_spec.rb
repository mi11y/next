require 'rails_helper'

RSpec.describe WebServices::Trimet::Stops do
    subject { described_class.new }

    let(:payload) {
        '{
            "resultSet": {
                "queryTime": "2021-07-27T21:53:24.829-0700",
                "location": [
                    {
                        "lng": -122.679474777158,
                        "metersDistance": 40,
                        "feetDistance": 134,
                        "dir": "Westbound",
                        "lat": 45.5192530913679,
                        "locid": 8383,
                        "desc": "Pioneer Square North MAX Station"
                    },
                    {
                        "lng": -122.678974579691,
                        "metersDistance": 82,
                        "feetDistance": 271,
                        "dir": "Northbound",
                        "lat": 45.5181992809523,
                        "locid": 7807,
                        "desc": "SW 6th & Yamhill"
                    }
                ]
            }
        }'
    }

    describe '#get_data' do
        let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
        let(:status) { 200 }
        before do
            stub_request(:get, /developer.trimet.org/).to_return(
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