# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  body           :string
#  comments_count :integer          default(0), not null
#  likes_count    :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    sequence(:body) { |n| "Post body content #{n} & id #{self.id}" }
    user { create(:user) }
  end

  factory :post_with_photos, parent: :post do
    transient do
      photos_count { 2 }
    end

    after(:create) do |post, evaluator|
      evaluator.photos_count.times do |index|
        img_path = Rails.root.join('spec', 'fixtures', "jpg_test_img_#{index + 1}.jpg")
        if File.exist?(img_path)
          post.photos.attach(
            io: File.open(img_path),
            filename: "jpg_test_img_#{index + 1}.jpg",
            content_type: 'image/jpg'
          )
        end
      end
    end
  end

end
