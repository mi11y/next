require 'rails_helper'

RSpec.describe Conductors::Bird do
  subject { Conductors::Bird.new }
  describe '#run' do
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
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Bird,
                                        get_data: payload_hash
    ) }

    let(:brand) { instance_double(Brand, name: 'Piggie') }

    before do
      allow(WebServices::Bird).to receive(:new).
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
    expect(subject.name).to eq('Bird')
  end
end