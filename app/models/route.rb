class Route < ApplicationRecord
  belongs_to :brand

  validates :route_number,
            :route_id,
            :route_type,
            :desc,
            :route_sort_order,
            presence: true

  validates_inclusion_of :frequent_service, in: [true, false]
  validates_exclusion_of :frequent_service, :route_color, in: [nil]

  def self.for_hash(hash, brand = nil)
    brand = brand || get_default_brand
    return find_or_create_for(hash, brand)
  end

  def to_hash
    result = {
      route_number: route_number,
      route_id: route_id,
      route_type: route_type,
      desc: desc,
      route_sort_order: route_sort_order,
      frequent_service: frequent_service,
      brand: brand.to_hash
    }
    result = result.merge({ route_color: route_color }) if route_color.present?
    result = result.merge(SHORT_SIGNS[route_number]) if SHORT_SIGNS[route_number].present?
    result
  end

  private

  SHORT_SIGNS = {
    193 => { rail_short_sign: "NS" },
    194 => { rail_short_sign: "A" },
    195 => { rail_short_sign: "B" },
    203 => { rail_short_sign: "WES" },
  }

  def self.find_or_create_for(hash, brand)
    return nil if hash.nil?
    return nil if brand.nil?

    total_creates = 0
    total_updates = 0

    routes = get_routes_from(hash)
    new_or_updated_routes = routes.map do |route_hash|
      route = find_by(brand: brand, route_number: route_hash[:route])
      if route.nil?
        result = creation_hash(route_hash, brand)
        route = create!(
          result
        )
        total_creates = total_creates + 1
      else
        result = creation_hash(route_hash, brand)
        route.update!(
          result
        )
        total_updates = total_updates + 1
      end
      route
    end
    puts "[RouteModel][Totals] creates=#{total_creates} update=#{total_updates}"
    return new_or_updated_routes
  end

  def self.creation_hash(route_hash, brand)
    route_color = route_hash[:routeColor].blank? ? "" : "##{route_hash[:routeColor]}"
    {
      route_color: route_color,
      frequent_service: route_hash[:frequentService],
      route_number: route_hash[:route],
      route_id: route_hash[:id],
      route_type: route_hash[:type],
      desc: route_hash[:desc],
      route_sort_order: route_hash[:routeSortOrder],
      brand: brand
    }
  end

  def self.get_routes_from(hash)
    hash[:resultSet][:route]
  end

  def self.get_default_brand
    Brand.find_by(name: 'Trimet')
  end

end
