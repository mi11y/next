require 'rails_helper'

RSpec.describe Conductors::Trimet::StopLocation do
  subject { Conductors::Trimet::StopLocation.new }
  describe '#run' do
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
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Trimet::Stops,
                                        get_data: payload_hash
    ) }

    before do
      allow(WebServices::Trimet::Stops).to receive(:new).
        and_return(web_service)
    end

    it 'calls the web service for data' do
      expect(web_service).to receive(:get_data)
      subject.run
    end

    it 'returns the result set' do
      expect(subject.run.results).to eq(payload_hash[:resultSet][:location])
    end

    context 'when no stops are nearby' do
      let(:payload) {
        '{
            "resultSet": {
                "queryTime": "2021-08-19T19:09:18.026-0700"
            }
        }'
      }

      it 'returns an empty list' do
        expect(subject.run.results).to eq([])
      end
    end
  end

  it 'assigns itself a name' do
    expect(subject.name).to eq('Trimet')
  end
end