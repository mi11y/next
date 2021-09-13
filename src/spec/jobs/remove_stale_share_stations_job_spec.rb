require 'rails_helper'

RSpec.describe RemoveStaleShareStationsJob do
  subject { described_class.new }

  let(:remove_old_share_stations_double) { instance_double(Conductors::RemoveOldShareStations, run: true) }

  before do
    allow(Conductors::RemoveOldShareStations).to receive(:new).and_return(remove_old_share_stations_double)
  end

  describe '#perform' do
    it 'calls the remove old shares conductor' do
      expect(Conductors::RemoveOldShareStations).to receive(:new).and_return(remove_old_share_stations_double)
      expect(remove_old_share_stations_double).to receive(:run)
      subject.perform
    end
  end
end