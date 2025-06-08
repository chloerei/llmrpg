class Room < ApplicationRecord
  belongs_to :user
  belongs_to :persona
  has_many :members, dependent: :destroy
  has_many :characters, through: :members
  has_many :conversations, dependent: :destroy
end
