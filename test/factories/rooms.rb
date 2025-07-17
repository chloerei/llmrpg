FactoryBot.define do
  factory :room do
    user
    name { "Room Name" }
    prompt { "This is a description of the room." }
  end
end
