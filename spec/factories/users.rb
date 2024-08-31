# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  active_conversation_id :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'Password12!' }

    after(:build) do |user|
      user.profile_photo.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'jpg_test_img_1.jpg')),
        filename: 'jpg_test_img_1.jpg',
        content_type: 'image/jpg'
      )
    end
  end
end
