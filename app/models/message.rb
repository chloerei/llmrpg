class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :character, optional: true

  enum :role, {
    user: 0,
    assistant: 1
  }

  enum :status, {
    pending: 0,
    completed: 1
  }

  def to_openai_message
    prefix = character ? "#{character.name}: " : ""

    {
      role: role,
      content: prefix + content
    }
  end
end
