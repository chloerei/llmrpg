FactoryBot.define do
  factory :message do
    room
    creator { room.user }
    content { "This is a message content." }
  end
end
