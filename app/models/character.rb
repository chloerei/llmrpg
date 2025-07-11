class Character < ApplicationRecord
  belongs_to :user
  has_many :members, dependent: :destroy

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 512, 512 ]
  end
end
