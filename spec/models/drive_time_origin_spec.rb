require 'rails_helper'

RSpec.describe DriveTimeOrigin, type: :model do
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

  describe 'validations' do
    subject { described_class.new }

    it { should validate_presence_of(:origin_id) }
    it { should validate_presence_of(:location_name) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lon) }
  end

  let(:sample_payload) { JSON.parse(payload).with_indifferent_access }

  describe '.for' do
    subject { described_class }

    it 'can initialize from a hash payload' do
      result = subject.for(sample_payload)
      expect(result.first).to be_a described_class
    end

    it 'persists drive times in the database' do
      subject.for(sample_payload)
      expect(DriveTimeOrigin.find_by(origin_id: 2)).to_not be nil
    end

    it 'sets the drive time longitude' do
      result = subject.for(sample_payload)
      expect(result.first.lon).to eq("-122.78904")
    end

    it 'sets the drive time lattitude' do
      result = subject.for(sample_payload)
      expect(result.first.lat).to eq("45.47623")
    end

    it 'sets the drive time origin' do
      result = subject.for(sample_payload)
      expect(result.first.origin_id).to eq(2)
    end

    context 'when the drive time already exists' do
      it 'does not create a new record' do
        subject.for(sample_payload)
        subject.for(sample_payload)

        expect(DriveTimeOrigin.count).to eq(2)
      end
    end
  end
end
