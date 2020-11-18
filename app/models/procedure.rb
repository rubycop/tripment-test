class Procedure < ApplicationRecord
    validates :name,  presence: true

    scope :find_by_name_pattern, ->(pattern) do
        where('name LIKE ?', "%#{pattern}%")
        .sort{|procedure| procedure.name.index(pattern)}
    end
end
