class CombinedWebCallJob
  include Sidekiq::Worker

  def perform(*args)
    puts "[CombinedWebCallJob][JobStart]"
    puts "[CombinedWebCallJob][LimeConductor][ConductorStart]"
    lime_count = Conductors::Lime.new.run.create_or_update_count
    puts "[CombinedWebCallJob][LimeConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][BirdConductor][ConductorStart]"
    bird_count = Conductors::Bird.new.run.create_or_update_count
    puts "[CombinedWebCallJob][BirdConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][SpinConductor][ConductorStart]"
    spin_count = Conductors::Spin.new.run.create_or_update_count
    puts "[CombinedWebCallJob][SpinConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][BiketownConductor][ConductorStart]"
    biketown_count = Conductors::Biketown::Bikes.new.run.create_or_update_count
    puts "[CombinedWebCallJob][BiketownConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][BiketownStationsConductor][ConductorStart]"
    Conductors::Biketown::Stations.new.run
    puts "[CombinedWebCallJob][BiketownStationsConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][BiketownStationStatusConductor][ConductorStart]"
    Conductors::Biketown::StationStatus.new.run
    puts "[CombinedWebCallJob][BiketownStationStatusConductor][ConductorEnd]"

    puts "[CombinedWebCallJob][Conductors::Trimet::AllRoutes][ConductorStart]"
    Conductors::Trimet::AllRoutes.new.run
    puts "[CombinedWebCallJob][Conductors::Trimet::AllRoutes][ConductorEnd]"

    puts "[CombinedWebCallJob][Conductors::Odot::DriveTimes][ConductorStart]"
    Conductors::Odot::DriveTimes.new.run
    puts "[CombinedWebCallJob][Conductors::Odot::DriveTimes][ConductorEnd]"

    if lime_count > 0
      puts "[CombinedWebCallJob][Conductors::LimeShare::RemoveOldLimeShares][ConductorStart]"
      Conductors::LimeShare::RemoveOldLimeShares.new.run
      puts "[CombinedWebCallJob][Conductors::LimeShare::RemoveOldLimeShares][ConductorEnd]"
    end

    if bird_count > 0
      puts "[CombinedWebCallJob][Conductors::BirdShare::RemoveOldBirdShares][ConductorStart]"
      Conductors::BirdShare::RemoveOldBirdShares.new.run
      puts "[CombinedWebCallJob][Conductors::BirdShare::RemoveOldBirdShares][ConductorEnd]"
    end

    if spin_count > 0
      puts "[CombinedWebCallJob][Conductors::SpinShare::RemoveOldSpinShares][ConductorStart]"
      Conductors::SpinShare::RemoveOldSpinShares.new.run
      puts "[CombinedWebCallJob][Conductors::SpinShare::RemoveOldSpinShares][ConductorEnd]"
    end

    if biketown_count > 0
      puts "[CombinedWebCallJob][Conductors::Biketown::RemoveOldBiketownShares][ConductorStart]"
      Conductors::Biketown::RemoveOldBiketownShares.new.run
      puts "[CombinedWebCallJob][Conductors::Biketown::RemoveOldBiketownShares][ConductorEnd]"
    end

    puts "[CombinedWebCallJob][JobEnd]"
  end
end
