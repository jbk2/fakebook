# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string
#  active_conversation_id :integer
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
