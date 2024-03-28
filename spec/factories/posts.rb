FactoryBot.define do
  factory :post do
    sequence(:body) { |n| "Post content/body #{n}" }
    user { create(:user) }
  end
end