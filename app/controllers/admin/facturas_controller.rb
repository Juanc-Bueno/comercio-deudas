module Admin
  class FacturasController < BaseController
    before_action :set_factura, only: [ :show, :edit, :update, :destroy ]
    before_action :set_proveedores, only: [ :new, :create, :edit, :update ]

    def index
      @facturas = Factura.includes(:proveedor).order(fecha_vencimiento: :asc)
    end

    def show
      @pagos = @factura.pagos.includes(:medio_de_pago, :usuario).order(fecha: :desc)
    end

    def new
      @factura = Factura.new(proveedor_id: params[:proveedor_id],
                             fecha_emision: Date.current,
                             fecha_vencimiento: Date.current + 30)
    end

    def edit
    end

    def create
      @factura = Factura.new(factura_params)

      if @factura.save
        redirect_to admin_factura_path(@factura), notice: "Factura creada."
      else
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @factura.update(factura_params)
        redirect_to admin_factura_path(@factura), notice: "Factura actualizada."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @factura.destroy
      redirect_to admin_facturas_path, notice: "Factura eliminada."
    end

    private

    def set_factura
      @factura = Factura.find(params[:id])
    end

    def set_proveedores
      @proveedores = Proveedor.activos.order(:nombre)
    end

    def factura_params
      params.expect(factura: [ :proveedor_id, :numero, :fecha_emision, :fecha_vencimiento, :total ])
    end
  end
end
