module Admin
  class SessionsController < BaseController
    skip_before_action :requerir_administrador, only: [ :new, :create ]

    def new
    end

    def create
      usuario = Usuario.find_by(email: params[:email].to_s.strip.downcase)

      if !usuario&.authenticate(params[:password])
        flash.now[:alert] = "Email o contraseña inválidos."
        render :new, status: :unprocessable_content
      elsif !usuario.admin?
        flash.now[:alert] = "Tu usuario no tiene permisos para el back-office."
        render :new, status: :unprocessable_content
      else
        reset_session
        session[:usuario_id] = usuario.id
        redirect_to admin_root_path, notice: "Bienvenido, #{usuario.nombre}."
      end
    end

    def destroy
      reset_session
      redirect_to new_admin_session_path, notice: "Sesión cerrada."
    end
  end
end
