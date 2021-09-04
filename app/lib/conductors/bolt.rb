module Conductors
  class Bolt < Base
    attr_reader :name

    def initialize
      @name = 'Bolt'
    end

    private

    protected def web_service_get_data
      WebServices::Bolt.new.get_data
    end
  end
end