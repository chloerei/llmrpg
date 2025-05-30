class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :persona
  belongs_to :character
  has_many :messages, dependent: :destroy
end
