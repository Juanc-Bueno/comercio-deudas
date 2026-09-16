module Admin
  class UsuariosController < BaseController
    before_action :set_usuario, only: [ :edit, :update, :destroy ]

    def index
      @usuarios = Usuario.order(:nombre)
    end

    def new
      @usuario = Usuario.new
    end

    def edit
    end

    def create
      @usuario = Usuario.new(usuario_params)

      if @usuario.save
        redirect_to admin_usuarios_path, notice: "Usuario creado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @usuario.update(usuario_params)
        redirect_to admin_usuarios_path, notice: "Usuario actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      if @usuario == usuario_actual
        redirect_to admin_usuarios_path, alert: "No podés eliminar tu propio usuario."
      elsif @usuario.destroy
        redirect_to admin_usuarios_path, notice: "Usuario eliminado."
      else
        redirect_to admin_usuarios_path, alert: @usuario.errors.full_messages.to_sentence
      end
    end

    private

    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    def usuario_params
      atributos = params.expect(usuario: [ :nombre, :email, :rol, :password, :password_confirmation ])
      return atributos if atributos[:password].present?

      # Dejar la contraseña en blanco al editar significa conservar la actual.
      atributos.except(:password, :password_confirmation)
    end
  end
end
