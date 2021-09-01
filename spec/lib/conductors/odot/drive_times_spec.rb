require 'rails_helper'

RSpec.describe Conductors::Odot::DriveTimes do
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
  let(:payload_hash) { JSON.parse(payload).with_indifferent_access }
  let(:web_service) { instance_double(WebServices::Odot::DriveTimes,
                                     get_data: payload_hash)}

  let(:drive_time_origin_1) { instance_double(DriveTimeOrigin) }
  let(:drive_time_origin_2) { instance_double(DriveTimeOrigin) }
  let(:drive_time_destination_1) { instance_double(DriveTimeDestination) }
  let(:drive_time_destination_2) { instance_double(DriveTimeDestination) }
  let(:drive_time_destination_3) { instance_double(DriveTimeDestination) }

  before do
    allow(WebServices::Odot::DriveTimes).to receive(:new).
      and_return(web_service)
    allow(DriveTimeOrigin).to receive(:for).with(payload_hash).
      and_return([drive_time_origin_1, drive_time_origin_2])
    allow(DriveTimeDestination).to receive(:for).with(payload_hash).
      and_return([drive_time_destination_1, drive_time_destination_2, drive_time_destination_3])
  end

  it 'calls the web service for data' do
    expect(web_service).to receive(:get_data)
    subject.run
  end

  it 'creates drive time origins for the data' do
    expect(DriveTimeOrigin).to receive(:for).with(payload_hash)
    subject.run
  end

  it 'creates drive time destinations for the data' do
    expect(DriveTimeDestination).to receive(:for).with(payload_hash)
    subject.run
  end

  it 'returns a count of records created or update' do
    expect(subject.run.create_or_update_count).to eq(5)
  end
end