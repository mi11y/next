class RemoveStaleShareStationsJob
  include Sidekiq::Worker
  def perform(*args)
    puts "[RemoveStaleShareStationsJob][RemoveOldShareStations][ConductorStart]"
    Conductors::RemoveOldShareStations.new.run
    puts "[RemoveStaleShareStationsJob][RemoveOldShareStations][ConductorEnd]"
  end
end
