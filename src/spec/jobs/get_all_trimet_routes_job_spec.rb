require 'rails_helper'

RSpec.describe GetAllTrimetRoutesJob do
  subject { described_class.new }

  let(:all_trimet_routes_conductor) { instance_double(Conductors::Trimet::AllRoutes, run: true) }

  before do
    allow(Conductors::Trimet::AllRoutes).to receive(:new).and_return(all_trimet_routes_conductor)
  end

  describe '#perform' do
    it 'calls the all routes trimet conductor' do
      expect(Conductors::Trimet::AllRoutes).to receive(:new).and_return(all_trimet_routes_conductor)
      expect(all_trimet_routes_conductor).to receive(:run)
      subject.perform
    end
  end
end