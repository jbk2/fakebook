class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id, width: nil, height: nil, retry_attempts: 0)
    @original_blob = ActiveStorage::Blob.find_by(id: blob_id)

    return Rails.logger.info("Blob with ID #{blob_id} no longer exists. Exiting job.") unless @original_blob
    return if @original_blob.metadata['processed']
    
    @owning_record = @original_blob.attachments.first.record
    orig_img_tempfile, processed_img = create_img_tempfile, nil

    begin
      processed_img = process_img(orig_img_tempfile.path, width, height)
      new_blob = create_new_blob(processed_img)
      attach_new_blob(new_blob)
      PurgeBlobJob.perform_later(@original_blob.id) if @owning_record.is_a?(Post)
      #No need to purge the User.profile_photo original blob as it's a has_one_attachment so it gets overwritten
    rescue ActiveRecord::RecordNotFound => e
      # Specifically catch and log missing records without retrying
      Rails.logger.error("Record not found: #{e.message}. No retry will be performed.")
    rescue => e
      retry_attempts += 1
      Rails.logger.error("Failed to process and replace image on attempt #{retry_attempts}: #{e.message}\nBacktrace:\n#{e.backtrace.join("\n")}")
      if retry_attempts < 3
        Rails.logger.info("Retrying processing blob #{blob_id}, attempt #{retry_attempts + 1}")
        perform(blob_id, width: width, height: height, retry_attempts: retry_attempts)
      else
        Rails.logger.error("##################### All retry attempts failed for blob #{blob_id}")
      end
      raise
    ensure
      orig_img_tempfile&.close; orig_img_tempfile&.unlink
      processed_img&.close; processed_img&.unlink
    end
  end

  private
  def create_img_tempfile
    tempfile = Tempfile.new(@original_blob.filename.to_s)
    tempfile.binmode
    @original_blob.download { |chunk| tempfile.write(chunk) }
    tempfile.rewind
    tempfile
  end

  def process_img(img_path, width, height)
    processed_file = Tempfile.new(['processed', '.jpg'])

    ImageProcessing::Vips
      .source(img_path)
      .resize_to_fill(width || 1000, height || 1000)
      .call(destination: processed_file.path)
    
      processed_file
  end

  def create_new_blob(processed_img)
    File.open(processed_img.path, 'rb') do |file|
      ActiveStorage::Blob.create_and_upload!(
        io: file, filename: @original_blob.filename, content_type: @original_blob.content_type
        )
    end
  end

  def attach_new_blob(new_blob)
    ApplicationRecord.transaction do
      case @owning_record
      when Post
        @owning_record.photos.attach(new_blob)
      when User
        @owning_record.profile_photo.attach(new_blob)
      else
        Rails.logger.error("Unsupported owning record type for blob attachment")
        return
      end
      @owning_record.save!(validate: false)
      new_blob.update!(metadata: new_blob.metadata.merge('processed' => true))
    end
  end

end
