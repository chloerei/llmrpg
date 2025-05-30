class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :creator, polymorphic: true
end
