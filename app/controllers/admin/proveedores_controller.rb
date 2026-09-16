module Admin
  class ProveedoresController < BaseController
    before_action :set_proveedor, only: [ :show, :edit, :update, :destroy ]

    def index
      @proveedores = Proveedor.order(:nombre)
    end

    def show
      @facturas = @proveedor.facturas.order(fecha_vencimiento: :asc)
    end

    def new
      @proveedor = Proveedor.new
    end

    def edit
    end

    def create
      @proveedor = Proveedor.new(proveedor_params)

      if @proveedor.save
        redirect_to admin_proveedor_path(@proveedor), notice: "Proveedor creado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @proveedor.update(proveedor_params)
        redirect_to admin_proveedor_path(@proveedor), notice: "Proveedor actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      if @proveedor.destroy
        redirect_to admin_proveedores_path, notice: "Proveedor eliminado."
      else
        redirect_to admin_proveedor_path(@proveedor), alert: @proveedor.errors.full_messages.to_sentence
      end
    end

    private

    def set_proveedor
      @proveedor = Proveedor.find(params[:id])
    end

    def proveedor_params
      params.expect(proveedor: [ :nombre, :cuit, :email, :telefono, :direccion, :activo ])
    end
  end
end
