module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :requerir_usuario, only: [ :create ]

      def create
        @usuario = Usuario.authenticate_by(email: params[:email].to_s, password: params[:password].to_s)

        if @usuario
          @usuario.regenerate_token
          render :create, status: :created
        else
          render json: { error: "Email o contraseña inválidos." }, status: :unauthorized
        end
      end

      def destroy
        usuario_actual.regenerate_token
        head :no_content
      end
    end
  end
end
