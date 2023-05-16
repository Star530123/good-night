class CreateSleepRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_records do |t|
      t.bigint :user_id, null: false
      t.datetime :clock_in, null: false, precision: 0
      t.datetime :clock_out, precision: 0
      t.timestamps
    end
  end
end
