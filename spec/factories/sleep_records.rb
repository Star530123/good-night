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
FactoryBot.define do
  factory :sleep_record do

    after(:build) do |record|
      record.created_at = record.clock_in
    end
  end
end
