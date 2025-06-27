FactoryBot.define do
  factory :conversation do
    user
    room { association :room, user: user }
  end
end
