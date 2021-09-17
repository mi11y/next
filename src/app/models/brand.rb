class Brand < ApplicationRecord
    validates :name, presence: true

    def to_hash
        {
          name: name
        }
    end
end
