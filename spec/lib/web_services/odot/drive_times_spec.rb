require 'rails_helper'

RSpec.describe WebServices::Odot::DriveTimes do
  subject { described_class.new }

  let(:payload) {
    '{
      "fields": [
        {
          "name": "id",
          "alias": "routeOriginId",
          "type": "esriFieldTypeOID"
        },
        {
          "name": "locationName",
          "alias": "Location Name",
          "type": "esriFieldTypeString",
          "length": 200
        },
        {
          "name": "iconType",
          "alias": "Icon Type",
          "type": "esriFieldTypeInteger"
        },
        {
          "name": "latitude",
          "alias": "Latitude",
          "type": "esriFieldTypeDouble"
        },
        {
          "name": "longitude",
          "alias": "Longitude",
          "type": "esriFieldTypeDouble"
        },
        {
          "name": "routes",
          "alias": "Route Calculations",
          "type": "esriFieldTypeString",
          "length": 50
        }
      ],
      "geometryType": "esriGeometryPoint",
      "spatialReference": {
        "wkid": 3857
      },
      "features": [
        {
          "attributes": {
            "origId": 2,
            "locationName": "[ORE217|sign-ore217.png] NB; Allen Blvd",
            "iconType": 25,
            "latitude": 45.476230,
            "longitude": -122.789040,
            "routes": [
              {
                "id": 116,
                "routeDest": "NW 185th/[US26|sign-us26.png] WB",
                "minRouteTime": 10,
                "dt": "2021-08-25T08:34:55.137-07:00",
                "travelTime": 10,
                "delay": 0,
                "failureMsg": "",
                "useAltMsg": false
              }
            ]
          },
          "geometry": {
            "x": -13668813.405892185,
            "y": 5696808.340088332
          }
        },
        {
          "attributes": {
            "origId": 3,
            "locationName": "[US26|sign-us26.png] EB; NW 185th Ave",
            "iconType": 25,
            "latitude": 45.548290,
            "longitude": -122.884730,
            "routes": [
              {
                "id": 145,
                "routeDest": "[I-405|sign-i-405.png]",
                "minRouteTime": 14,
                "dt": "2021-08-25T08:34:55.153-07:00",
                "travelTime": 15,
                "delay": 1,
                "failureMsg": "",
                "useAltMsg": false
              },
              {
                "id": 146,
                "routeDest": "[ORE217|sign-ore217.png]",
                "minRouteTime": 7,
                "dt": "2021-08-25T08:34:55.153-07:00",
                "travelTime": 7,
                "delay": 0,
                "failureMsg": "",
                "useAltMsg": false
              }
            ]
          },
          "geometry": {
            "x": -13679465.567964712,
            "y": 5708255.515613045
          }
        }
      ]
    }'
  }

  describe '#get_data' do
    let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
    let(:status) { 200 }
    before do
      stub_request(:get, /tripcheck.com/).to_return(
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