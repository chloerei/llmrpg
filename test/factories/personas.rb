FactoryBot.define do
  factory :persona do
    user
    name { "Persona Name" }
    description { "This is a description of the persona." }
  end
end
