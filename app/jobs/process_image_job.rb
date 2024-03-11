class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(blob_id)
    blob = ActiveStorage::Blob.find(blob_id)
    post = blob.attachments.first.record
    
    download_blob_to_tempfile(blob) do |tempfile|
      processed_image = process_image(tempfile.path)
      post.photos.attach(io: File.open(processed_image.path),
        filename: "processed_#{blob.filename}",
        content_type: blob.content_type)
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
