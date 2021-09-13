class LocationsController < ApplicationController
  def show
    set_headers
    origin = {lat: params[:lat], lon: params[:lon]} if params[:lat].present? && params[:lon].present?
    render json: Conductors::NearbyTransit.new(origin: origin).run
  end

  private

  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
