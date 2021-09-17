require 'rails_helper'

RSpec.describe Route, type: :model do
  let(:sample_payload) {
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
  let(:sample_payload_hash) { JSON.parse(sample_payload).with_indifferent_access }

  let(:brand) { Brand.find_by(name: "Trimet") }
  let(:route_93_hash) { {
    route_number: 93,
    route_id: 93,
    frequent_service: false,
    route_type: "B",
    desc: "93-Tigard/Sherwood",
    route_sort_order: 5000
  } }
  let(:route_12_hash) { {
    route_number: 12,
    route_id: 12,
    frequent_service: true,
    route_type: "B",
    desc: "12-Barbur/Sandy Blvd",
    route_sort_order: 5000
  } }
  let(:route_290_hash) { {
    route_color: "#F58220",
    route_number: 290,
    route_id: 290,
    frequent_service: true,
    route_type: "R",
    desc: "MAX Orange Line",
    route_sort_order: 5000
  } }

  # Street Cars
  #
  #
  let(:route_193_hash) { {
    route_color: "#84BD00",
    frequent_service: false,
    route_id: 193,
    route_number: 193,
    route_type: "R",
    desc: "Portland Streetcar - NS Line",
    route_sort_order: 200
  } }
  let(:route_194_hash) { {
    route_color: "#CE0F69",
    frequent_service: false,
    route_id: 194,
    route_number: 194,
    route_type: "R",
    desc: "Portland Streetcar - A Loop",
    route_sort_order: 250
  } }

  let(:route_195_hash) { {
    route_color: "#0093B2",
    frequent_service: false,
    route_id: 195,
    route_number: 195,
    route_type: "R",
    desc: "Portland Streetcar - B Loop",
    route_sort_order: 275
  } }

  # WES
  #
  #
  let(:route_203_hash) { {
    route_color: "#000000",
    frequent_service: false,
    route_id: 203,
    route_number: 203,
    route_type: "R",
    desc: "WES Commuter Rail",
    route_sort_order: 150
  } }
  describe 'validations' do
    subject { described_class.new }

    it { should validate_exclusion_of(:frequent_service).in_array([nil]) }
    it { should validate_exclusion_of(:route_color).in_array([nil]) }
    it { should validate_presence_of(:route_number) }
    it { should validate_presence_of(:route_id) }
    it { should validate_presence_of(:route_type) }
    it { should validate_presence_of(:desc) }
    it { should validate_presence_of(:route_sort_order) }
  end

  describe '.for' do
    subject { described_class }
    let(:brand) { Brand.find_by(name: 'Trimet') }

    it 'can initialize from a hash payload' do
      result = subject.for_hash(sample_payload_hash, brand)
      expect(result.first).to be_a described_class
    end

    it 'persists routes in the database' do
      subject.for_hash(sample_payload_hash, brand)
      expect(Route.find_by(route_number: 12)).to_not be nil
    end

    it 'initializes to a default brand' do
      result = subject.for_hash(sample_payload_hash)
      expect(result.first.brand.name).to eq('Trimet')
    end

    context 'when a route is frequent service' do
      it 'is flagged as frequent service' do
        subject.for_hash(sample_payload_hash)
        expect(Route.find_by(route_number: 12).frequent_service).to eq(true)
      end
    end

    context 'when a route has a route color' do
      it 'saves the route color' do
        subject.for_hash(sample_payload_hash)
        expect(Route.find_by(route_number: 290).route_color).to eq("#F58220")
      end
    end

    context 'when the route already exists' do
      it 'does not create a new record' do
        subject.for_hash(sample_payload_hash, brand)
        subject.for_hash(sample_payload_hash, brand)

        expect(Route.count).to eq(3)
      end
    end
  end

  describe '#to_hash' do
    before do
      Route.create!(route_93_hash.merge({ brand: brand, route_color: "" }))
      Route.create!(route_12_hash.merge({ brand: brand, route_color: "" }))
      Route.create!(route_290_hash.merge({ brand: brand }))

      Route.create!(route_193_hash.merge({ brand: brand }))
      Route.create!(route_194_hash.merge({ brand: brand }))
      Route.create!(route_195_hash.merge({ brand: brand }))
      Route.create!(route_203_hash.merge({ brand: brand }))
    end
    let(:route_93) { Route.find_by(route_number: 93) }
    let(:route_12) { Route.find_by(route_number: 12) }
    let(:route_290) { Route.find_by(route_number: 290) }

    let(:route_193) { Route.find_by(route_number: 193) }
    let(:route_194) { Route.find_by(route_number: 194) }
    let(:route_195) { Route.find_by(route_number: 195) }
    let(:route_203) { Route.find_by(route_number: 203) }

    it 'hashes rail lines as expected' do
      expect(route_290.to_hash).to eq(route_290_hash.merge({ brand: { name: "Trimet" } }))
    end

    it 'hashes regular bus lines as expected' do
      expect(route_93.to_hash).to eq(route_93_hash.merge({ brand: { name: "Trimet" } }))
    end

    it 'hashes frequent service bus lines as expected' do
      expect(route_12.to_hash).to eq(route_12_hash.merge({ brand: { name: "Trimet" } }))
    end

    context 'street cars / WES have a short sign' do
      it 'hashes NS as expected' do
        expect(route_193.to_hash).to eq(route_193_hash.merge({ rail_short_sign: "NS", brand: { name: "Trimet" } }))
      end

      it 'hashes A loop as expected' do
        expect(route_194.to_hash).to eq(route_194_hash.merge({ rail_short_sign: "A", brand: { name: "Trimet" } }))
      end

      it 'hashes B loop as expected' do
        expect(route_195.to_hash).to eq(route_195_hash.merge({ rail_short_sign: "B", brand: { name: "Trimet" } }))
      end

      it 'hashes WES loop as expected' do
        expect(route_203.to_hash).to eq(route_203_hash.merge({ rail_short_sign: "WES", brand: { name: "Trimet" } }))
      end
    end
  end
end
