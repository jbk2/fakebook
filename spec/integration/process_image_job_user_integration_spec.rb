# Unit
  # test that blob is downloaded
  # test that blob is processed into a new File
  # test that a new blob is created
  # test that new blob is attached to the owning record
  # handles a non-existent blob gracefully
# Integration
  # test that post#create with photos enqueues process_image_job
  # test that user#create with profile_photo enqueues process_image_job

  require 'rails_helper'

  describe ProcessImageJob, type: :job do
    include ActiveJob::TestHelper
    let(:user) { FactoryBot.build(:user) }
  
    before do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  
    describe '#perform' do
      it "replaces user's original profile_photo blob with a processed blob" do
        original_blob_id = user.profile_photo.blob.id
        # puts "user.profile_photo attached t/f? #{user.profile_photo.attached?}"
        # puts "user.profile_photo inspect: #{user.profile_photo.inspect}"
        # puts "original_blob_id is still nill because blob's not created as user not saved yet, blob.id#nil? #{original_blob_id.nil?}"
        
        expect { user.save }.to have_enqueued_job(ProcessImageJob)
          .and change(ActiveStorage::Attachment, :count).by(1)
          .and change(ActiveStorage::Blob, :count).by(1)
        
        # puts "\npre-processing blob byte_size= #{user.profile_photo.blob.byte_size}"
        pre_jobs_byte_size = user.profile_photo.blob.byte_size
        perform_enqueued_jobs        
        user.reload
        user.profile_photo.blob.reload
        # puts "post-processing blob byte_size= #{user.profile_photo.blob.byte_size}\n\n"

        expect(user.profile_photo.blob.metadata['processed']).to be true
        expect(pre_jobs_byte_size).to be > user.profile_photo.blob.byte_size
      end
    end

    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
    
  end