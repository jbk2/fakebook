# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :owner, class_name: "User", foreign_key: "user_id"

  has_many_attached :photos do |attachable|
    attachable.variant :medium, resize_to_fill: [400, 400], preprocessed: true
  end

  after_save_commit :create_photo_process_state, if: :photos_attached?

  private
 
  def photos_attached?
    photos.attached?
  end

  def create_photo_process_state
    photos.each do |photo|
      processed_photo = PhotoProcessState.find_or_initialize_by(attachment_id: photo.id)
      processed_photo.save! if processed_photo.new_record?
    end
  end

end
