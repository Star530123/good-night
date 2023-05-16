# == Schema Information
#
# Table name: sleep_records
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  clock_in   :datetime         not null
#  clock_out  :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SleepRecord < ApplicationRecord
end
