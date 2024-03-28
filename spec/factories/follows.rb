FactoryBot.define do
  factory :follow do
    follower { create(:user)}
    followed { create(:user)}
  end
end