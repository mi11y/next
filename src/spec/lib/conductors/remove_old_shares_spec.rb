require 'rails_helper'

RSpec.describe Conductors::RemoveOldShares do

  before do
    Timecop.freeze(Time.now)
  end

  let(:existing_shares) { instance_double(
    ActiveRecord::Relation,
    count: 1,
    destroy_all: true
  ) }

  describe '#run' do

    subject { Conductors::RemoveOldShares.new(5) }

    it 'queries for shares that havent been updated' do
      expect(Share).to receive(:where).with([
                                              'updated_at < ?',
                                              5.minutes.ago
                                            ]).and_return(existing_shares)
      subject.run
    end

    it 'calls destroy_all on shares that havent been updated' do
      allow(Share).to receive(:where).and_return(existing_shares)
      expect(existing_shares).to receive(:destroy_all)
      subject.run
    end
  end
end