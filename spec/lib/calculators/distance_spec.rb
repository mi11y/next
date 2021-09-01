require 'rails_helper'

RSpec.describe Calculators::Distance do
  subject { Calculators::Distance }
  let(:haversine_double) { instance_double(Haversine::Distance, to_miles: true)}
  let(:share_double) { instance_double(Share, lat: "12", lon: "20")}
  let(:origin) {{lat: 100, lon: 200}}

  before do
    allow(Haversine).to receive(:distance).and_return(haversine_double)
  end

  it 'accepts a lat lon hash to calculate distance' do
    expect(Haversine).to receive(:distance).with(
      100,
      200,
      12,
      20
    )
    expect(haversine_double).to receive(:to_miles)
    subject.new(origin).calculate(share_double)
  end
end