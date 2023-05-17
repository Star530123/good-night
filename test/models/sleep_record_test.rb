# == Schema Information
#
# Table name: sleep_records
#
#  id                   :bigint           not null, primary key
#  user_id              :bigint           not null
#  clock_in             :datetime         not null
#  clock_out            :datetime
#  sleep_length_seconds :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "test_helper"

class SleepRecordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
