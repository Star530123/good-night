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
class SleepRecord < ApplicationRecord
  belongs_to :user

  before_save :calculate_sleep_length, if: :clock_in_and_out?
  scope :complete, -> { where.not(clock_out: nil) }

  private

  def clock_in_and_out?
    clock_in.present? && clock_out.present?
  end

  def calculate_sleep_length
    self.sleep_length_seconds = (clock_out - clock_in).to_i
  end
end
