class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id, image_type, width: nil, height: nil)
    original_blob = ActiveStorage::Blob.find(blob_id)
    
    download_blob_to_tempfile(original_blob) do |tempfile|
      processed_image = process_image(tempfile.path, width, height)
      new_blob = nil

      File.open(processed_image.path, 'rb') do |file|
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: original_blob.filename,
          content_type: original_blob.content_type
        )
      end

      ApplicationRecord.transaction do
        original_blob.attachments.each do |attachment|
          if new_blob
            if image_type == "post"
              attachment.record.photos.attach(new_blob)
            elsif image_type == "user"
              attachment.record.profile_photo.attach(new_blob)
            end
          end
        end
        original_blob.purge
      end

      processed_image.close
      processed_image.unlink
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
end
