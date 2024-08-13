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

  let(:user) { FactoryBot.create(:user) }
  let(:post_with_one_jpg) { FactoryBot.create(:post_with_photos, user: user, photos_count: 1) }
  let(:post_with_one_jpgs_blob) { post_with_one_jpg.photos.first.blob }
  let(:post_with_two_jpgs) { FactoryBot.create(:post_with_photos, user: user, photos_count: 2) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  describe '#perform' do

    it 'adds new processed blobs to, and purges original blobs from, a post' do
      original_blob_id = post_with_one_jpg.photos[0].blob.id

      post_with_one_jpg.photos.each do |photo|
        expect {
          perform_enqueued_jobs do
            ProcessImageJob.perform_now(photo.blob.id, width: 500, height: 500)
          end
        }.to change(ActiveStorage::Attachment, :count).by(1)
        .and change(ActiveStorage::Blob, :count).by(1)
      end

      post_with_one_jpg.reload

      new_blob_id = post_with_one_jpg.photos.last.blob.id

      expect { ActiveStorage::Blob.find(original_blob_id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(new_blob_id).not_to eq(original_blob_id)
      expect(post_with_one_jpg.photos.blobs.count).to eq 1
      expect(post_with_one_jpg.photos[0].blob.metadata['processed']).to be true
      expect(post_with_one_jpg.photos[0].blob.metadata['width']).to eq 500
      expect(post_with_one_jpg.photos[0].blob.metadata['height']).to eq 500
    end

  end
  
end