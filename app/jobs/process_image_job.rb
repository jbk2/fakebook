class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id, image_association_name, width: nil, height: nil, retry_attempts: 0)
    original_blob = ActiveStorage::Blob.find(blob_id)
    record = original_blob.attachments.first.record

    Rails.logger.info("Processing blob #{blob_id}: processed flag = #{original_blob.metadata['processed'].inspect}")    
    if original_blob.metadata['processed'] == true
      Rails.logger.info("#################\/nBlob #{blob_id} has metadata['processed'=>true]. Skipping processing ################.")
      return
    end

    download_blob_to_tempfile(original_blob) do |tempfile|
      processed_image = process_image(tempfile.path, width, height)
      new_blob = create_new_blob(processed_image, original_blob)

      ApplicationRecord.transaction do
        attach_new_blob(new_blob, original_blob, record, image_association_name)
      end

      processed_image.close
      processed_image.unlink

      
      if image_association_name.to_s == 'photos'
        PurgeBlobJob.set(wait: 20.seconds).perform_later(original_blob.id)
      end
    end
  rescue => e
    retry_attempts += 1
    Rails.logger.error("Failed to process and replace image on attempt #{retry_attempts}: #{e.message}\nBacktrace:\n#{e.backtrace.join("\n")}")
    if retry_attempts < 3
      Rails.logger.info("Retrying processing blob #{blob_id}, attempt #{retry_attempts + 1}")
      perform(blob_id, image_association_name, width: width, height: height, retry_attempts: retry_attempts)
    else
      Rails.logger.error("All retry attempts failed for blob #{blob_id}")
      return
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

  def attach_new_blob(new_blob, original_blob, record, image_association_name)
    ApplicationRecord.transaction do
      if image_association_name.to_s == 'photos'
        Rails.logger.info("######################### Original Blob is #{original_blob.inspect}")
        record.photos.attach(new_blob)
        record.save!(validate: false)
      elsif image_association_name.to_s == 'profile_photo'
        user = original_blob.attachments.last.record
        record.profile_photo.attach(new_blob)
        record.save!(validate: false)
      end
      new_blob.update!(metadata: new_blob.metadata.merge('processed' => true))
    end
  end

end
