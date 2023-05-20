module Error
  module Handler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from NotImplementedError, with: :non_implement_error
        rescue_from StandardError, with: :standard_error
      end
    end

    private

    def non_implement_error(e)
      render_error_message(error: :non_implement_error, status: 500, message: e.to_s)
    end

    def standard_error(e)
      render_error_message(error: :standard_error, status: 500, message: e.to_s)
    end

    def render_error_message(error:, status:, message:)
      render json: {
        error: error,
        status: status,
        message: message
      }, status: status
    end
  end
end