class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :creator, polymorphic: true

  broadcasts_to :conversation, partial: "conversations/messages/message"

  enum :status, {
    pending: 0,
    completed: 1
  }
end
