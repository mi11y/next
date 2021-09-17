require 'rails_helper'

RSpec.describe WebServices::Trimet::Routes do

  subject { described_class.new }

  let(:payload) {
    '{
      "resultSet": {
          "route": [
              {
                  "routeColor": "F58220",
                  "frequentService": true,
                  "route": 290,
                  "id": 290,
                  "type": "R",
                  "desc": "MAX Orange Line",
                  "routeSortOrder": 115
              },
              {
                  "routeColor": null,
                  "frequentService": true,
                  "route": 12,
                  "detour": true,
                  "id": 12,
                  "type": "B",
                  "desc": "12-Barbur/Sandy Blvd",
                  "routeSortOrder": 1500
              },
              {
                  "routeColor": null,
                  "frequentService": false,
                  "route": 93,
                  "id": 93,
                  "type": "B",
                  "desc": "93-Tigard/Sherwood",
                  "routeSortOrder": 9000
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