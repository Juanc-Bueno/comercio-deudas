module Admin
  class BaseController < ApplicationController
    layout "admin"

    before_action :requerir_administrador

    private

    def usuario_actual
      @usuario_actual ||= Usuario.find_by(id: session[:usuario_id])
    end
    helper_method :usuario_actual

    def requerir_administrador
      return if usuario_actual&.admin?

      mensaje = if usuario_actual
        "Tu usuario no tiene permisos para el back-office."
      else
        "Iniciá sesión para continuar."
      end

      redirect_to new_admin_session_path, alert: mensaje
    end
  end
end
