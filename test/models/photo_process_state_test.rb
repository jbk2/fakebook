# == Schema Information
#
# Table name: photo_process_states
#
#  id            :bigint           not null, primary key
#  attachment_id :bigint           not null
#  processed     :boolean          default(FALSE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class PhotoProcessStateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
