if Sidekiq.server?
  Rails.application.config.after_initialize do
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(Rails.root.join("config", "schedule.yml"))
  end
end