class AddSleepLengthToSleepRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :sleep_records, :sleep_length_seconds, :int, after: :clock_out
  end
end
