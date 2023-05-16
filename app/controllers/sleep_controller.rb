class SleepController < ApplicationController
  def clock_in
    user = User.find_by!(id: clock_in_params)
    sleep_record = user.sleep_records.last
    raise "You haven't clocked out!" if sleep_record && sleep_record.clock_out.nil?

    new_sleep_record = SleepRecord.create(user: user, clock_in: Time.now)
    render json: { clock_in: new_sleep_record.clock_in }, status: :ok
  end

  def clock_out
    user = User.find_by!(id: clock_in_params)
    sleep_record = user.sleep_records.last
    raise "You haven't clocked in!" if sleep_record.nil? || sleep_record.clock_in.nil?
    raise 'You have clocked out!' if sleep_record.clock_out.present?

    sleep_record.update!(clock_out: Time.now)
    render json: { clock_in: sleep_record.clock_in, clock_out: sleep_record.clock_out }, status: :ok
  end

  private

  def clock_in_params
    params.require(:user_id)
  end

  def clock_out_params
    params.require(:user_id)
  end
end
