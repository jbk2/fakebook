FactoryBot.define do
  factory :like do
    user { create(:user) }
    post { create(:post) }
  end
end