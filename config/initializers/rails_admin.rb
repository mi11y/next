RailsAdmin.config do |config|

  config.model 'DriveTimeOrigin' do
    list do
      field :origin_id
      configure :origin_id do
        show
      end
      field :location_name
      configure :location_name do
        show
      end
      field :lat
      configure :lat do
        show
      end
      field :lon
      configure :lon do
        show
      end
      field :drive_time_destinations
      configure :drive_time_Destinations do
        show
      end
    end
  end

  config.model 'ShareStationStatus' do
    list do
      field :updated_at
      configure :updated_at do
        show
      end
      field :created_at
      configure :created_at do
        show
      end
      field :station_id
      configure :station_id do
        show
      end
      field :num_docks_available
      configure :num_docks_available do
        show
      end
      field :is_returning
      configure :is_returning do
        show
      end
      field :is_installed
      configure :is_installed do
        show
      end
      field :num_bikes_available
      configure :num_bikes_available do
        show
      end
      field :is_renting
      configure :is_renting do
        show
      end
      field :share_station
      configure :share_Station do
        show
      end
      field :brand
      configure :brand do
        show
      end
    end
  end

  config.model 'ShareStation' do
    field :updated_at
    configure :updated_at do
      show
    end
    field :created_at
    configure :created_at do
      show
    end
    field :lat
    configure :lat do
      show
    end
    field :lon
    configure :lon do
      show
    end
    field :capacity
    configure :capacity do
      show
    end
    field :name
    configure :name do
      show
    end
    field :station_uuid
    configure :station_uuid do
      show
    end
    field :brand
    configure :brand do
      show
    end
    field :share_station_status
    configure :share_station_status do
      show
    end
  end

  config.model 'Share' do
    field :updated_at
    configure :updated_at do
      show
    end
    field :created_at
    configure :created_at do
      show
    end
    field :lat
    configure :lat do
      show
    end
    field :brand
    configure :brand do
      show
    end
    field :lon
    configure :lon do
      show
    end
    field :bike_uuid
    configure :bike_uuid do
      show
    end
    field :disabled
    configure :disabled do
      show
    end
    field :reserved
    configure :reserved do
      show
    end
  end

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
