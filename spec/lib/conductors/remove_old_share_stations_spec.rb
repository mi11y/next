require 'rails_helper'

RSpec.describe Conductors::RemoveOldShareStations do
  before do
    Timecop.freeze(Time.now)
  end

  let(:existing_share_stations) { instance_double(
    ActiveRecord::Relation,
    count: 1,
    destroy_all: true
  ) }

  describe '#run' do
    subject { Conductors::RemoveOldShareStations.new(5) }

    it 'queries for share stations that havent been updated' do
      expect(ShareStation).to receive(:where).with([
                                              'updated_at < ?',
                                              5.minutes.ago
                                            ]).and_return(existing_share_stations)
      subject.run
    end

    it 'calls destroy_all on share stations that havent been updated' do
      allow(ShareStation).to receive(:where).and_return(existing_share_stations)
      expect(existing_share_stations).to receive(:destroy_all)
      subject.run
    end
  end
end