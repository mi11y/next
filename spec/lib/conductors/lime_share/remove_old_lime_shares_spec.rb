require 'rails_helper'

RSpec.describe Conductors::LimeShare::RemoveOldLimeShares do
  let(:existing_shares) { instance_double(
    ActiveRecord::Relation,
    count: 1,
    destroy_all: true
  ) }
  let(:brand) { Brand.find_by(name: 'Lime') }

  before do
    Timecop.freeze(Time.now)
  end

  subject { Conductors::LimeShare::RemoveOldLimeShares.new(5) }

  context '#run' do
    before do
      allow(Share).to receive(:where).with([
                                             "brand_id = ? AND updated_at < ?",
                                             brand,
                                             5
                                           ]).and_return(existing_shares)
    end

    it 'queries for shares that havent been updated' do
      expect(Share).to receive(:where).with([
                                              "brand_id = ? AND updated_at < ?",
                                              brand,
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