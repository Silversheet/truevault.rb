FactoryGirl.define do
  factory :deletable_group, class: OpenStruct do
    name "deletable_group_#{SecureRandom.hex}"
  end

  factory :group, class: OpenStruct do
    name "test_group_#{SecureRandom.hex}"
  end

  factory :user, class: OpenStruct do
    username "test_user_#{SecureRandom.hex}"
    password "password"
  end

  factory :user_attributes, class: OpenStruct do
    name "John"
    type "patient"
  end
end
