require 'rails_helper'

RSpec.describe Conductors::Bolt do
  subject { Conductors::Bolt.new }

  describe '#run' do
    let(:payload) {
      '{
      "last_updated": 1630794748,
      "ttl": 60,
      "data": {
        "bikes": [
          {
            "bike_id": "d62b2a1b23",
            "lat": 45.525067,
            "lon": -122.671702,
            "is_reserved": 0,
            "is_disabled": 0
          },
          {
            "bike_id": "e1983b5300",
            "lat": 45.52237,
            "lon": -122.536895,
            "is_reserved": 0,
            "is_disabled": 0
          },
          {
            "bike_id": "0f414dd626",
            "lat": 45.524368,
            "lon": -122.650038,
            "is_reserved": 0,
            "is_disabled": 0
          }
        ]
      }
    }'
    }
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:web_service) { instance_double(WebServices::Bolt,
                                        get_data: payload_hash
    ) }

    let(:brand) { instance_double(Brand, name: 'Lightning') }

    before do
      allow(WebServices::Bolt).to receive(:new).
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
    expect(subject.name).to eq('Bolt')
  end
end