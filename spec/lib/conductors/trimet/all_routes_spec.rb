require 'rails_helper'


RSpec.describe Conductors::Trimet::AllRoutes do
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
  let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
  let(:web_service) { instance_double(WebServices::Trimet::Routes,
                                      get_data: payload_hash
  ) }

  let(:brand) { instance_double(Brand, name: 'WART') }

  before do
    allow(WebServices::Trimet::Routes).to receive(:new).
      and_return(web_service)
    allow(Brand).to receive(:find_by).
      and_return(brand)
    allow(Route).to receive(:for_hash).
      with(payload_hash, brand).and_return([
                                             instance_double(Route),
                                             instance_double(Route),
                                             instance_double(Route)
                                           ])
  end

  it 'calls the web service for data' do
    expect(web_service).to receive(:get_data)
    subject.run
  end

  it 'creates models for the data' do
    expect(Route).to receive(:for_hash).with(payload_hash, brand)
    subject.run
  end

  it 'returns a count of records created or update' do
    expect(subject.run.create_or_update_count).to eq(3)
  end
end