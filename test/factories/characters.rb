FactoryBot.define do
  factory :character do
    user
    name { "Character Name" }
    description { "This is a description of the character." }
  end
end
