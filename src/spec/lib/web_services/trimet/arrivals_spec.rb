require 'rails_helper'

RSpec.describe WebServices::Trimet::Arrivals do
    subject { described_class.new([8383])}

    let(:payload) {
        '{
            "resultSet": {
                "queryTime": "2021-07-27T21:53:24.829-0700",
                "arrival": [
                    {
                        "feet": 0,
                        "inCongestion": null,
                        "departed": true,
                        "scheduled": 1627840695000,
                        "loadPercentage": null,
                        "shortSign": "Blue to Hillsboro",
                        "estimated": 1627840729000,
                        "detoured": true,
                        "tripID": "10943415",
                        "dir": 1,
                        "blockID": 9008,
                        "detour": [
                            107352,
                            107844
                        ],
                        "route": 100,
                        "piece": "1",
                        "fullSign": "MAX  Blue Line to Hillsboro",
                        "id": "10943415_39495_1",
                        "dropOffOnly": false,
                        "vehicleID": "239",
                        "showMilesAway": false,
                        "locid": 8383,
                        "newTrip": false,
                        "status": "estimated"
                    },
                    {
                        "feet": 5570,
                        "inCongestion": null,
                        "departed": true,
                        "scheduled": 1627841175000,
                        "loadPercentage": null,
                        "shortSign": "Red Line to Beaverton",
                        "estimated": 1627841175000,
                        "detoured": true,
                        "tripID": "10942455",
                        "dir": 1,
                        "blockID": 9041,
                        "detour": [
                            107352
                        ],
                        "route": 90,
                        "piece": "1",
                        "fullSign": "MAX  Red Line to City Center & Beaverton",
                        "id": "10942455_39975_1",
                        "dropOffOnly": false,
                        "vehicleID": "238",
                        "showMilesAway": false,
                        "locid": 8383,
                        "newTrip": false,
                        "status": "estimated"
                    },
                    {
                        "feet": 9839,
                        "inCongestion": null,
                        "departed": true,
                        "scheduled": 1627841595000,
                        "loadPercentage": null,
                        "shortSign": "Blue to Hillsboro",
                        "estimated": 1627841595000,
                        "detoured": true,
                        "tripID": "10943416",
                        "dir": 1,
                        "blockID": 9002,
                        "detour": [
                            107352,
                            107844
                        ],
                        "route": 100,
                        "piece": "1",
                        "fullSign": "MAX  Blue Line to Hillsboro",
                        "id": "10943416_40395_1",
                        "dropOffOnly": false,
                        "vehicleID": "534",
                        "showMilesAway": false,
                        "locid": 8383,
                        "newTrip": false,
                        "status": "estimated"
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