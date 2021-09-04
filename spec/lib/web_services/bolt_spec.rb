require 'rails_helper'

RSpec.describe WebServices::Bolt do
  subject { described_class.new }

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

  describe '#get_data' do
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access}
    let(:status) { 200 }
    before do
      stub_request(:get, /api-lb.micromobility.com/).to_return(
        body: payload,
        status: status
      )
    end

    it 'parses the payload as json' do
      expect(subject.get_data).to eq(payload_hash)
    end

    context 'when the server returns 5XX' do
      let(:status) { 500 }

      it 'returns nil' do
        expect(subject.get_data).to eq(nil)
      end
    end
  end
end