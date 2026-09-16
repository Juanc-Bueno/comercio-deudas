module Admin
  class PagosController < BaseController
    before_action :set_factura, only: [ :new, :create ]
    before_action :set_pago, only: [ :edit, :update, :destroy ]
    before_action :set_medios_de_pago, only: [ :new, :create, :edit, :update ]

    def new
      @pago = @factura.pagos.new(fecha: Date.current)
    end

    def create
      @pago = @factura.pagos.new(pago_params)
      @pago.usuario = usuario_actual

      if @pago.save
        redirect_to admin_factura_path(@factura), notice: "Pago registrado."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
    end

    def update
      if @pago.update(pago_params)
        redirect_to admin_factura_path(@pago.factura), notice: "Pago actualizado."
      else
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      factura = @pago.factura
      @pago.destroy
      redirect_to admin_factura_path(factura), notice: "Pago eliminado."
    end

    private

    def set_factura
      @factura = Factura.find(params[:factura_id])
    end

    def set_pago
      @pago = Pago.find(params[:id])
    end

    def set_medios_de_pago
      @medios_de_pago = MedioDePago.activos.order(:nombre)
    end

    def pago_params
      params.expect(pago: [ :monto, :fecha, :medio_de_pago_id ])
    end
  end
end
