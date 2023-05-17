class SleepController < ApplicationController
  def clock_in
    user = User.find_by!(id: user_id_from_param)
    sleep_record = user.sleep_records.last
    raise "You haven't clocked out!" if sleep_record && sleep_record.clock_out.nil?

    new_sleep_record = SleepRecord.create(user: user, clock_in: Time.now)
    render json: { clock_in: new_sleep_record.clock_in }, status: :ok
  end

  def clock_out
    user = User.find_by!(id: user_id_from_param)
    sleep_record = user.sleep_records.last
    raise "You haven't clocked in!" if sleep_record.nil? || sleep_record.clock_in.nil?
    raise 'You have clocked out!' if sleep_record.clock_out.present?

    sleep_record.update!(clock_out: Time.now)
    render json: { clock_in: sleep_record.clock_in, clock_out: sleep_record.clock_out }, status: :ok
  end

  def clocked_in_times
    user = User.find_by!(id: user_id_from_param)
    sleep_records = user.sleep_records.order(created_at: :desc)
      .map do |sleep_record|
        {
          clock_in: sleep_record.clock_in,
          clock_out: sleep_record.clock_out
        }
    end
    render json: {
      user_id: user.id,
      sleep_records: sleep_records 
    }, status: :ok
  end

  private

  def user_id_from_param
    params.require(:user_id)
  end
end
