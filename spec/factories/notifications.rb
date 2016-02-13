FactoryGirl.define do
  factory :notification do
    message "My Message"
    user
  end
end
