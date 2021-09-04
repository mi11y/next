require 'rails_helper'

RSpec.describe CombinedWebCallJob, type: :job do
  subject { described_class.new }

  describe '#perform' do

    let(:lime_count) { 1 }
    let(:spin_count) { 2 }
    let(:bird_count) { 3 }
    let(:bolt_count) { 4 }
    let(:biketown_count) { 4 }

    let(:lime_double) { instance_double(Conductors::Lime, create_or_update_count: lime_count)}
    let(:spin_double) { instance_double(Conductors::Spin, create_or_update_count: spin_count)}
    let(:bird_double) { instance_double(Conductors::Bird, create_or_update_count: bird_count)}
    let(:bolt_double) { instance_double(Conductors::Bolt, create_or_update_count: bolt_count)}
    let(:biketown_double) { instance_double(Conductors::Biketown::Bikes, create_or_update_count: biketown_count)}

    let(:all_routes_double) { instance_double(Conductors::Trimet::AllRoutes, run: true)}
    let(:drive_times_double) { instance_double(Conductors::Odot::DriveTimes, run: true)}

    let(:biketown_station_double) { instance_double(Conductors::Biketown::Stations, run: true)}
    let(:biketown_station_status_double) { instance_double(Conductors::Biketown::StationStatus, run: true)}
    let(:remove_old_lime_shares_double) { instance_double(Conductors::LimeShare::RemoveOldLimeShares, run: true)}
    let(:remove_old_bird_shares_double) { instance_double(Conductors::BirdShare::RemoveOldBirdShares, run: true)}
    let(:remove_old_spin_shares_double) { instance_double(Conductors::SpinShare::RemoveOldSpinShares, run: true)}
    let(:remove_old_bolt_shares_double) { instance_double(Conductors::BoltShare::RemoveOldBoltShares, run: true)}
    let(:remove_old_biketown_shares_double) { instance_double(Conductors::Biketown::RemoveOldBiketownShares, run: true)}

    before do
      allow(Conductors::Lime).to receive(:new).and_return(lime_double)
      allow(lime_double).to receive(:run).and_return(lime_double)

      allow(Conductors::Spin).to receive(:new).and_return(spin_double)
      allow(spin_double).to receive(:run).and_return(spin_double)

      allow(Conductors::Bird).to receive(:new).and_return(bird_double)
      allow(bird_double).to receive(:run).and_return(bird_double)

      allow(Conductors::Bolt).to receive(:new).and_return(bolt_double)
      allow(bolt_double).to receive(:run).and_return(bolt_double)

      allow(Conductors::Biketown::Bikes).to receive(:new).and_return(biketown_double)
      allow(biketown_double).to receive(:run).and_return(biketown_double)

      allow(Conductors::Biketown::Stations).to receive(:new).and_return(biketown_station_double)
      allow(Conductors::Biketown::StationStatus).to receive(:new).and_return(biketown_station_status_double)

      allow(Conductors::Trimet::AllRoutes).to receive(:new).and_return(all_routes_double)
      allow(all_routes_double).to receive(:run).and_return(all_routes_double)

      allow(Conductors::Odot::DriveTimes).to receive(:new).and_return(drive_times_double)
      allow(drive_times_double).to receive(:run).and_return(drive_times_double)

      allow(Conductors::LimeShare::RemoveOldLimeShares).to receive(:new).and_return(remove_old_lime_shares_double)
      allow(Conductors::BirdShare::RemoveOldBirdShares).to receive(:new).and_return(remove_old_bird_shares_double)
      allow(Conductors::SpinShare::RemoveOldSpinShares).to receive(:new).and_return(remove_old_spin_shares_double)
      allow(Conductors::BoltShare::RemoveOldBoltShares).to receive(:new).and_return(remove_old_bolt_shares_double)
      allow(Conductors::Biketown::RemoveOldBiketownShares).to receive(:new).and_return(remove_old_biketown_shares_double)
    end

    it 'calls the lime conductor' do
      expect(Conductors::Lime).to receive(:new)
      expect(lime_double).to receive(:run)
      subject.perform
    end

    it 'calls the bird conductor' do
      expect(Conductors::Bird).to receive(:new)
      expect(bird_double).to receive(:run)
      subject.perform
    end

    it 'calls the spin conductor' do
      expect(Conductors::Spin).to receive(:new)
      expect(spin_double).to receive(:run)
      subject.perform
    end

    it 'calls the bolt conductor' do
      expect(Conductors::Bolt).to receive(:new)
      expect(bolt_double).to receive(:run)
      subject.perform
    end

    it 'calls the biketown conductor' do
      expect(Conductors::Biketown::Bikes).to receive(:new)
      expect(biketown_double).to receive(:run)
      subject.perform
    end

    it 'calls the biketown stations conductor' do
      expect(Conductors::Biketown::Stations).to receive(:new)
      expect(biketown_station_double).to receive(:run)
      subject.perform
    end

    it 'calls the biketown stations status conductor' do
      expect(Conductors::Biketown::StationStatus).to receive(:new)
      expect(biketown_station_status_double).to receive(:run)
      subject.perform
    end

    it 'calls the remove old lime shares conductor' do
      expect(Conductors::LimeShare::RemoveOldLimeShares).to receive(:new)
      expect(remove_old_lime_shares_double).to receive(:run)
      subject.perform
    end

    it 'calls the remove old bird shares conductor' do
      expect(Conductors::BirdShare::RemoveOldBirdShares).to receive(:new)
      expect(remove_old_bird_shares_double).to receive(:run)
      subject.perform
    end

    it 'calls the remove old spin shares conductor' do
      expect(Conductors::SpinShare::RemoveOldSpinShares).to receive(:new)
      expect(remove_old_spin_shares_double).to receive(:run)
      subject.perform
    end

    it 'calls the remove old bolt shares conductor' do
      expect(Conductors::BoltShare::RemoveOldBoltShares).to receive(:new)
      expect(remove_old_bolt_shares_double).to receive(:run)
      subject.perform
    end

    it 'calls the remove old biketown shares conductor' do
      expect(Conductors::Biketown::RemoveOldBiketownShares).to receive(:new)
      expect(remove_old_biketown_shares_double).to receive(:run)
      subject.perform
    end

    it 'calls the trimet all routes conductor' do
      expect(Conductors::Trimet::AllRoutes).to receive(:new)
      expect(all_routes_double).to receive(:run)
      subject.perform
    end

    it 'calls the odot drive times conductor' do
      expect(Conductors::Odot::DriveTimes).to receive(:new)
      expect(drive_times_double).to receive(:run)
      subject.perform
    end

    context 'when no updates occur' do
      let(:lime_count) { 0 }
      let(:spin_count) { 0 }
      let(:bird_count) { 0 }
      let(:bolt_count) { 0 }
      let(:biketown_count) { 0 }

      it 'does not remove lime shares' do
        expect(Conductors::LimeShare::RemoveOldLimeShares).to_not receive(:new)
        subject.perform
      end

      it 'does not remove bird shares' do
        expect(Conductors::BirdShare::RemoveOldBirdShares).to_not receive(:new)
        subject.perform
      end

      it 'does not remove spin shares' do
        expect(Conductors::SpinShare::RemoveOldSpinShares).to_not receive(:new)
        subject.perform
      end

      it 'does not remove bolt shares' do
        expect(Conductors::BoltShare::RemoveOldBoltShares).to_not receive(:new)
        subject.perform
      end

      it 'does not remove biketown shares' do
        expect(Conductors::Biketown::RemoveOldBiketownShares).to_not receive(:new)
        subject.perform
      end
    end
  end
end
