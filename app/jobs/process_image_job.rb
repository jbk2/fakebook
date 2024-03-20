class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id, image_association_name, width: nil, height: nil)
    original_blob = ActiveStorage::Blob.find(blob_id)

    download_blob_to_tempfile(original_blob) do |tempfile|
      processed_image = process_image(tempfile.path, width, height)
      new_blob = create_new_blob(processed_image, original_blob)

      ApplicationRecord.transaction do
        attach_new_blob(new_blob, original_blob, image_association_name)
      end

      new_blob_id = new_blob.id
      new_attachment_id = new_blob.attachments.first.id

      processed_image.close
      processed_image.unlink

      if image_association_name.to_s == 'photos'
        PurgeBlobJob.set(wait: 15.seconds).perform_later(original_blob.id)
      end
      PhotoProcessState.find_by(attachment_id: new_attachment_id).update(processed: true)
    end
  rescue => e
    Rails.logger.error("Failed to process and replace image: #{e.message}")
    retry
  end

  private
  def download_blob_to_tempfile(blob, &block)
    tempfile = Tempfile.new(blob.filename.to_s)
    tempfile.binmode
    blob.download { |chunk| tempfile.write(chunk) }
    tempfile.rewind
    yield(tempfile)
  ensure
    tempfile.close
    tempfile.unlink
  end

  def process_image(image_path, width, height)
    processed_file = Tempfile.new(['processed', '.jpg'])

    ImageProcessing::Vips
      .source(image_path)
      .resize_to_fill(width || 1000, height || 1000)
      .call(destination: processed_file.path)

    processed_file
  end

  def create_new_blob(processed_image, original_blob)
    File.open(processed_image.path, 'rb') do |file|
      ActiveStorage::Blob.create_and_upload!(
        io: file, filename: original_blob.filename,
        content_type: original_blob.content_type
      )
    end
  end

  def attach_new_blob(new_blob, original_blob, image_association_name)
    ApplicationRecord.transaction do
      if image_association_name.to_s == 'photos'
        post = original_blob.attachments.first.record
        post.photos.attach(new_blob)
      elsif image_association_name.to_s == 'profile_photo'
        user = original_blob.attachments.first.record
        user.profile_photo.attach(new_blob)
      end
    end
  end

end
