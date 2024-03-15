class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    original_blob = ActiveStorage::Blob.find(blob_id)
    
    download_blob_to_tempfile(original_blob) do |tempfile|
      processed_image = process_image(tempfile.path)
      new_blob = nil

      File.open(processed_image.path, 'rb') do |file|
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: file,
          filename: original_blob.filename,
          content_type: original_blob.content_type
        )
      end

      original_blob.attachments.each do |attachment|
        if new_blob
          attachment.purge
          attachment.record.photos.attach(new_blob)
        end
      end

      processed_image.close
      processed_image.unlink
    end
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

  def process_image(image_path)
    processed_file = Tempfile.new(['processed', '.jpg'])

    ImageProcessing::Vips
      .source(image_path)
      .resize_to_fill(1000, 1000)
      .call(destination: processed_file.path)

      processed_file
  end 
end
