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
class User < ApplicationRecord
  # Others devise modules available are; :confirmable, :lockable, :timeoutable,
  # :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  # Those the user is following by:
  has_many :following, foreign_key: :follower_id, class_name: "Follow" # those u r following (returns the join table records)
  has_many :followed_users, through: :following, source: :followed # those u r following (returns user records)
  # Those the user is being followed by:
  has_many :followers, foreign_key: :followed_id, class_name: "Follow" # those following u (returns join table records)
  has_many :following_users, through: :followers, source: :follower # those following u (returns user records)
  
  has_many :likes
  has_many :comments
  has_many :messages

  # To differentiate whether the user was initiator of conversation - participant_one, or recipient of original message - participant_two
  has_many :participating_conversations_as_one, foreign_key: :participant_one_id, class_name: "Conversation", dependent: destroy
  has_many :participating_conversations_as_two, foreign_key: :participant_two_id, class_name: "Conversation", dependent: destroy

  # To get all conversations the user is participating in, no matter their role
  def conversations
    participating_conversations_as_one.or(participating_conversations_as_two)
    # Conversation.where("participant_one_id = :id OR participant_two_id = :id", id: id) # An alternative to same end
  end
  
  has_one_attached :profile_photo do |attachable|
    attachable.variant :avatar, resize_to_limit: [100, 100], preprocessed: true
  end

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: :password_required?
  validates :email, format: { with: Devise.email_regexp }
  validates :username, length: { in: 3..20 }

  after_save_commit :enqueue_profile_photo_processing, if: -> { profile_photo_attached? && !processed? }
  
  private
  def profile_photo_attached?
    profile_photo.attached?
  end

  def processed?
    profile_photo.blob.metadata[:processed] == true
  end

  def enqueue_profile_photo_processing
    Rails.logger.info("Enqueuing profile photo processing job for user: #{profile_photo.blob_id}")
    ProcessImageJob.perform_later(profile_photo.blob.id, width: 500, height: 500)
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

end
