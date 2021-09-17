require 'rails_helper'

RSpec.describe Conductors::Trimet::ArrivalTimes do
  subject { Conductors::Trimet::ArrivalTimes.new([8383]) }
  describe '#run' do
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
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Trimet::Arrivals,
                                        get_data: payload_hash
    ) }

    before do
      allow(WebServices::Trimet::Arrivals).to receive(:new).
        and_return(web_service)
    end

    it 'calls the web service for data' do
      expect(web_service).to receive(:get_data)
      subject.run
    end

    it 'returns the result set' do
      expect(subject.run.results).to eq({
                                  :arrival => payload_hash[:resultSet][:arrival],
                                  :location => payload_hash[:resultSet][:location]
                                })
    end

    context 'when no stop IDs are given' do
      subject { Conductors::Trimet::ArrivalTimes.new() }

      before do
        expect(web_service).to_not receive(:get_data)
      end

      it 'does not make a web call' do
        subject.run
      end

      it 'returns an empty hash' do
        expect(subject.run.results).to eq({})
      end
    end
  end

  it 'assigns itself a name' do
    expect(subject.name).to eq('Trimet')
  end
end