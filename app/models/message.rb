class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :creator, polymorphic: true

  enum :status, {
    pending: 0,
    completed: 1
  }
end
