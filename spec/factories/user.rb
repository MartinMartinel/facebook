FactoryGirl.define do
  factory :user, aliases: [:creator, :receiver, :commenter] do
    first_name "John"
    last_name "Doe"
    sequence(:email) { |n| "john_doe#{n}@example.com" }
    password "password"
    gender 0
  end
end
