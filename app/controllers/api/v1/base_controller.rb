module Api
  module V1
    class BaseController < ActionController::API
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :requerir_usuario

      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "No se encontró el recurso." }, status: :not_found
      end

      rescue_from ActionController::ParameterMissing do |error|
        render json: { error: error.message }, status: :bad_request
      end

      private

      def usuario_actual
        @usuario_actual ||= authenticate_with_http_token do |token|
          Usuario.find_by(token: token)
        end
      end

      def requerir_usuario
        return if usuario_actual

        render json: { error: "Token inválido o ausente." }, status: :unauthorized
      end
    end
  end
end
