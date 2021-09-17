require 'rails_helper'

RSpec.describe DriveTimeDestination, type: :model do
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

    it { should validate_presence_of(:destination_id) }
    it { should validate_presence_of(:route_destination) }
    it { should validate_presence_of(:min_route_time) }
    it { should validate_presence_of(:travel_time) }
    it { should validate_presence_of(:delay) }
  end

  let(:sample_payload) { JSON.parse(payload).with_indifferent_access }

  describe '.for' do

    before do
      DriveTimeOrigin.create!(
        origin_id: 2,
        location_name: "Destination 1",
        lat: 45.476230,
        lon: -122.789040,
      )
      DriveTimeOrigin.create!(
        origin_id: 3,
        location_name: "Destination 2",
        lat: 45.548290,
        lon: -122.884730,
      )
    end

    subject { described_class }

    it 'can initialize from a hash payload' do
      result = subject.for(sample_payload)
      expect(result.first).to be_a described_class
    end

    it 'persists destinations in the database' do
      subject.for(sample_payload)
      expect(DriveTimeDestination.find_by(destination_id: 116)).to_not be nil
    end

    it 'sets the route destination text' do
      result = subject.for(sample_payload)
      expect(result.first.route_destination).to eq("NW 185th/[US26|sign-us26.png] WB")
    end

    it 'sets the minimum route time' do
      result = subject.for(sample_payload)
      expect(result.first.min_route_time).to eq(10)
    end

    it 'sets the travel time' do
      result = subject.for(sample_payload)
      expect(result.first.travel_time).to eq(10)
    end

    it 'sets the delay time' do
      result = subject.for(sample_payload)
      expect(result.first.delay).to eq(0)
    end

    it 'associates to the existing Drive Time Origin' do
      result = subject.for(sample_payload)
      expect(result.first.drive_time_origin.location_name).
        to eq("Destination 1")
    end

    context 'when the drive time already exists' do
      it 'does not create a new record' do
        subject.for(sample_payload)
        subject.for(sample_payload)

        expect(DriveTimeDestination.count).to eq(3)
      end
    end
  end
end
