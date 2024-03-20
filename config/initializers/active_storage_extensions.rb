# Extend ActiveStorage models for custom associations
Rails.application.config.to_prepare do
  ActiveStorage::Attachment.has_one :photo_process_state, dependent: :destroy
  ActiveStorage::Blob.has_many :attachments, class_name: 'ActiveStorage::Attachment', dependent: :nullify
end
