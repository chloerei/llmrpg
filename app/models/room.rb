class Room < ApplicationRecord
  has_many :members, dependent: :destroy
end
