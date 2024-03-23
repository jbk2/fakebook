class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id, image_association_name, width: nil, height: nil)
    original_blob = ActiveStorage::Blob.find(blob_id)
    retry_attempts = 0

    Rails.logger.info("Processing blob #{blob_id}: processed flag = #{original_blob.metadata['processed'].inspect}")    
    if original_blob.metadata['processed'] == true
      Rails.logger.info("#################\/nBlob #{blob_id} has metadata['processed'=>true]. Skipping processing ################.")
      return
    end

    download_blob_to_tempfile(original_blob) do |tempfile|
      processed_image = process_image(tempfile.path, width, height)
      new_blob = create_new_blob(processed_image, original_blob)
      new_blob.update!(metadata: new_blob.metadata.merge('processed' => true))

      ApplicationRecord.transaction do
        attach_new_blob(new_blob, original_blob, image_association_name)
      end

      processed_image.close
      processed_image.unlink

      
      if image_association_name.to_s == 'photos'
        PurgeBlobJob.set(wait: 1.second).perform_later(original_blob.id)
      end
    end
  rescue => e
    retry_attempts += 1
    Rails.logger.error("Failed to process and replace image: #{e.message}")
    if retry_attempts < 3
      retry
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
        post.save!(validate: false)
      elsif image_association_name.to_s == 'profile_photo'
        user = original_blob.attachments.last.record
        user.profile_photo.attach(new_blob)
        user.save!(validate: false)
      end
    end
  end

end
