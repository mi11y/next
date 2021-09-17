class GetAllTrimetRoutesJob
  include Sidekiq::Worker
  def perform(*args)
    puts "[GetAllTrimetRoutesJob][RemoveOldShareStations][ConductorStart]"
    Conductors::Trimet::AllRoutes.new.run
    puts "[GetAllTrimetRoutesJob][RemoveOldShareStations][ConductorEnd]"
  end
end
