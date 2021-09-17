class LocationsController < ApplicationController
  def show
    origin = {lat: params[:lat], lon: params[:lon]} if params[:lat].present? && params[:lon].present?
    render json: Conductors::NearbyTransit.new(origin: origin).run
  end
end
