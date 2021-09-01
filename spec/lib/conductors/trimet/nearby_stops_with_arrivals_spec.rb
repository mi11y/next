require 'rails_helper'

RSpec.describe Conductors::Trimet::NearbyStopsWithArrivals do
  subject { Conductors::Trimet::NearbyStopsWithArrivals.new }

  let(:stop_location_payload) {
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
  let(:stop_location_hash) { JSON.parse(stop_location_payload).with_indifferent_access }
  let(:stop_location_conductor) { instance_double(
    Conductors::Trimet::StopLocation, results: stop_location_hash[:resultSet][:location]
  ) }

  let(:arrival_times_payload) {
    '{
        "resultSet": {
            "queryTime": "2021-07-27T21:53:24.829-0700",
            "detour": [
                {
                    "info_link_url": "http://trimet.org/heat",
                    "end": null,
                    "system_wide_flag": true,
                    "id": 108712,
                    "header_text": "Excessive Heat Warning",
                    "system_wide_message": {
                        "type": "priority"
                    },
                    "begin": 1628621579716,
                    "desc": "Detour Message"
                }
            ],
            "arrival": [
              {
                  "feet": 617,
                  "inCongestion": false,
                  "departed": true,
                  "scheduled": 1628995980000,
                  "loadPercentage": null,
                  "shortSign": "12 Parkrose TC",
                  "estimated": 1628996061000,
                  "detoured": true,
                  "tripID": "10933729",
                  "dir": 1,
                  "blockID": 1271,
                  "detour": [
                      103625,
                      108913,
                      102457
                  ],
                  "route": 12,
                  "piece": "1",
                  "fullSign": "12  Sandy Blvd to Parkrose TC",
                  "id": "10933729_71580_14",
                  "dropOffOnly": false,
                  "vehicleID": "3236",
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 5882,
                  "inCongestion": null,
                  "departed": true,
                  "scheduled": 1628996295000,
                  "loadPercentage": null,
                  "shortSign": "Blue to Hillsboro",
                  "estimated": 1628996364000,
                  "detoured": true,
                  "tripID": "10943352",
                  "dir": 1,
                  "blockID": 9023,
                  "detour": [
                      107848
                  ],
                  "route": 100,
                  "piece": "1",
                  "fullSign": "MAX  Blue Line to Hillsboro",
                  "id": "10943352_71895_14",
                  "dropOffOnly": false,
                  "vehicleID": "309",
                  "showMilesAway": false,
                  "locid": 8383,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 10401,
                  "inCongestion": null,
                  "departed": true,
                  "scheduled": 1628996770000,
                  "loadPercentage": null,
                  "shortSign": "Red Line to Beaverton",
                  "estimated": 1628996770000,
                  "detoured": false,
                  "tripID": "10942426",
                  "dir": 1,
                  "blockID": 9044,
                  "route": 90,
                  "piece": "1",
                  "fullSign": "MAX  Red Line to City Center & Beaverton",
                  "id": "10942426_72370_14",
                  "dropOffOnly": false,
                  "vehicleID": "205",
                  "showMilesAway": false,
                  "locid": 8383,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 32271,
                  "inCongestion": null,
                  "departed": true,
                  "scheduled": 1628997175000,
                  "loadPercentage": null,
                  "shortSign": "Blue to Hillsboro",
                  "estimated": 1628997175000,
                  "detoured": true,
                  "tripID": "10943353",
                  "dir": 1,
                  "blockID": 9003,
                  "detour": [
                      107848
                  ],
                  "route": 100,
                  "piece": "1",
                  "fullSign": "MAX  Blue Line to Hillsboro",
                  "id": "10943353_72775_14",
                  "dropOffOnly": false,
                  "vehicleID": "109",
                  "showMilesAway": false,
                  "locid": 8383,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 66260,
                  "inCongestion": null,
                  "departed": false,
                  "scheduled": 1628998570000,
                  "loadPercentage": null,
                  "shortSign": "Red Line to Beaverton",
                  "estimated": 1628998570000,
                  "detoured": false,
                  "tripID": "10942428",
                  "dir": 1,
                  "blockID": 9040,
                  "route": 90,
                  "piece": "1",
                  "fullSign": "MAX  Red Line to City Center & Beaverton",
                  "id": "10942428_74170_14",
                  "dropOffOnly": false,
                  "vehicleID": "252",
                  "showMilesAway": false,
                  "locid": 8383,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 47919,
                  "inCongestion": false,
                  "departed": false,
                  "scheduled": 1628998680000,
                  "loadPercentage": null,
                  "shortSign": "12 Parkrose TC",
                  "estimated": 1628998680000,
                  "detoured": true,
                  "tripID": "10933730",
                  "dir": 1,
                  "blockID": 1241,
                  "detour": [
                      103625,
                      108913,
                      102457
                  ],
                  "route": 12,
                  "piece": "1",
                  "fullSign": "12  Sandy Blvd to Parkrose TC",
                  "id": "10933730_74280_14",
                  "dropOffOnly": false,
                  "vehicleID": "3716",
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": 64500,
                  "inCongestion": false,
                  "departed": false,
                  "scheduled": 1628998800000,
                  "loadPercentage": null,
                  "shortSign": "19 Gateway TC",
                  "estimated": 1628998800000,
                  "detoured": false,
                  "tripID": "10935101",
                  "dir": 1,
                  "blockID": 1902,
                  "route": 19,
                  "piece": "1",
                  "fullSign": "19  Glisan to Gateway TC",
                  "id": "10935101_74400_14",
                  "dropOffOnly": false,
                  "vehicleID": "3540",
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "estimated"
              },
              {
                  "feet": null,
                  "departed": false,
                  "scheduled": 1629041640000,
                  "shortSign": "19 Gateway TC",
                  "detoured": false,
                  "tripID": "10935102",
                  "dir": 1,
                  "blockID": 1903,
                  "route": 19,
                  "piece": "1",
                  "fullSign": "19  Glisan to Gateway TC",
                  "id": "10935102_30840_15",
                  "dropOffOnly": false,
                  "vehicleID": null,
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "scheduled"
              },
              {
                  "feet": null,
                  "departed": false,
                  "scheduled": 1629120720000,
                  "shortSign": "94 Downtown Only",
                  "detoured": false,
                  "tripID": "10961662",
                  "dir": 1,
                  "blockID": 9467,
                  "route": 94,
                  "piece": "1",
                  "fullSign": "94  Downtown Only",
                  "id": "10961662_23520_16",
                  "dropOffOnly": false,
                  "vehicleID": null,
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "scheduled"
              },
              {
                  "feet": null,
                  "departed": false,
                  "scheduled": 1629121280000,
                  "shortSign": "1 Downtown Only",
                  "detoured": true,
                  "tripID": "10950356",
                  "dir": 1,
                  "blockID": 169,
                  "detour": [
                      103625
                  ],
                  "route": 1,
                  "piece": "1",
                  "fullSign": "1  Downtown Only",
                  "id": "10950356_24080_16",
                  "dropOffOnly": false,
                  "vehicleID": null,
                  "showMilesAway": false,
                  "locid": 7807,
                  "newTrip": false,
                  "status": "scheduled"
              }
          ],
          "queryTime": 1628996022315,
          "location": [
              {
                  "lng": -122.679474777158,
                  "passengerCode": "E",
                  "id": 8383,
                  "dir": "Westbound",
                  "lat": 45.5192530913679,
                  "desc": "Pioneer Square North MAX Station"
              },
              {
                  "lng": -122.678974579691,
                  "passengerCode": "E",
                  "id": 7807,
                  "dir": "Northbound",
                  "lat": 45.5181992809523,
                  "desc": "SW 6th & Yamhill"
              }
          ]
        }
    }'
  }
  let(:arrivals_hash) { JSON.parse(arrival_times_payload).with_indifferent_access }
  let(:results_hash) {
    {
      detour: arrivals_hash[:resultSet][:detour],
      arrival: arrivals_hash[:resultSet][:arrival],
      location: arrivals_hash[:resultSet][:location]
    }
  }
  let(:arrival_times_conductor) { instance_double(
    Conductors::Trimet::ArrivalTimes, results: results_hash
  ) }

  let(:route_feature_finder_double) { instance_double(Conductors::Trimet::RouteFeatureFinder, response:
    {
      100 =>
        { :route_number => 100,
          :route_id => 100,
          :route_type => "R",
          :desc => "MAX Blue Line",
          :route_sort_order => 100,
          :frequent_service => true,
          :route_color => "#084C8D",
          :brand => { :name => "Trimet" } },
      90 =>
        { :route_number => 90,
          :route_id => 90,
          :route_type => "R",
          :desc => "MAX Red Line",
          :route_sort_order => 120,
          :frequent_service => true,
          :route_color => "#D81526",
          :brand => { :name => "Trimet" } },
      1 =>
        { :route_number => 1,
          :route_id => 1,
          :route_type => "B",
          :desc => "1-Vermont",
          :route_sort_order => 400,
          :frequent_service => false,
          :route_color => "",
          :brand => { :name => "Trimet" } },
      12 =>
        { :route_number => 12,
          :route_id => 12,
          :route_type => "B",
          :desc => "12-Barbur/Sandy Blvd",
          :route_sort_order => 1500,
          :frequent_service => true,
          :route_color => "",
          :brand => { :name => "Trimet" } },
      19 =>
        { :route_number => 19,
          :route_id => 19,
          :route_type => "B",
          :desc => "19-Woodstock/Glisan",
          :route_sort_order => 2400,
          :frequent_service => false,
          :route_color => "",
          :brand => { :name => "Trimet" } },
      94 =>
        { :route_number => 94,
          :route_id => 94,
          :route_type => "B",
          :desc => "94-Pacific Hwy/Sherwood",
          :route_sort_order => 9100,
          :frequent_service => false,
          :route_color => "",
          :brand => { :name => "Trimet" } }
    }
  )}

  before do
    allow(Conductors::Trimet::StopLocation).to receive(:new).and_return(stop_location_conductor)
    allow(stop_location_conductor).to receive(:run).and_return(stop_location_conductor)
    allow(Conductors::Trimet::ArrivalTimes).to receive(:new).and_return(arrival_times_conductor)
    allow(arrival_times_conductor).to receive(:run).and_return(arrival_times_conductor)
    allow(Conductors::Trimet::RouteFeatureFinder).to receive(:new).and_return(route_feature_finder_double)
    allow(route_feature_finder_double).to receive(:run).and_return(route_feature_finder_double)
  end

  describe '#run' do
    it 'calls the stop location conductor' do
      expect(stop_location_conductor).to receive(:run)
      subject.run
    end

    it 'calls the arrival times conductor' do
      expect(arrival_times_conductor).to receive(:run)
      subject.run
    end

    it 'returns itself' do
      expect(subject.run).to eq(subject)
    end

    context 'when no stops are nearby' do
      let(:stop_location_conductor) { instance_double(
        Conductors::Trimet::StopLocation, results: []
      ) }

      it 'can run without an exception' do
        expect(subject.run).to eq(subject)
      end
    end
  end

  describe '#response' do
    let(:expected_response_hash) {
      {8383=>
         {:dir=>"Westbound",
          :desc=>"Pioneer Square North MAX Station",
          :arrivals=>
            [{:route=>100,
              :daparted=>true,
              :scheduled=>"2021-08-14T19:58:15-07:00",
              :est_arrival=>"2021-08-14T19:59:24-07:00",
              :full_sign=>"MAX  Blue Line to Hillsboro",
              :short_sign=>"Blue to Hillsboro",
              :route_info=>
                {:route_number=>100,
                 :route_id=>100,
                 :route_type=>"R",
                 :desc=>"MAX Blue Line",
                 :route_sort_order=>100,
                 :frequent_service=>true,
                 :route_color=>"#084C8D",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>90,
              :daparted=>true,
              :scheduled=>"2021-08-14T20:06:10-07:00",
              :est_arrival=>"2021-08-14T20:06:10-07:00",
              :full_sign=>"MAX  Red Line to City Center & Beaverton",
              :short_sign=>"Red Line to Beaverton",
              :route_info=>
                {:route_number=>90,
                 :route_id=>90,
                 :route_type=>"R",
                 :desc=>"MAX Red Line",
                 :route_sort_order=>120,
                 :frequent_service=>true,
                 :route_color=>"#D81526",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>100,
              :daparted=>true,
              :scheduled=>"2021-08-14T20:12:55-07:00",
              :est_arrival=>"2021-08-14T20:12:55-07:00",
              :full_sign=>"MAX  Blue Line to Hillsboro",
              :short_sign=>"Blue to Hillsboro",
              :route_info=>
                {:route_number=>100,
                 :route_id=>100,
                 :route_type=>"R",
                 :desc=>"MAX Blue Line",
                 :route_sort_order=>100,
                 :frequent_service=>true,
                 :route_color=>"#084C8D",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>90,
              :scheduled=>"2021-08-14T20:36:10-07:00",
              :est_arrival=>"2021-08-14T20:36:10-07:00",
              :full_sign=>"MAX  Red Line to City Center & Beaverton",
              :short_sign=>"Red Line to Beaverton",
              :route_info=>
                {:route_number=>90,
                 :route_id=>90,
                 :route_type=>"R",
                 :desc=>"MAX Red Line",
                 :route_sort_order=>120,
                 :frequent_service=>true,
                 :route_color=>"#D81526",
                 :brand=>{:name=>"Trimet"}}}]},
       7807=>
         {:dir=>"Northbound",
          :desc=>"SW 6th & Yamhill",
          :arrivals=>
            [{:route=>12,
              :daparted=>true,
              :scheduled=>"2021-08-14T19:53:00-07:00",
              :est_arrival=>"2021-08-14T19:54:21-07:00",
              :full_sign=>"12  Sandy Blvd to Parkrose TC",
              :short_sign=>"12 Parkrose TC",
              :route_info=>
                {:route_number=>12,
                 :route_id=>12,
                 :route_type=>"B",
                 :desc=>"12-Barbur/Sandy Blvd",
                 :route_sort_order=>1500,
                 :frequent_service=>true,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>12,
              :scheduled=>"2021-08-14T20:38:00-07:00",
              :est_arrival=>"2021-08-14T20:38:00-07:00",
              :full_sign=>"12  Sandy Blvd to Parkrose TC",
              :short_sign=>"12 Parkrose TC",
              :route_info=>
                {:route_number=>12,
                 :route_id=>12,
                 :route_type=>"B",
                 :desc=>"12-Barbur/Sandy Blvd",
                 :route_sort_order=>1500,
                 :frequent_service=>true,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>19,
              :scheduled=>"2021-08-14T20:40:00-07:00",
              :est_arrival=>"2021-08-14T20:40:00-07:00",
              :full_sign=>"19  Glisan to Gateway TC",
              :short_sign=>"19 Gateway TC",
              :route_info=>
                {:route_number=>19,
                 :route_id=>19,
                 :route_type=>"B",
                 :desc=>"19-Woodstock/Glisan",
                 :route_sort_order=>2400,
                 :frequent_service=>false,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>19,
              :scheduled=>"2021-08-15T08:34:00-07:00",
              :full_sign=>"19  Glisan to Gateway TC",
              :short_sign=>"19 Gateway TC",
              :route_info=>
                {:route_number=>19,
                 :route_id=>19,
                 :route_type=>"B",
                 :desc=>"19-Woodstock/Glisan",
                 :route_sort_order=>2400,
                 :frequent_service=>false,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>94,
              :scheduled=>"2021-08-16T06:32:00-07:00",
              :full_sign=>"94  Downtown Only",
              :short_sign=>"94 Downtown Only",
              :route_info=>
                {:route_number=>94,
                 :route_id=>94,
                 :route_type=>"B",
                 :desc=>"94-Pacific Hwy/Sherwood",
                 :route_sort_order=>9100,
                 :frequent_service=>false,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}},
             {:route=>1,
              :scheduled=>"2021-08-16T06:41:20-07:00",
              :full_sign=>"1  Downtown Only",
              :short_sign=>"1 Downtown Only",
              :route_info=>
                {:route_number=>1,
                 :route_id=>1,
                 :route_type=>"B",
                 :desc=>"1-Vermont",
                 :route_sort_order=>400,
                 :frequent_service=>false,
                 :route_color=>"",
                 :brand=>{:name=>"Trimet"}}}]}}
    }
    it 'returns nearby transit stops with arrivals' do
      result = subject.run.response
      pp result
      expect(result).to eq(expected_response_hash)
    end

    context 'for routes that have a short sign' do
      let(:arrival_times_payload) {
        '{
          "resultSet": {
              "detour": [
                  {
                      "route": [
                          {
                              "routeColor": "CE0F69",
                              "frequentService": false,
                              "route": 194,
                              "no_service_flag": false,
                              "id": 194,
                              "type": "R",
                              "desc": "Portland Streetcar - A Loop",
                              "routeSortOrder": 250
                          },
                          {
                              "routeColor": "0093B2",
                              "frequentService": false,
                              "route": 195,
                              "no_service_flag": false,
                              "id": 195,
                              "type": "R",
                              "desc": "Portland Streetcar - B Loop",
                              "routeSortOrder": 275
                          }
                      ],
                      "info_link_url": "https://portlandstreetcar.org/news/2020/03/streetcar-service-will-reduce-to-20-minute-headways-beginning-march-24",
                      "end": null,
                      "system_wide_flag": false,
                      "id": 74434,
                      "header_text": "",
                      "begin": 1585093573281,
                      "desc": "Streetcar has reduced regular weekday service to every 20 minutes between about 5:30 a.m. and about 11:30 p.m. For more info:"
                  },
                  {
                      "info_link_url": "http://trimet.org/health",
                      "end": null,
                      "system_wide_flag": true,
                      "id": 107841,
                      "header_text": "Face masks are required",
                      "system_wide_message": {
                          "type": "normal"
                      },
                      "begin": 1629068400000,
                      "desc": "Face masks are still required on transit. \n"
                  },
                  {
                      "route": [
                          {
                              "routeColor": "CE0F69",
                              "frequentService": false,
                              "route": 194,
                              "no_service_flag": false,
                              "id": 194,
                              "type": "R",
                              "desc": "Portland Streetcar - A Loop",
                              "routeSortOrder": 250
                          },
                          {
                              "routeColor": "0093B2",
                              "frequentService": false,
                              "route": 195,
                              "no_service_flag": false,
                              "id": 195,
                              "type": "R",
                              "desc": "Portland Streetcar - B Loop",
                              "routeSortOrder": 275
                          }
                      ],
                      "info_link_url": null,
                      "end": 1629766800000,
                      "system_wide_flag": false,
                      "id": 109356,
                      "header_text": "",
                      "begin": 1629550800000,
                      "desc": "Through Monday, August 23 at 6 p.m., A and B Loop service will run across the Tilikum Bridge and turn around on either end of the Broadway Bridge due to Broadway Bridge closure."
                  }
              ],
              "arrival": [
                  {
                      "feet": null,
                      "departed": false,
                      "scheduled": 1629643800000,
                      "shortSign": "Loop A to Lloyd via Pearl",
                      "detoured": true,
                      "tripID": "10963528",
                      "dir": 0,
                      "blockID": 36,
                      "detour": [
                          74434,
                          109356
                      ],
                      "route": 194,
                      "piece": "1",
                      "fullSign": "Portland Streetcar Loop A - To Lloyd via Pearl",
                      "id": "10963528_28200_22",
                      "dropOffOnly": false,
                      "vehicleID": null,
                      "showMilesAway": false,
                      "locid": 10764,
                      "newTrip": false,
                      "status": "scheduled"
                  },
                  {
                      "feet": null,
                      "departed": false,
                      "scheduled": 1629645600000,
                      "shortSign": "NS Line to NW 23rd Ave",
                      "detoured": false,
                      "tripID": "10963203",
                      "dir": 0,
                      "blockID": 74,
                      "route": 193,
                      "piece": "1",
                      "fullSign": "Portland Streetcar NS Line to NW 23rd Ave",
                      "id": "10963203_30000_22",
                      "dropOffOnly": false,
                      "vehicleID": null,
                      "showMilesAway": false,
                      "locid": 10764,
                      "newTrip": false,
                      "status": "scheduled"
                  }
              ],
              "queryTime": 1629616124308,
              "location": [
                  {
                      "lng": -122.682078,
                      "passengerCode": "E",
                      "id": 10764,
                      "dir": "Northbound",
                      "lat": 45.51222,
                      "desc": "PSU Urban Center"
                  }
              ]
          }
        }'
      }
      let(:expected_response_hash) {
        {
          10764 =>
            {
              :dir => "Northbound",
              :desc => "PSU Urban Center",
              :arrivals =>
                [
                  {
                    :route => 194,
                    :scheduled => "2021-08-22T07:50:00-07:00",
                    :full_sign => "Portland Streetcar Loop A - To Lloyd via Pearl",
                    :short_sign => "Loop A to Lloyd via Pearl",
                    :route_info =>
                      {
                        :route_number => 194,
                        :route_id => 194,
                        :route_type => "R",
                        :desc => "Portland Streetcar - A Loop",
                        :route_sort_order => 250,
                        :frequent_service => false,
                        :route_color => "#CE0F69",
                        :brand => { :name => "Trimet" },
                        :rail_short_sign => "A"
                      }
                  },
                  {
                    :route => 193,
                    :scheduled => "2021-08-22T08:20:00-07:00",
                    :full_sign => "Portland Streetcar NS Line to NW 23rd Ave",
                    :short_sign => "NS Line to NW 23rd Ave",
                    :route_info =>
                      {
                        :route_number => 193,
                        :route_id => 193,
                        :route_type => "R",
                        :desc => "Portland Streetcar - NS Line",
                        :route_sort_order => 200,
                        :frequent_service => false,
                        :route_color => "#84BD00",
                        :brand => { :name => "Trimet" },
                        :rail_short_sign => "NS"
                      }
                  }
                ]
            }
        }
      }

      let(:route_feature_finder_double) { instance_double(Conductors::Trimet::RouteFeatureFinder, response: {
        194 => {
          :route_number => 194,
          :route_id => 194,
          :route_type => "R",
          :desc => "Portland Streetcar - A Loop",
          :route_sort_order => 250,
          :frequent_service => false,
          :route_color => "#CE0F69",
          :brand => { :name => "Trimet" },
          :rail_short_sign => "A"
        },
        193 => {
          :route_number => 193,
          :route_id => 193,
          :route_type => "R",
          :desc => "Portland Streetcar - NS Line",
          :route_sort_order => 200,
          :frequent_service => false,
          :route_color => "#84BD00",
          :brand => { :name => "Trimet" },
          :rail_short_sign => "NS"
        }
      }) }

      before do
        allow(Conductors::Trimet::RouteFeatureFinder).to receive(:new).and_return(route_feature_finder_double)
        allow(route_feature_finder_double).to receive(:run).and_return(route_feature_finder_double)
      end

      it 'returns routes with a short sign' do
        expect(subject.run.response).to eq(expected_response_hash)
      end
    end

    context 'when no stops are nearby' do

      before do
        allow(Conductors::Trimet::ArrivalTimes).to receive(:new).and_return(arrival_times_conductor)
      end

      let(:arrival_times_conductor) { instance_double(
        Conductors::Trimet::ArrivalTimes, results: {}
      ) }

      let(:stop_location_conductor) { instance_double(
        Conductors::Trimet::StopLocation, results: []
      ) }

      it 'returns an empty list' do
        expect(subject.run.response).to eq({})
      end
    end
  end
end