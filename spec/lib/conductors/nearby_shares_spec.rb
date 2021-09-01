require 'rails_helper'

RSpec.describe Conductors::NearbyShares do
    subject { Conductors::NearbyShares.new }
    
    let(:brand) { instance_double(Brand, id: 1, name: 'Raptyr')}
    let(:bike_1) { instance_double(Share, bike_uuid: 1, lat: 1, lon: 2, brand_id: 1, brand: brand) }
    let(:bike_2) { instance_double(Share, bike_uuid: 2, lat: 1, lon: 2, brand_id: 1, brand: brand) }
    let(:bike_3) { instance_double(Share, bike_uuid: 3, lat: 1, lon: 2, brand_id: 1, brand: brand) }
    let(:bike_4) { instance_double(Share, bike_uuid: 4, lat: 1, lon: 2, brand_id: 1, brand: brand) }
    let(:distance_calculator)  { instance_double(Calculators::Distance) }

    let(:share_collection) {[bike_1, bike_2, bike_3, bike_4]}

    before do
        allow(Brand).to receive(:all).and_return([brand])
        allow(Share).to receive(:find_each).
            and_yield(bike_1).
            and_yield(bike_2).
            and_yield(bike_3).
            and_yield(bike_4)
            
        allow(Calculators::Distance).to receive(:new).and_return(distance_calculator)

        allow(distance_calculator).to receive(:calculate).
            with(bike_1).and_return(0.20)
        allow(distance_calculator).to receive(:calculate).
            with(bike_2).and_return(0.29)
        allow(distance_calculator).to receive(:calculate).
            with(bike_3).and_return(0.32)
        allow(distance_calculator).to receive(:calculate).
            with(bike_4).and_return(0.19)
    end

    it 'returns shares within the max distance' do
        result = Conductors::NearbyShares.new.run.result
        expect(result[brand.name.to_sym].first[:bike_uuid]).to eq(4)
    end

    it 'excludes shares outside the max distance' do
        result = Conductors::NearbyShares.new.run.result
        expect(result[brand.name.to_sym].count).to eq(1)
    end
end