require 'rails_helper'

RSpec.describe Conductors::Trimet::RouteFeatureFinder do

  let(:route_numbers) { [93, 12, 290] }

  subject { described_class.new(routes: route_numbers) }

  let(:brand) { instance_double(Brand, name: "Trimet") }
  let(:route_93_hash) { {
    route_color: "",
    route_number: 93,
    route_id: 93,
    frequent_service: false,
    route_type: "B",
    desc: "93-Tigard/Sherwood",
    route_sort_order: 5000,
    brand: { name: "Trimet" }
  } }


  let(:route_93) { instance_double(Route,
                                   route_color: "",
                                   route_number: 93,
                                   route_id: 93,
                                   frequent_service: false,
                                   route_type: "B",
                                   desc: "93-Tigard/Sherwood",
                                   route_sort_order: 5000,
                                   brand: brand,
                                   to_hash: route_93_hash,
  ) }

  let(:route_12_hash) {{
    route_color: "",
    route_number: 12,
    route_id: 12,
    frequent_service: true,
    route_type: "B",
    desc: "12-Barbur/Sandy Blvd",
    route_sort_order: 5000,
    brand: { name: "Trimet" }
  }}
  let(:route_12) { instance_double(Route,
                                   route_color: "",
                                   route_number: 12,
                                   route_id: 12,
                                   frequent_service: true,
                                   route_type: "B",
                                   desc: "12-Barbur/Sandy Blvd",
                                   route_sort_order: 5000,
                                   brand: brand,
                                   to_hash: route_12_hash
  ) }

  let(:route_290_hash) {{
    route_color: "#F58220",
    route_number: 290,
    route_id: 290,
    frequent_service: true,
    route_type: "R",
    desc: "MAX Orange Line",
    route_sort_order: 5000,
    brand: { name: "Trimet" },
  }}
  let(:route_290) { instance_double(Route,
                                    route_color: "#F58220",
                                    route_number: 290,
                                    route_id: 290,
                                    frequent_service: true,
                                    route_type: "R",
                                    desc: "MAX Orange Line",
                                    route_sort_order: 5000,
                                    brand: brand,
                                    to_hash: route_290_hash
  ) }

  let(:existing_routes) {
    instance_double(
      ActiveRecord::Relation,
      count: 3,
    )
  }

  before do
    allow(Route).to receive(:where).with(route_number: route_numbers).and_return(existing_routes)
    allow(existing_routes).to receive(:each).
      and_yield(route_93).
      and_yield(route_12).
      and_yield(route_290)
  end

  describe '#run' do

    context 'when routes are supplied' do
      before do
        expect(Route).to receive(:where).with(route_number: route_numbers)
      end

      it 'returns itself' do
        expect(subject.run).to be_a_kind_of(described_class)
      end
    end

    context 'when no routes are supplied' do
      let(:route_numbers) { [] }

      it 'does not query' do
        expect(Route).not_to receive(:where)
        subject.run
      end
    end
  end

  describe '#response' do
    it 'maps the route keys to routes' do
      results = subject.run.response
      expect(results[12]).to eq(route_12_hash)
      expect(results[93]).to eq(route_93_hash)
      expect(results[290]).to eq(route_290_hash)
    end

    context 'when no routes are supplied' do
      let(:route_numbers) { [] }

      it 'returns an empty hash' do
        expect(subject.run.response).to eq({})
      end
    end
  end
end
