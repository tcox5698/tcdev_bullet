FactoryBot.define do
  factory :client_patient do
    association :team
    first_name { "MyString" }
    last_name { "MyString" }
  end
end
