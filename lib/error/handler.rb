module Error
  module Handler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from StandardError, with: :standard_error
      end
    end

    private

    def standard_error(e)
      render json: {
        error: e.error,
        status: 500,
        message: e.to_s
      }, status: 500
    end
  end
end