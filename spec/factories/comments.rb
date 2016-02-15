FactoryGirl.define do
  factory :comment do
    content "MyString"
    post
    commenter
  end
end
