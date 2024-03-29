##################################################################################################
# CAVEAT - written by AI and not manually inspected
##################################################################################################

require 'rails_helper'

RSpec.describe ProcessImageJob, type: :job do
  include ActiveJob::TestHelper

  let(:blob_id) { 1 }
  let(:blob_double) {
    instance_double(ActiveStorage::Blob,
                    id: blob_id,
                    filename: 'test.jpg',
                    content_type: 'image/jpeg',
                    metadata: {'processed' => false})
  }
  let(:new_blob_double) {
    instance_double(ActiveStorage::Blob,
                    id: 2,
                    filename: 'processed_test.jpg',
                    content_type: 'image/jpeg',
                    metadata: {'processed' => true})
  }
  let(:post) { instance_double(Post) }
  let(:attachment_double) { instance_double(ActiveStorage::Attachment, record: post, blob: blob_double) }

  before do
    allow(ActiveStorage::Blob).to receive(:find_by).with(id: blob_id).and_return(blob_double)
    allow(blob_double).to receive(:attachments).and_return([attachment_double])
    allow(blob_double).to receive(:download).and_yield(StringIO.new('image data'))
    allow(ActiveStorage::Blob).to receive(:create_and_upload!).and_return(new_blob_double)

    # Stubbing the Rails logger to prevent actual logging during tests
    allow(Rails.logger).to receive(:info)
    allow(Rails.logger).to receive(:error)
    
    # Stubbing the job retry mechanism to prevent actual retries during tests
    allow_any_instance_of(ProcessImageJob).to receive(:retry_job)

    # Stubbing external calls within private methods
    allow_any_instance_of(ProcessImageJob).to receive(:create_img_tempfile).and_return(Tempfile.new)
    allow_any_instance_of(ProcessImageJob).to receive(:process_img).and_return(Tempfile.new)
    allow_any_instance_of(ProcessImageJob).to receive(:attach_new_blob)
    
    # Assume PurgeBlobJob performs correctly
    allow(PurgeBlobJob).to receive(:perform_later)
  end

  describe '#perform' do
    context 'when blob exists and is not processed' do
      it 'processes and attaches a new blob' do
        expect_any_instance_of(ProcessImageJob).to receive(:create_img_tempfile)
        expect_any_instance_of(ProcessImageJob).to receive(:process_img)
        expect_any_instance_of(ProcessImageJob).to receive(:create_new_blob).and_return(new_blob_double)
        expect_any_instance_of(ProcessImageJob).to receive(:attach_new_blob).with(new_blob_double)

        ProcessImageJob.perform_now(blob_id, width: 500, height: 500)
      end
    end

    context 'when blob does not exist' do
      it 'logs information and exits' do
        allow(ActiveStorage::Blob).to receive(:find_by).with(id: blob_id).and_return(nil)
        expect(Rails.logger).to receive(:info).with("Blob with ID #{blob_id} no longer exists. Exiting job.")

        ProcessImageJob.perform_now(blob_id, width: 500, height: 500)
      end
    end

    context 'when retrying due to an error' do
      it 'retries the job up to 5 times then logs an error' do
        allow_any_instance_of(ProcessImageJob).to receive(:process_img).and_raise('Some error')
        expect(Rails.logger).to receive(:error).exactly(5).times
        expect { ProcessImageJob.perform_now(blob_id, width: 500, height: 500) }.to raise_error('Some error')
      end
    end
  end
end
