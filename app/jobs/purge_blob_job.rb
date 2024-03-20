class PurgeBlobJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    blob.attachments.each do |attachment|
      attachment.photo_process_state&.destroy
      attachment.purge
    end
  end
end