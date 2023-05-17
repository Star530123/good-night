module Utils
  module Time
    class << self
      def elapsed_time_format(seconds)
        return unless seconds.is_a? Integer

        hours, seconds = seconds.divmod(3600)
        minutes, seconds = seconds.divmod(60)

        format('%02d:%02d:%02d', hours, minutes, seconds)
      end
    end
  end
end