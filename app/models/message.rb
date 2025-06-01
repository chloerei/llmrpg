class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :creator, polymorphic: true

  broadcasts_to :conversation, partial: "conversations/messages/message"

  validates :content, presence: true
end
