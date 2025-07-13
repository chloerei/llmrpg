class Room < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy
  has_many :characters, through: :members
  has_many :conversations, dependent: :destroy

  validates :name, presence: true
end
