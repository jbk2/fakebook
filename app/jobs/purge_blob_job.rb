class PurgeBlobJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    if blob
      blob.attachments.each(&:destroy) # Detach all attachments
      blob.purge if blob.attachments.empty?
    end
  end
end