require 'rails_helper'

RSpec.describe "Locations", type: :request do
  describe "GET /show" do

    let(:double) { instance_double(Conductors::NearbyTransit) }

    before do
      allow(Conductors::NearbyTransit).to receive(:new).and_return(double)
      allow(double).to receive(:run).and_return({status: 200})
    end

    it "returns http success" do
      get "/locations/show"
      expect(response).to have_http_status(:success)
    end
  end
end
